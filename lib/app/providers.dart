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
import '../domain/units.dart';

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
}

final settingProvider = StreamProvider.family<String?, String>(
  (ref, key) => ref.watch(databaseProvider).watchSetting(key),
);

final todayProvider = Provider<DateTime>((ref) => dateOnly(DateTime.now()));

final cyclesProvider = StreamProvider<List<Cycle>>(
  (ref) => ref
      .watch(databaseProvider)
      .watchBleedingDays()
      .map((days) => buildCycles(days)),
);

final statsProvider = Provider<CycleStats?>((ref) {
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  return computeStats(cycles);
});

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
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  int? setting(String key) =>
      int.tryParse(ref.watch(settingProvider(key)).value ?? '');
  return predictUpcoming(
    cycles,
    count: 6,
    defaultCycleLength: setting(SettingKeys.cycleLength) ?? 28,
    defaultPeriodLength: setting(SettingKeys.periodLength) ?? 5,
    lutealLength: ref.watch(lutealLengthProvider),
    currentOvulation: cycles.isEmpty
        ? null
        : ref.watch(ovulationsProvider)[cycles.last.start]?.date,
  );
});

final irregularitiesProvider = Provider<List<Irregularity>>((ref) {
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  return findIrregularities(cycles, today: ref.watch(todayProvider));
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
