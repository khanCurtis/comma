import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/connection.dart';
import '../data/db/database.dart';
import '../domain/dates.dart';
import '../domain/engine/cycle_builder.dart';
import '../domain/engine/irregularity.dart';
import '../domain/engine/ovulation.dart';
import '../domain/engine/patterns.dart';
import '../domain/engine/predictor.dart';
import '../domain/models/cycle.dart';
import '../domain/medication_schedule.dart';
import '../domain/modes.dart';
import '../domain/reminders.dart';
import '../domain/units.dart';
import '../features/reminders/notification_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openAppDatabase());
  ref.onDispose(db.close);
  return db;
});

/// Setting keys stored in the database.
abstract final class SettingKeys {
  static const onboarded = 'onboarded';
  static const cycleLength = 'default_cycle_length';
  static const periodLength = 'default_period_length';
  static const lastBackup = 'last_backup';
  static const tempUnit = 'temp_unit';
  static const weightUnit = 'weight_unit';
  static const periodReminderDays = 'reminder_period_days';
  static const periodReminderMinute = 'reminder_period_minute';
  static const dailyLogReminderMinute = 'reminder_daily_minute';
  static const discreetNotifications = 'reminders_discreet';
  static const fertileReminder = 'reminder_fertile';
  static const mode = 'mode';
  static const pregnancyLastPeriod = 'pregnancy_lmp';
  static const birthDate = 'birth_date';
  static const breastfeeding = 'breastfeeding';

  /// Comma-separated cycle start dates left out of averages (YYYY-MM-DD).
  static const excludedCycles = 'excluded_cycles';
}

final settingProvider = StreamProvider.family<String?, String>(
  (ref, key) => ref.watch(databaseProvider).watchSetting(key),
);

final todayProvider = Provider<DateTime>((ref) => dateOnly(DateTime.now()));

final modeProvider = Provider<TrackingMode>(
  (ref) =>
      TrackingMode.values.asNameMap()[ref
          .watch(settingProvider(SettingKeys.mode))
          .value] ??
      TrackingMode.standard,
);

DateTime? _dateSetting(Ref ref, String key) {
  final d = DateTime.tryParse(ref.watch(settingProvider(key)).value ?? '');
  return d == null ? null : dateOnly(d);
}

final pregnancyLastPeriodProvider = Provider(
  (ref) => _dateSetting(ref, SettingKeys.pregnancyLastPeriod),
);

final birthDateProvider = Provider(
  (ref) => _dateSetting(ref, SettingKeys.birthDate),
);

final excludedCyclesProvider = Provider<Set<DateTime>>(
  (ref) => {
    for (final s
        in (ref.watch(settingProvider(SettingKeys.excludedCycles)).value ?? '')
            .split(','))
      if (DateTime.tryParse(s) case final d?) dateOnly(d),
  },
);

final cyclesProvider = StreamProvider<List<Cycle>>((ref) {
  final birth = ref.watch(modeProvider) == TrackingMode.postpartum
      ? ref.watch(birthDateProvider)
      : null;
  return ref
      .watch(databaseProvider)
      .watchBleedingDays()
      .map(
        (days) => buildCycles(
          birth == null ? days : withoutPostpartumBleeding(days, birth),
        ),
      );
});

/// Cycles that predictions and flags learn from. After giving birth only
/// cycles since the birth count, since earlier ones no longer reflect
/// your body.
final _predictiveCyclesProvider = Provider<List<Cycle>>((ref) {
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  final birth = ref.watch(birthDateProvider);
  if (ref.watch(modeProvider) == TrackingMode.postpartum && birth != null) {
    return cycles.where((c) => c.start.isAfter(birth)).toList();
  }
  return cycles;
});

final statsProvider = Provider<CycleStats?>(
  (ref) => computeStats(
    ref.watch(cyclesProvider).value ?? const [],
    excludedStarts: ref.watch(excludedCyclesProvider),
  ),
);

final fertilitySignalsProvider = StreamProvider<List<FertilitySignal>>(
  (ref) => ref
      .watch(databaseProvider)
      .watchFertilitySignals()
      .map(
        (logs) => [
          for (final l in logs)
            FertilitySignal(
              l.date,
              bbt: l.bbt,
              bbtDisturbed: l.bbtDisturbed,
              lh: l.lhTest,
            ),
        ],
      ),
);

/// Confirmed ovulation per cycle start, from temperature or LH tests.
final ovulationsProvider = Provider<Map<DateTime, ConfirmedOvulation>>((ref) {
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  final signals = ref.watch(fertilitySignalsProvider).value ?? const [];
  return confirmOvulations(cycles, signals);
});

