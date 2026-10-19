import 'dart:math' as math;

import '../dates.dart';
import '../models/cycle.dart';

enum Confidence { low, medium, high }

class CycleStats {
  const CycleStats({
    required this.cycleLength,
    required this.cycleLengthSd,
    required this.periodLength,
    required this.sampleSize,
  });

  /// Recency-weighted mean cycle length in days.
  final double cycleLength;

  /// Standard deviation of the cycle lengths used.
  final double cycleLengthSd;

  /// Median period length in days.
  final int periodLength;

  /// Number of complete cycles the stats are based on.
  final int sampleSize;
}

class CyclePrediction {
  const CyclePrediction({
    required this.periodStart,
    required this.periodEnd,
    required this.earliestStart,
    required this.latestStart,
    required this.ovulation,
    required this.fertileStart,
    required this.fertileEnd,
    required this.confidence,
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime earliestStart;
  final DateTime latestStart;
  final DateTime ovulation;
  final DateTime fertileStart;
  final DateTime fertileEnd;
  final Confidence confidence;
}

/// Cycles shorter or longer than this are treated as data errors (or events
/// like pregnancy loss) and left out of the averages.
const _plausibleCycleLength = (min: 15, max: 90);

/// Computes stats from the most recent [maxCycles] complete cycles.
/// Cycles whose start date is in [excludedStarts] are ignored.
CycleStats? computeStats(
  List<Cycle> cycles, {
  int maxCycles = 12,
  Set<DateTime> excludedStarts = const {},
}) {
  final usable = cycles
      .where((c) => c.isComplete && !excludedStarts.contains(c.start))
      .where(
        (c) =>
            c.length! >= _plausibleCycleLength.min &&
            c.length! <= _plausibleCycleLength.max,
      )
      .toList();
  if (usable.isEmpty) return null;

  final recent = usable.reversed.take(maxCycles).toList(); // newest first
  final lengths = [for (final c in recent) c.length!.toDouble()];

  // Exponentially decaying weights so recent cycles count for more.
  var weightSum = 0.0;
  var weighted = 0.0;
  for (var i = 0; i < lengths.length; i++) {
    final w = math.pow(0.85, i).toDouble();
    weighted += lengths[i] * w;
    weightSum += w;
  }
  final mean = weighted / weightSum;

  final plainMean = lengths.reduce((a, b) => a + b) / lengths.length;
  final variance = lengths.length < 2
      ? 0.0
      : lengths.map((l) => math.pow(l - plainMean, 2)).reduce((a, b) => a + b) /
            (lengths.length - 1);

  final periodLengths = [for (final c in recent) c.periodLength]..sort();
  final median = periodLengths[periodLengths.length ~/ 2];

  return CycleStats(
    cycleLength: mean,
    cycleLengthSd: math.sqrt(variance),
    periodLength: median,
    sampleSize: lengths.length,
  );
}

/// Predicts the next [count] periods after the most recent one in [cycles].
///
/// [defaultCycleLength] and [defaultPeriodLength] are used until there are
/// complete cycles to learn from (e.g. the values entered during onboarding).
List<CyclePrediction> predictUpcoming(
  List<Cycle> cycles, {
  int count = 1,
  int defaultCycleLength = 28,
  int defaultPeriodLength = 5,
  int lutealLength = 14,
  Set<DateTime> excludedStarts = const {},
}) {
  if (cycles.isEmpty) return const [];

  final stats = computeStats(cycles, excludedStarts: excludedStarts);
  final cycleLength = stats?.cycleLength.round() ?? defaultCycleLength;
  final periodLength = stats?.periodLength ?? defaultPeriodLength;

  final Confidence confidence;
  final int spread;
  if (stats == null || stats.sampleSize < 3) {
    confidence = Confidence.low;
    spread = 3;
  } else {
    spread = math.max(2, stats.cycleLengthSd.ceil());
    confidence = stats.cycleLengthSd <= 3 ? Confidence.high : Confidence.medium;
  }

  final predictions = <CyclePrediction>[];
  var start = cycles.last.start;
  for (var i = 1; i <= count; i++) {
    start = addDays(start, cycleLength);
    final ovulation = addDays(start, -lutealLength);
    predictions.add(
      CyclePrediction(
        periodStart: start,
        periodEnd: addDays(start, periodLength - 1),
        // Uncertainty grows with each cycle we predict ahead.
        earliestStart: addDays(start, -spread * i),
        latestStart: addDays(start, spread * i),
        ovulation: ovulation,
        fertileStart: addDays(ovulation, -5),
        fertileEnd: addDays(ovulation, 1),
        confidence: i == 1 ? confidence : Confidence.low,
      ),
    );
  }
  return predictions;
}

/// Personal luteal phase length from cycles with a confirmed ovulation date.
/// [ovulations] maps a cycle's start date to its confirmed ovulation day.
/// Falls back to [fallback] without data; clamped to a plausible 10–16 days.
int personalLutealLength(
  List<Cycle> cycles,
  Map<DateTime, DateTime> ovulations, {
  int fallback = 14,
}) {
  final lengths = [
    for (final c in cycles)
      if (c.isComplete && ovulations.containsKey(c.start))
        daysBetween(ovulations[c.start]!, c.nextStart!),
  ].where((l) => l >= 7 && l <= 20).toList();
  if (lengths.isEmpty) return fallback;
  final mean = lengths.reduce((a, b) => a + b) / lengths.length;
  return mean.round().clamp(10, 16);
}
