import 'package:comma/domain/engine/cycle_builder.dart';
import 'package:comma/domain/engine/predictor.dart';
import 'package:comma/domain/engine/status.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  // Periods on Jan 1 and Jan 29 (28-day cycle); next predicted Feb 26,
  // ovulation Feb 12, fertile Feb 7–13.
  final cycles = buildCycles(periods([d(2026, 1, 1), d(2026, 1, 29)]));
  final predictions = predictUpcoming(cycles);

  CycleStatus at(DateTime day) => cycleStatus(cycles, predictions, day)!;

  test('nothing logged gives no status', () {
    expect(cycleStatus([], [], d(2026, 1, 1)), isNull);
  });

  test('phases across the cycle', () {
    expect(at(d(2026, 1, 30)).phase, Phase.period);
    expect(at(d(2026, 2, 4)).phase, Phase.follicular);
    expect(at(d(2026, 2, 8)).phase, Phase.fertile);
    expect(at(d(2026, 2, 12)).phase, Phase.ovulation);
    expect(at(d(2026, 2, 20)).phase, Phase.luteal);
  });

  test('cycle day and countdown', () {
    final s = at(d(2026, 2, 20));
    expect(s.cycleDay, 23);
    expect(s.daysUntilPeriod, 6);
  });

  test('late period gives a negative countdown', () {
    expect(at(d(2026, 3, 1)).daysUntilPeriod, -3);
  });
}
