import 'package:comma/domain/engine/cycle_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  test('no bleeding days gives no cycles', () {
    expect(buildCycles([]), isEmpty);
  });

  test('groups consecutive days into periods and links cycles', () {
    final cycles = buildCycles(periods([d(2026, 1, 1), d(2026, 1, 29)]));
    expect(cycles, hasLength(2));
    expect(cycles[0].start, d(2026, 1, 1));
    expect(cycles[0].periodEnd, d(2026, 1, 5));
    expect(cycles[0].length, 28);
    expect(cycles[0].periodLength, 5);
    expect(cycles[1].isComplete, isFalse);
  });

  test('a short gap in logging does not split a period', () {
    final cycles = buildCycles([d(2026, 1, 1), d(2026, 1, 2), d(2026, 1, 5)]);
    expect(cycles, hasLength(1));
    expect(cycles.single.periodEnd, d(2026, 1, 5));
  });

  test('a longer gap starts a new period', () {
    final cycles = buildCycles([d(2026, 1, 1), d(2026, 1, 5)], maxGap: 2);
    expect(cycles, hasLength(2));
  });

  test('input order and duplicates do not matter', () {
    final days = periods([d(2026, 1, 29), d(2026, 1, 1)]);
    final cycles = buildCycles([...days.reversed, ...days]);
    expect(cycles.map((c) => c.start), [d(2026, 1, 1), d(2026, 1, 29)]);
  });
}
