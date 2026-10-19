import 'package:comma/domain/modes.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('pregnancyInfo', () {
    test('Naegele due date and weeks for a 28-day cycle', () {
      final info = pregnancyInfo(d(2026, 1, 1), d(2026, 3, 29));
      expect(info.due, d(2026, 10, 8));
      expect((info.weeks, info.days), (12, 3));
      expect(info.trimester, 1);
    });

    test('longer cycles push the due date later', () {
      final info = pregnancyInfo(
        d(2026, 1, 1),
        d(2026, 3, 29),
        cycleLength: 32,
      );
      expect(info.due, d(2026, 10, 12));
      expect((info.weeks, info.days), (11, 6));
    });

    test('trimesters', () {
      expect(pregnancyInfo(d(2026, 1, 1), d(2026, 4, 9)).trimester, 2);
      expect(pregnancyInfo(d(2026, 1, 1), d(2026, 7, 16)).trimester, 3);
    });

    test('never negative', () {
      final info = pregnancyInfo(d(2026, 1, 10), d(2026, 1, 1));
      expect((info.weeks, info.days), (0, 0));
    });
  });

  test('postpartum bleeding in the first six weeks is ignored', () {
    final birth = d(2026, 5, 1);
    final days = [d(2026, 4, 1), d(2026, 5, 3), d(2026, 6, 11), d(2026, 6, 12)];
    expect(withoutPostpartumBleeding(days, birth), [
      d(2026, 4, 1),
      d(2026, 6, 12),
    ]);
  });

  test('every pregnancy week has a milestone', () {
    for (var w = 0; w <= 42; w++) {
      expect(pregnancyMilestone(w), isNotNull, reason: 'week $w');
    }
  });
}
