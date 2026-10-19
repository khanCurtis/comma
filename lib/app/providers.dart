import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/connection.dart';
import '../data/db/database.dart';
import '../domain/dates.dart';
import '../domain/engine/cycle_builder.dart';
import '../domain/engine/irregularity.dart';
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

final predictionsProvider = Provider<List<CyclePrediction>>((ref) {
  final cycles = ref.watch(cyclesProvider).value ?? const [];
  int? setting(String key) =>
      int.tryParse(ref.watch(settingProvider(key)).value ?? '');
  return predictUpcoming(
    cycles,
    count: 6,
    defaultCycleLength: setting(SettingKeys.cycleLength) ?? 28,
    defaultPeriodLength: setting(SettingKeys.periodLength) ?? 5,
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
