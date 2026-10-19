import '../dates.dart';
import '../models/cycle.dart';
import 'predictor.dart';

enum Phase { period, follicular, fertile, ovulation, luteal }

class CycleStatus {
  const CycleStatus({
    required this.cycleDay,
    required this.phase,
    required this.daysUntilPeriod,
  });

  /// 1-based day of the current cycle.
  final int cycleDay;
  final Phase phase;

  /// Days until the predicted period; negative when it is late.
  final int? daysUntilPeriod;
}

/// Where [today] falls in the current cycle, or null if nothing is logged.
CycleStatus? cycleStatus(
  List<Cycle> cycles,
  List<CyclePrediction> predictions,
  DateTime today,
) {
  if (cycles.isEmpty) return null;
  final current = cycles.last;
  final day = dateOnly(today);
  final next = predictions.isEmpty ? null : predictions.first;

  bool within(DateTime from, DateTime to) =>
      !day.isBefore(from) && !day.isAfter(to);

  final Phase phase;
  if (within(current.start, current.periodEnd)) {
    phase = Phase.period;
  } else if (next == null) {
    phase = Phase.follicular;
  } else if (day == next.ovulation) {
    phase = Phase.ovulation;
  } else if (within(next.fertileStart, next.fertileEnd)) {
    phase = Phase.fertile;
  } else if (day.isAfter(next.ovulation)) {
    phase = Phase.luteal;
  } else {
    phase = Phase.follicular;
  }

  return CycleStatus(
    cycleDay: daysBetween(current.start, day) + 1,
    phase: phase,
    daysUntilPeriod: next == null ? null : daysBetween(day, next.periodStart),
  );
}
