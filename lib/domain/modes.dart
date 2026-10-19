import 'dates.dart';

enum TrackingMode {
  standard('Track my cycle'),
  ttc('Trying to conceive'),
  pregnant('Pregnant'),
  postpartum('After giving birth'),
  perimenopause('Perimenopause');

  const TrackingMode(this.label);
  final String label;
}

class PregnancyInfo {
  const PregnancyInfo({
    required this.due,
    required this.weeks,
    required this.days,
  });

  final DateTime due;

  /// Completed weeks and extra days since the last period, the standard way
  /// pregnancy is counted ("12 weeks + 3 days").
  final int weeks;
  final int days;

  int get trimester => weeks < 14 ? 1 : (weeks < 28 ? 2 : 3);
}

/// Naegele's rule: due date is 280 days after the last period started,
/// shifted by how much longer or shorter than 28 days the cycle usually is.
PregnancyInfo pregnancyInfo(
  DateTime lastPeriod,
  DateTime today, {
  int cycleLength = 28,
}) {
  final adjust = (cycleLength - 28).clamp(-7, 14);
  final elapsed = daysBetween(lastPeriod, today) - adjust;
  return PregnancyInfo(
    due: addDays(lastPeriod, 280 + adjust),
    weeks: elapsed < 0 ? 0 : elapsed ~/ 7,
    days: elapsed < 0 ? 0 : elapsed % 7,
  );
}

/// Bleeding in the six weeks after birth (lochia) isn't a period.
Iterable<DateTime> withoutPostpartumBleeding(
  Iterable<DateTime> bleedingDays,
  DateTime birth,
) {
  final lochiaEnd = addDays(birth, 42);
  return bleedingDays.where((d) {
    final day = dateOnly(d);
    return day.isBefore(dateOnly(birth)) || !day.isBefore(lochiaEnd);
  });
}

/// Routine care to expect around each stage, based on NHS antenatal care
/// guidance. Shown as "coming up" information, not medical advice.
String? pregnancyMilestone(int weeks) => switch (weeks) {
  < 8 =>
    'Contact a midwife or doctor to start your pregnancy care, '
        'and take folic acid every day.',
  < 11 =>
    'Your first appointment (booking visit) usually happens '
        'around now.',
  < 15 => 'The dating scan usually happens between 11 and 14 weeks.',
  < 18 => 'A routine check-up usually happens around 16 weeks.',
  < 22 =>
    'The mid-pregnancy scan usually happens between 18 and 21 '
        'weeks. You may start to feel the baby move.',
  < 28 =>
    'Get to know your baby\'s pattern of movements. Contact your '
        'maternity unit straight away if movements slow down or stop.',
  < 36 =>
    'Your third trimester has started. Check-ups become more '
        'frequent from here.',
  < 40 =>
    'Your baby could come any time from 37 weeks. Have your '
        'maternity unit\'s number handy.',
  _ =>
    'You\'re at or past your due date. Your midwife or doctor will '
        'talk to you about what happens next.',
};
