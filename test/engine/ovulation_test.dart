import 'package:comma/domain/dates.dart';
import 'package:comma/domain/engine/cycle_builder.dart';
import 'package:comma/domain/engine/ovulation.dart';
import 'package:comma/domain/engine/patterns.dart';
import 'package:comma/domain/engine/predictor.dart';
import 'package:comma/domain/engine/status.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

/// Low temps from the cycle start, rising after [lastLow].
List<FertilitySignal> temps(DateTime start, DateTime lastLow, int days) => [
  for (var i = 0; i < days; i++)
    FertilitySignal(
      addDays(start, i),
      bbt: addDays(start, i).isAfter(lastLow) ? 36.8 : 36.4,
    ),
];

void main() {
  // Cycles start Jan 1 and Jan 29 (28 days), current cycle from Feb 26.
  final cycles = buildCycles(
    periods(startsFrom(d(2026, 1, 1), [28, 28]), len: 5),
  );

  group('confirmOvulations', () {
    test('temperature shift confirms ovulation', () {
      final result = confirmOvulations(
        cycles,
        temps(d(2026, 1, 1), d(2026, 1, 15), 25),
      );
      expect(
        result[d(2026, 1, 1)],
        ConfirmedOvulation(d(2026, 1, 15), OvulationSource.bbt),
      );
    });

    test('positive LH means ovulation the next day', () {
      final result = confirmOvulations(cycles, [
        FertilitySignal(d(2026, 2, 10), lh: TestResult.negative),
        FertilitySignal(d(2026, 2, 11), lh: TestResult.peak),
        FertilitySignal(d(2026, 2, 12), lh: TestResult.positive),
      ]);
      expect(
        result[d(2026, 1, 29)],
        ConfirmedOvulation(d(2026, 2, 12), OvulationSource.lh),
      );
    });

    test('temperature wins over LH', () {
      final result = confirmOvulations(cycles, [
        ...temps(d(2026, 1, 1), d(2026, 1, 15), 25),
        FertilitySignal(d(2026, 1, 12), lh: TestResult.positive),
      ]);
      expect(result[d(2026, 1, 1)]!.source, OvulationSource.bbt);
    });

    test('signals during the period are ignored', () {
      final result = confirmOvulations(cycles, [
        FertilitySignal(d(2026, 1, 2), lh: TestResult.positive),
      ]);
      expect(result, isEmpty);
    });
  });

  group('predictions with a known ovulation', () {
    test('next period follows the luteal phase after ovulation', () {
      final p = predictUpcoming(
        cycles,
        currentOvulation: d(2026, 3, 16),
        lutealLength: 12,
      ).first;
      expect(p.ovulation, d(2026, 3, 16));
      expect(p.periodStart, d(2026, 3, 28));
    });

    test('later cycles keep the usual spacing', () {
      final ps = predictUpcoming(
        cycles,
        count: 2,
        currentOvulation: d(2026, 3, 16),
        lutealLength: 12,
      );
      expect(ps[1].periodStart, d(2026, 4, 25));
    });
  });

  group('symptomPatterns', () {
    test('groups symptoms by phase in complete cycles', () {
      final patterns = symptomPatterns(cycles, [
        (d(2026, 1, 1), 'cramps'),
        (d(2026, 1, 2), 'cramps'),
        (d(2026, 1, 29), 'cramps'),
        (d(2026, 1, 25), 'cramps'), // luteal (ovulation assumed Jan 15)
        (d(2026, 1, 15), 'bloating'),
        (d(2026, 3, 1), 'cramps'), // current cycle: ignored
      ]);
      expect(patterns, hasLength(1));
      final cramps = patterns.single;
      expect(cramps.byPhase, {Phase.period: 3, Phase.luteal: 1});
      expect(cramps.peakPhase, Phase.period);
    });
  });

  test('cycleLengthRange', () {
    expect(cycleLengthRange(cycles), (shortest: 28, longest: 28));
    expect(cycleLengthRange(buildCycles(periods([d(2026, 1, 1)]))), isNull);
  });
}
