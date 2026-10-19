import '../dates.dart';
import '../models/cycle.dart';

/// Groups bleeding days into periods and returns the resulting cycles, oldest
/// first.
///
/// Bleeding days separated by at most [maxGap] non-bleeding days belong to the
/// same period, so a missed log in the middle of a period doesn't split it.
List<Cycle> buildCycles(Iterable<DateTime> bleedingDays, {int maxGap = 2}) {
  final days = bleedingDays.map(dateOnly).toSet().toList()..sort();
  if (days.isEmpty) return const [];

  final periods = <(DateTime, DateTime)>[];
  var start = days.first;
  var end = days.first;
  for (final day in days.skip(1)) {
    if (daysBetween(end, day) > maxGap + 1) {
      periods.add((start, end));
      start = day;
    }
    end = day;
  }
  periods.add((start, end));

  return [
    for (var i = 0; i < periods.length; i++)
      Cycle(
        start: periods[i].$1,
        periodEnd: periods[i].$2,
        nextStart: i + 1 < periods.length ? periods[i + 1].$1 : null,
      ),
  ];
}
