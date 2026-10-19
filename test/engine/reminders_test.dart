import 'package:comma/domain/medication_schedule.dart';
import 'package:comma/domain/reminders.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('MedSchedule', () {
    test('daily between start and end', () {
      final s = MedSchedule(start: d(2026, 1, 10), end: d(2026, 1, 12));
      expect(s.isDueOn(d(2026, 1, 9)), isFalse);
      expect(s.isDueOn(d(2026, 1, 10)), isTrue);
      expect(s.isDueOn(d(2026, 1, 12)), isTrue);
      expect(s.isDueOn(d(2026, 1, 13)), isFalse);
      expect(s.packDay(d(2026, 1, 10)), isNull);
    });

    test('21 on, 7 off pill pack', () {
      final s = MedSchedule(start: d(2026, 1, 1), activeDays: 21, breakDays: 7);
      expect(s.isDueOn(d(2026, 1, 21)), isTrue); // day 21
      expect(s.isDueOn(d(2026, 1, 22)), isFalse); // break
      expect(s.isDueOn(d(2026, 1, 28)), isFalse);
      expect(s.isDueOn(d(2026, 1, 29)), isTrue); // new pack
      expect(s.packDay(d(2026, 1, 29)), 1);
      expect(s.packDay(d(2026, 1, 25)), 25);
    });
  });

  group('planReminders', () {
    final now = DateTime(2026, 3, 1, 12); // local noon

    test('nothing enabled, nothing planned', () {
      expect(
        planReminders(now: now, settings: const ReminderSettings()),
        isEmpty,
      );
    });

    test('period reminder days before, skipped if already past', () {
      final plan = planReminders(
        now: now,
        settings: const ReminderSettings(periodDaysBefore: 2),
        nextPeriod: d(2026, 3, 10),
      );
      expect(plan.single.when, DateTime(2026, 3, 8, 9));
      expect(plan.single.id, 1);

      expect(
        planReminders(
          now: now,
          settings: const ReminderSettings(periodDaysBefore: 2),
          nextPeriod: d(2026, 3, 2),
        ),
        isEmpty,
      );
    });

    test('discreet wording hides details', () {
      final meds = [
        MedReminder(
          id: 3,
          name: 'Birth control',
          minute: 21 * 60,
          schedule: MedSchedule(start: d(2026, 1, 1)),
        ),
      ];
      final discreet = planReminders(
        now: now,
        settings: const ReminderSettings(),
        meds: meds,
      );
      expect(discreet.first.title, 'Comma');
      expect(discreet.first.body, 'You have a reminder');

      final open = planReminders(
        now: now,
        settings: const ReminderSettings(discreet: false),
        meds: meds,
      );
      expect(open.first.title, 'Time for Birth control');
    });

    test('pill reminders skip break days and past times', () {
      final plan = planReminders(
        now: now,
        settings: const ReminderSettings(),
        days: 10,
        meds: [
          MedReminder(
            id: 7,
            name: 'Pill',
            minute: 8 * 60, // already past today
            // Day 1 = Feb 9, so Mar 1 is day 21 and Mar 2–8 are the break.
            schedule: MedSchedule(
              start: d(2026, 2, 9),
              activeDays: 21,
              breakDays: 7,
            ),
          ),
        ],
      );
      expect(plan.map((p) => p.when.day), [9, 10]);
      expect(plan.first.id, 100000 + 700 + 8);
    });

    test('daily log reminders and the limit', () {
      final plan = planReminders(
        now: now,
        settings: const ReminderSettings(dailyLogMinute: 20 * 60),
        days: 14,
        limit: 5,
      );
      expect(plan, hasLength(5));
      expect(plan.first.when, DateTime(2026, 3, 1, 20));
      expect(plan.map((p) => p.id), [1000, 1001, 1002, 1003, 1004]);
    });
  });
}
