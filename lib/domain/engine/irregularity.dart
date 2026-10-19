import '../dates.dart';
import '../models/cycle.dart';

enum IrregularityKind {
  /// Cycle shorter than 24 days.
  shortCycle,

  /// Cycle longer than 38 days.
  longCycle,

  /// Shortest and longest recent cycles differ by more than 9 days.
  highVariability,

  /// Bleeding lasting more than 8 days.
  longPeriod,

  /// No period for 90 days or more.
  missedPeriods,
}

class Irregularity {
  const Irregularity(this.kind, {this.cycleStart, this.days});

  final IrregularityKind kind;

  /// The cycle the flag refers to, if it's about a single cycle.
  final DateTime? cycleStart;

  /// The measured value in days (cycle length, period length, spread, etc).
  final int? days;
}

/// Thresholds follow the FIGO System 1 definitions of normal menstruation.
/// These flags are prompts to talk to a doctor, not a diagnosis.
List<Irregularity> findIrregularities(
  List<Cycle> cycles, {
  required DateTime today,
  bool pregnant = false,
}) {
  final flags = <Irregularity>[];

  for (final c in cycles) {
    final length = c.length;
    if (length != null && length < 24) {
      flags.add(
        Irregularity(
          IrregularityKind.shortCycle,
          cycleStart: c.start,
          days: length,
        ),
      );
    } else if (length != null && length > 38) {
      flags.add(
        Irregularity(
          IrregularityKind.longCycle,
          cycleStart: c.start,
          days: length,
        ),
      );
    }
    if (c.periodLength > 8) {
      flags.add(
        Irregularity(
          IrregularityKind.longPeriod,
          cycleStart: c.start,
          days: c.periodLength,
        ),
      );
    }
  }

  final recent = cycles
      .where((c) => c.isComplete)
      .toList()
      .reversed
      .take(6)
      .toList();
  if (recent.length >= 3) {
    final lengths = recent.map((c) => c.length!).toList()..sort();
    final spread = lengths.last - lengths.first;
    if (spread > 9) {
      flags.add(Irregularity(IrregularityKind.highVariability, days: spread));
    }
  }

  if (cycles.isNotEmpty && !pregnant) {
    final since = daysBetween(cycles.last.start, today);
    if (since >= 90) {
      flags.add(
        Irregularity(
          IrregularityKind.missedPeriods,
          cycleStart: cycles.last.start,
          days: since,
        ),
      );
    }
  }

  return flags;
}
