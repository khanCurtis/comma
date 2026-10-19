import '../dates.dart';
import '../models/cycle.dart';
import '../models/day_log.dart';
import 'bbt.dart';

/// The fertility-relevant part of a day log.
class FertilitySignal {
  const FertilitySignal(
    this.date, {
    this.bbt,
    this.bbtDisturbed = false,
    this.lh,
  });

  final DateTime date;
  final double? bbt;
  final bool bbtDisturbed;
  final TestResult? lh;
}

enum OvulationSource { bbt, lh }

class ConfirmedOvulation {
  const ConfirmedOvulation(this.date, this.source);
  final DateTime date;
  final OvulationSource source;

  @override
  bool operator ==(Object other) =>
      other is ConfirmedOvulation &&
      other.date == date &&
      other.source == source;

  @override
  int get hashCode => Object.hash(date, source);
}

/// Finds ovulation in each cycle from logged signals, keyed by cycle start.
///
/// A temperature shift (see [detectBbtOvulation]) is preferred, since it
/// confirms ovulation after the fact. Otherwise the day after the first
/// positive or peak LH test is used. Ovulation must fall after the period.
Map<DateTime, ConfirmedOvulation> confirmOvulations(
  List<Cycle> cycles,
  List<FertilitySignal> signals,
) {
  final result = <DateTime, ConfirmedOvulation>{};
  for (final c in cycles) {
    bool inCycle(DateTime d) =>
        d.isAfter(c.periodEnd) &&
        (c.nextStart == null || d.isBefore(c.nextStart!));
    final within = signals.where((s) => inCycle(dateOnly(s.date))).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final bbt = detectBbtOvulation([
      // Include the period's readings too: they form the low baseline.
      for (final s in signals)
        if (s.bbt != null &&
            !dateOnly(s.date).isBefore(c.start) &&
            (c.nextStart == null || dateOnly(s.date).isBefore(c.nextStart!)))
          TempReading(dateOnly(s.date), s.bbt!, disturbed: s.bbtDisturbed),
    ]);
    if (bbt != null && inCycle(bbt)) {
      result[c.start] = ConfirmedOvulation(bbt, OvulationSource.bbt);
      continue;
    }

    for (final s in within) {
      if (s.lh == TestResult.positive || s.lh == TestResult.peak) {
        final day = addDays(s.date, 1);
        if (c.nextStart == null || day.isBefore(c.nextStart!)) {
          result[c.start] = ConfirmedOvulation(day, OvulationSource.lh);
        }
        break;
      }
    }
  }
  return result;
}
