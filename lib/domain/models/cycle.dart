import '../dates.dart';

/// One menstrual cycle: from the first day of a period to the day before the
/// next period starts.
class Cycle {
  const Cycle({required this.start, required this.periodEnd, this.nextStart});

  /// First day of bleeding.
  final DateTime start;

  /// Last bleeding day of this cycle's period.
  final DateTime periodEnd;

  /// Start of the following period, or null for the current cycle.
  final DateTime? nextStart;

  bool get isComplete => nextStart != null;

  int get periodLength => daysBetween(start, periodEnd) + 1;

  int? get length => nextStart == null ? null : daysBetween(start, nextStart!);

  @override
  bool operator ==(Object other) =>
      other is Cycle &&
      other.start == start &&
      other.periodEnd == periodEnd &&
      other.nextStart == nextStart;

  @override
  int get hashCode => Object.hash(start, periodEnd, nextStart);

  @override
  String toString() => 'Cycle($start..$periodEnd, next: $nextStart)';
}
