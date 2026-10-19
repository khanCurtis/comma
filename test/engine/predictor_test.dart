import 'package:comma/domain/engine/cycle_builder.dart';
import 'package:comma/domain/engine/predictor.dart';
import 'package:comma/domain/models/cycle.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('computeStats', () {
    test('returns null without a complete cycle', () {
      expect(computeStats(buildCycles(periods([d(2026, 1, 1)]))), isNull);
    });

    test('regular cycles give their exact length and zero spread', () {
      final cycles =
          buildCycles(periods(startsFrom(d(2026, 1, 1), [28, 28, 28, 28])));
      final stats = computeStats(cycles)!;
      expect(stats.cycleLength, closeTo(28, 1e-9));
      expect(stats.cycleLengthSd, 0);
      expect(stats.periodLength, 5);
      expect(stats.sampleSize, 4);
    });

    test('recent cycles weigh more than older ones', () {
      final cycles =
          buildCycles(periods(startsFrom(d(2026, 1, 1), [26, 26, 26, 32])));
      final stats = computeStats(cycles)!;
      expect(stats.cycleLength, greaterThan(27.5)); // plain mean is 27.5
    });

    test('ignores implausible and excluded cycles', () {
      final starts = startsFrom(d(2025, 1, 1), [120, 28, 28, 30]);
      final cycles = buildCycles(periods(starts));
      final stats = computeStats(cycles, excludedStarts: {starts[3]})!;
      expect(stats.sampleSize, 2);
      expect(stats.cycleLength, closeTo(28, 1e-9));
    });
  });

  group('predictUpcoming', () {
    test('nothing to predict without any period', () {
      expect(predictUpcoming(const <Cycle>[]), isEmpty);
    });

    test('uses defaults with a single logged period', () {
      final cycles = buildCycles(periods([d(2026, 3, 1)]));
      final p = predictUpcoming(cycles, defaultCycleLength: 30).single;
      expect(p.periodStart, d(2026, 3, 31));
      expect(p.confidence, Confidence.low);
    });

    test('predicts period, ovulation and fertile window', () {
      final cycles =
          buildCycles(periods(startsFrom(d(2026, 1, 1), [28, 28, 28])));
      final p = predictUpcoming(cycles).single;
      expect(p.periodStart, d(2026, 4, 23)); // Mar 26 + 28
      expect(p.periodEnd, d(2026, 4, 27));
      expect(p.ovulation, d(2026, 4, 9));
      expect(p.fertileStart, d(2026, 4, 4));
      expect(p.fertileEnd, d(2026, 4, 10));
      expect(p.earliestStart, d(2026, 4, 21));
      expect(p.latestStart, d(2026, 4, 25));
      expect(p.confidence, Confidence.high);
    });

    test('irregular cycles lower confidence and widen the window', () {
      final cycles =
          buildCycles(periods(startsFrom(d(2026, 1, 1), [24, 34, 26, 33])));
      final p = predictUpcoming(cycles).single;
      expect(p.confidence, Confidence.medium);
      expect(p.latestStart.difference(p.earliestStart).inDays, greaterThan(4));
    });

    test('predicts several cycles ahead', () {
      final cycles =
          buildCycles(periods(startsFrom(d(2026, 1, 1), [28, 28, 28])));
      final ps = predictUpcoming(cycles, count: 3);
      expect(ps.map((p) => p.periodStart),
          [d(2026, 4, 23), d(2026, 5, 21), d(2026, 6, 18)]);
      expect(ps.last.confidence, Confidence.low);
    });
  });

  group('personalLutealLength', () {
    test('falls back without confirmed ovulations', () {
      expect(personalLutealLength([], {}), 14);
    });

    test('averages confirmed luteal phases', () {
      final starts = startsFrom(d(2026, 1, 1), [28, 28]);
      final cycles = buildCycles(periods(starts));
      final lengths = personalLutealLength(cycles, {
        starts[0]: d(2026, 1, 17), // 12 days before Jan 29
        starts[1]: d(2026, 2, 14), // 12 days before Feb 26
      });
      expect(lengths, 12);
    });
  });
}
