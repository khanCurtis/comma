import 'package:comma/domain/dates.dart';
import 'package:comma/domain/engine/bbt.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

List<TempReading> series(List<double> temps, {Set<int> disturbed = const {}}) {
  final start = d(2026, 1, 1);
  return [
    for (var i = 0; i < temps.length; i++)
      TempReading(addDays(start, i), temps[i], disturbed: disturbed.contains(i)),
  ];
}

void main() {
  test('detects a clear thermal shift', () {
    final r = series([
      36.4, 36.5, 36.4, 36.3, 36.5, 36.4, 36.4, // low phase, day 7 = last low
      36.7, 36.8, 36.8, 36.9,
    ]);
    expect(detectBbtOvulation(r), d(2026, 1, 7));
  });

  test('no shift without a rise', () {
    final r = series(List.filled(14, 36.5));
    expect(detectBbtOvulation(r), isNull);
  });

  test('third high reading must clear the threshold', () {
    final r = series([36.4, 36.4, 36.4, 36.4, 36.4, 36.5, 36.55, 36.6, 36.6]);
    expect(detectBbtOvulation(r), isNull);
  });

  test('disturbed readings are skipped', () {
    final r = series(
      [36.4, 36.4, 36.4, 37.2, 36.4, 36.4, 36.4, 36.4, 36.7, 36.7, 36.8],
      disturbed: {3},
    );
    expect(detectBbtOvulation(r), d(2026, 1, 8));
  });
}
