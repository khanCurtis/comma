import 'dates.dart';
import 'medication_schedule.dart';

class ReminderSettings {
  const ReminderSettings({
    this.periodDaysBefore,
    this.periodMinute = 9 * 60,
    this.dailyLogMinute,
    this.discreet = true,
    this.fertileWindow = false,
  });

  /// Days before the predicted period to remind, or null for off.
  final int? periodDaysBefore;
  final int periodMinute;

  /// Time for a daily "log today" reminder, or null for off.
  final int? dailyLogMinute;

  /// Use neutral wording so notifications reveal nothing on a lock screen.
  final bool discreet;

  /// Remind when the estimated fertile window starts (trying to conceive).
  final bool fertileWindow;
}

class MedReminder {
  const MedReminder({
    required this.id,
    required this.name,
    required this.minute,
    required this.schedule,
    this.dose,
  });

  final int id;
  final String name;
  final String? dose;
  final int minute;
  final MedSchedule schedule;
}

class PlannedNotification {
  const PlannedNotification(this.id, this.when, this.title, this.body);

  final int id;

  /// Local wall-clock time.
  final DateTime when;
  final String title;
  final String body;

  @override
  String toString() => 'Planned($id @ $when: $title / $body)';
}

/// Notifications for the next [days] days after [now], soonest first and
/// capped at [limit] (iOS keeps at most 64 pending).
///
/// Ids are stable: 1 for the period reminder, 2 for the fertile window,
/// 1000+ for daily log
/// reminders, and 100000 + medication id × 100 + day for doses.
List<PlannedNotification> planReminders({
  required DateTime now,
  required ReminderSettings settings,
  DateTime? nextPeriod,
  DateTime? fertileStart,
  List<MedReminder> meds = const [],
  int days = 14,
  int limit = 60,
}) {
  DateTime at(DateTime day, int minute) =>
      DateTime(day.year, day.month, day.day, minute ~/ 60, minute % 60);
  final today = dateOnly(now);
  final discreet = settings.discreet;
  const neutralTitle = 'Comma';
  const neutralBody = 'You have a reminder';

  final planned = <PlannedNotification>[];

  if (settings.periodDaysBefore case final before? when nextPeriod != null) {
    final when = at(addDays(nextPeriod, -before), settings.periodMinute);
    if (when.isAfter(now)) {
      planned.add(
        PlannedNotification(
          1,
          when,
          discreet ? neutralTitle : 'Period coming up',
          discreet
              ? neutralBody
              : before == 0
              ? 'Your period is expected today.'
              : 'Your period is expected in $before '
                    '${before == 1 ? 'day' : 'days'}.',
        ),
      );
    }
  }

  if (settings.fertileWindow && fertileStart != null) {
    final when = at(fertileStart, settings.periodMinute);
    if (when.isAfter(now)) {
      planned.add(
        PlannedNotification(
          2,
          when,
          discreet ? neutralTitle : 'Fertile window',
          discreet
              ? neutralBody
              : 'Your estimated fertile window starts today.',
        ),
      );
    }
  }

  for (var i = 0; i < days; i++) {
    final day = addDays(today, i);
    if (settings.dailyLogMinute case final minute?) {
      final when = at(day, minute);
      if (when.isAfter(now)) {
        planned.add(
          PlannedNotification(
            1000 + i,
            when,
            discreet ? neutralTitle : 'How are you today?',
            discreet ? neutralBody : 'Take a moment to log today.',
          ),
        );
      }
    }
    for (final med in meds) {
      final when = at(day, med.minute);
      if (med.schedule.isDueOn(day) && when.isAfter(now)) {
        planned.add(
          PlannedNotification(
            100000 + med.id * 100 + i,
            when,
            discreet ? neutralTitle : 'Time for ${med.name}',
            discreet ? neutralBody : med.dose ?? 'Tap to open Comma.',
          ),
        );
      }
    }
  }

  planned.sort((a, b) => a.when.compareTo(b.when));
  return planned.take(limit).toList();
}