final lutealLengthProvider = Provider<int>((ref) {
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  final ovulations = ref.watch(ovulationsProvider);
  return personalLutealLength(cycles, {
    for (final e in ovulations.entries) e.key: e.value.date,
  });
});

final symptomPatternsProvider = Provider<List<SymptomPattern>>((ref) {
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  final entries =
      ref.watch(_allSymptomEntriesProvider).value ?? const <SymptomEntry>[];
  return symptomPatterns(
    cycles,
    [for (final e in entries) (e.date, e.symptom)],
    ovulations: {
      for (final e in ref.watch(ovulationsProvider).entries)
        e.key: e.value.date,
    },
    lutealLength: ref.watch(lutealLengthProvider),
  );
});

final _allSymptomEntriesProvider = StreamProvider(
  (ref) => ref.watch(databaseProvider).watchAllSymptomEntries(),
);

final predictionsProvider = Provider<List<CyclePrediction>>((ref) {
  if (ref.watch(modeProvider) == TrackingMode.pregnant) return const [];
  final cycles = ref.watch(_predictiveCyclesProvider);
  int? setting(String key) =>
      int.tryParse(ref.watch(settingProvider(key)).value ?? '');
  return predictUpcoming(
    cycles,
    count: 6,
    defaultCycleLength: setting(SettingKeys.cycleLength) ?? 28,
    defaultPeriodLength: setting(SettingKeys.periodLength) ?? 5,
    lutealLength: ref.watch(lutealLengthProvider),
    excludedStarts: ref.watch(excludedCyclesProvider),
    currentOvulation: cycles.isEmpty
        ? null
        : ref.watch(ovulationsProvider)[cycles.last.start]?.date,
  );
});

final irregularitiesProvider = Provider<List<Irregularity>>((ref) {
  final excluded = ref.watch(excludedCyclesProvider);
  final cycles = ref
      .watch(_predictiveCyclesProvider)
      .where((c) => !excluded.contains(c.start))
      .toList();
  return findIrregularities(
    cycles,
    today: ref.watch(todayProvider),
    pregnant: ref.watch(modeProvider) == TrackingMode.pregnant,
  );
});

bool get _usesImperial =>
    PlatformDispatcher.instance.locale.countryCode == 'US';

final tempUnitProvider = Provider<TempUnit>((ref) {
  final stored = ref.watch(settingProvider(SettingKeys.tempUnit)).value;
  return TempUnit.values.asNameMap()[stored] ??
      (_usesImperial ? TempUnit.fahrenheit : TempUnit.celsius);
});

final weightUnitProvider = Provider<WeightUnit>((ref) {
  final stored = ref.watch(settingProvider(SettingKeys.weightUnit)).value;
  return WeightUnit.values.asNameMap()[stored] ??
      (_usesImperial ? WeightUnit.lb : WeightUnit.kg);
});

final customTagsProvider = StreamProvider(
  (ref) => ref.watch(databaseProvider).watchCustomTags(),
);

final medicationsProvider = StreamProvider(
  (ref) => ref.watch(databaseProvider).watchMedications(),
);

final reminderSettingsProvider = Provider<ReminderSettings>((ref) {
  int? number(String key) =>
      int.tryParse(ref.watch(settingProvider(key)).value ?? '');
  return ReminderSettings(
    periodDaysBefore: number(SettingKeys.periodReminderDays),
    periodMinute: number(SettingKeys.periodReminderMinute) ?? 9 * 60,
    dailyLogMinute: number(SettingKeys.dailyLogReminderMinute),
    discreet:
        ref.watch(settingProvider(SettingKeys.discreetNotifications)).value !=
        'false',
    fertileWindow:
        ref.watch(settingProvider(SettingKeys.fertileReminder)).value == 'true',
  );
});

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

/// The reminders that should currently be scheduled.
final reminderPlanProvider = Provider<List<PlannedNotification>>((ref) {
  final predictions = ref.watch(predictionsProvider);
  return planReminders(
    now: DateTime.now(),
    settings: ref.watch(reminderSettingsProvider),
    nextPeriod: predictions.isEmpty ? null : predictions.first.periodStart,
    fertileStart: predictions.isEmpty ? null : predictions.first.fertileStart,
    meds: [
      for (final m in ref.watch(medicationsProvider).value ?? const [])
        if (m.reminderMinute != null)
          MedReminder(
            id: m.id,
            name: m.name,
            dose: m.dose,
            minute: m.reminderMinute!,
            schedule: MedSchedule(
              start: m.startDate,
              end: m.endDate,
              activeDays: m.activeDays,
              breakDays: m.breakDays,
            ),
          ),
    ],
  );
});
