import 'package:comma/domain/engine/cycle_builder.dart';
import 'package:comma/domain/engine/irregularity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Set<IrregularityKind> kinds(List<Irregularity> flags) =>
    flags.map((f) => f.kind).toSet();

void main() {
  test('regular cycles raise no flags', () {
    final cycles =
        buildCycles(periods(startsFrom(d(2026, 1, 1), [28, 29, 27, 28])));
    expect(findIrregularities(cycles, today: d(2026, 5, 1)), isEmpty);
  });

  test('flags short and long cycles', () {
    final cycles = buildCycles(periods(startsFrom(d(2026, 1, 1), [21, 45])));
    final flags = findIrregularities(cycles, today: d(2026, 3, 10));
    expect(kinds(flags), containsAll([
      IrregularityKind.shortCycle,
      IrregularityKind.longCycle,
    ]));
  });

  test('flags high variability', () {
    final cycles =
        buildCycles(periods(startsFrom(d(2026, 1, 1), [25, 36, 26])));
    final flags = findIrregularities(cycles, today: d(2026, 4, 1));
    expect(kinds(flags), contains(IrregularityKind.highVariability));
  });

  test('flags long periods', () {
    final cycles = buildCycles(periods([d(2026, 1, 1)], len: 10));
    expect(kinds(findIrregularities(cycles, today: d(2026, 1, 20))),
        {IrregularityKind.longPeriod});
  });

  test('flags 90 days without a period unless pregnant', () {
    final cycles = buildCycles(periods([d(2026, 1, 1)]));
    expect(kinds(findIrregularities(cycles, today: d(2026, 4, 2))),
        {IrregularityKind.missedPeriods});
    expect(findIrregularities(cycles, today: d(2026, 4, 2), pregnant: true),
        isEmpty);
  });
}
