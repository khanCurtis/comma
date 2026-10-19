import 'package:drift/drift.dart';

import '../../domain/dates.dart';
import '../../domain/models/day_log.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [DayLogs, SymptomEntries, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  Stream<List<DateTime>> watchBleedingDays() {
    final bleeding = [
      for (final f in FlowLevel.values)
        if (f.isBleeding) f.name,
    ];
    final query = select(dayLogs)
      ..where((t) => t.flow.isIn(bleeding))
      ..orderBy([(t) => OrderingTerm.asc(t.date)]);
    return query.map((row) => row.date).watch();
  }

  Stream<List<DayLog>> watchRange(DateTime from, DateTime to) {
    final query = select(dayLogs)
      ..where((t) => t.date.isBetweenValues(dateOnly(from), dateOnly(to)))
      ..orderBy([(t) => OrderingTerm.asc(t.date)]);
    return query.watch();
  }

  Stream<DayLog?> watchDay(DateTime day) => (select(
    dayLogs,
  )..where((t) => t.date.equals(dateOnly(day)))).watchSingleOrNull();

  /// Inserts or updates the log for [entry]'s date. Only the columns present
  /// in [entry] are changed.
  Future<void> saveDay(DayLogsCompanion entry) =>
      into(dayLogs).insert(entry, onConflict: DoUpdate((_) => entry));

  Future<void> setFlow(DateTime day, FlowLevel flow) =>
      saveDay(DayLogsCompanion(date: Value(dateOnly(day)), flow: Value(flow)));

  Stream<Map<String, int>> watchSymptoms(DateTime day) =>
      (select(symptomEntries)..where((t) => t.date.equals(dateOnly(day))))
          .watch()
          .map((rows) => {for (final r in rows) r.symptom: r.severity});

  /// Sets a symptom's severity for a day; a severity of 0 removes it.
  Future<void> setSymptom(DateTime day, String symptom, int severity) async {
    final date = dateOnly(day);
    if (severity <= 0) {
      await (delete(
        symptomEntries,
      )..where((t) => t.date.equals(date) & t.symptom.equals(symptom))).go();
    } else {
      await into(symptomEntries).insertOnConflictUpdate(
        SymptomEntriesCompanion.insert(
          date: date,
          symptom: symptom,
          severity: Value(severity),
        ),
      );
    }
  }

  Stream<String?> watchSetting(String key) =>
      (select(settings)..where((t) => t.key.equals(key)))
          .map((row) => row.value)
          .watchSingleOrNull();

  Future<void> setSetting(String key, String value) => into(settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  /// Permanently deletes every log and setting.
  Future<void> wipe() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });
}
