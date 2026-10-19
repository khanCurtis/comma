import 'dates.dart';

class MedSchedule {
  const MedSchedule({
    required this.start,
    this.end,
    this.activeDays = 0,
    this.breakDays = 0,
  });

  final DateTime start;
  final DateTime? end;

  /// Pill-pack pattern; [breakDays] of 0 means every day.
  final int activeDays;
  final int breakDays;

  bool get hasBreaks => breakDays > 0 && activeDays > 0;

  /// Whether a dose is due on [day].
  bool isDueOn(DateTime day) {
    final d = dateOnly(day);
    if (d.isBefore(dateOnly(start))) return false;
    if (end != null && d.isAfter(dateOnly(end!))) return false;
    if (!hasBreaks) return true;
    return daysBetween(start, d) % (activeDays + breakDays) < activeDays;
  }

  /// 1-based day within the current pack, or null without a pack pattern.
  int? packDay(DateTime day) =>
      hasBreaks && !dateOnly(day).isBefore(dateOnly(start))
      ? daysBetween(start, day) % (activeDays + breakDays) + 1
      : null;
}
