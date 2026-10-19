import 'package:comma/domain/dates.dart';

DateTime d(int y, int m, int day) => DateTime.utc(y, m, day);

/// Bleeding days for periods starting at each of [starts], [len] days each.
List<DateTime> periods(List<DateTime> starts, {int len = 5}) => [
      for (final s in starts)
        for (var i = 0; i < len; i++) addDays(s, i),
    ];

/// Period start dates spaced by [lengths], beginning at [first].
List<DateTime> startsFrom(DateTime first, List<int> lengths) {
  final starts = [first];
  for (final l in lengths) {
    starts.add(addDays(starts.last, l));
  }
  return starts;
}
