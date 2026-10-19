import 'package:drift/drift.dart';

import '../../domain/models/day_log.dart';

/// One row per calendar day that has anything logged. Dates are UTC midnight.
class DayLogs extends Table {
  DateTimeColumn get date => dateTime()();
  TextColumn get flow =>
      textEnum<FlowLevel>().withDefault(Constant(FlowLevel.none.name))();
  TextColumn get mucus => textEnum<Mucus>().nullable()();
  RealColumn get bbt => real().nullable()();
  BoolColumn get bbtDisturbed => boolean().withDefault(const Constant(false))();
  TextColumn get lhTest => textEnum<TestResult>().nullable()();
  TextColumn get pregnancyTest => textEnum<TestResult>().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}

/// One row per sexual encounter or masturbation session, so several can be
/// logged on the same day.
class SexEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get kind =>
      textEnum<SexKind>().withDefault(Constant(SexKind.partnered.name))();

  /// Minutes after midnight, if the user recorded a time.
  IntColumn get minuteOfDay => integer().nullable()();

  /// Only meaningful for partnered sex.
  TextColumn get protection => textEnum<SexProtection>().nullable()();
  BoolColumn get orgasm => boolean().nullable()();
  TextColumn get note => text().nullable()();
}

/// Symptoms and moods logged on a day, keyed by a stable identifier such as
/// `cramps` or `mood.anxious`. Custom symptoms use a `custom.` prefix.
class SymptomEntries extends Table {
  DateTimeColumn get date => dateTime()();
  TextColumn get symptom => text()();
  IntColumn get severity => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {date, symptom};
}

/// Simple key/value app settings (onboarding answers, units, mode, etc).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
