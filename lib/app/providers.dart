import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/connection.dart';
import '../data/db/database.dart';
import '../domain/dates.dart';
import '../domain/engine/cycle_builder.dart';
import '../domain/engine/irregularity.dart';
import '../domain/engine/predictor.dart';
import '../domain/models/cycle.dart';

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
