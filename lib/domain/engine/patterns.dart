import '../dates.dart';
import '../models/cycle.dart';
import 'status.dart';

class SymptomPattern {
  const SymptomPattern(this.symptom, this.byPhase);

  final String symptom;

  /// How many logged days fell in each phase.
  final Map<Phase, int> byPhase;

  int get total => byPhase.values.fold(0, (a, b) => a + b);

  /// The phase with the most logged days.
  Phase get peakPhase =>
      byPhase.entries.reduce((a, b) => b.value > a.value ? b : a).key;
}

/// Groups logged symptoms by the cycle phase they happened in, for complete
/// cycles only. [ovulations] maps cycle starts to known ovulation days;
/// otherwise ovulation is assumed [lutealLength] days before the next period.
/// Returns symptoms logged at least [minDays] times, most frequent first.
List<SymptomPattern> symptomPatterns(
  List<Cycle> cycles,
  Iterable<(DateTime, String)> entries, {
  Map<DateTime, DateTime> ovulations = const {},
  int lutealLength = 14,
  int minDays = 3,
}) {
  final counts = <String, Map<Phase, int>>{};
  for (final (date, symptom) in entries) {
    final day = dateOnly(date);
    final cycle = cycles.where(
      (c) =>
          c.isComplete && !day.isBefore(c.start) && day.isBefore(c.nextStart!),
    );
    if (cycle.isEmpty) continue;
    final c = cycle.first;
    final ovulation =
        ovulations[c.start] ?? addDays(c.nextStart!, -lutealLength);

    final Phase phase;
    if (!day.isAfter(c.periodEnd)) {
      phase = Phase.period;
    } else if (day == ovulation) {
      phase = Phase.ovulation;
    } else if (!day.isBefore(addDays(ovulation, -5)) &&
        !day.isAfter(addDays(ovulation, 1))) {
      phase = Phase.fertile;
    } else if (day.isAfter(ovulation)) {
      phase = Phase.luteal;
    } else {
      phase = Phase.follicular;
    }
    final byPhase = counts.putIfAbsent(symptom, () => {});
    byPhase[phase] = (byPhase[phase] ?? 0) + 1;
  }

  return [
    for (final e in counts.entries)
      if (e.value.values.fold(0, (a, b) => a + b) >= minDays)
        SymptomPattern(e.key, e.value),
  ]..sort((a, b) => b.total.compareTo(a.total));
}

/// Spread of complete cycle lengths, or null with fewer than 2 cycles.
({int shortest, int longest})? cycleLengthRange(List<Cycle> cycles) {
  final lengths = [
    for (final c in cycles)
      if (c.isComplete) c.length!,
  ];
  if (lengths.length < 2) return null;
  lengths.sort();
  return (shortest: lengths.first, longest: lengths.last);
}
