import '../../data/db/database.dart';
import '../../domain/dates.dart';
import '../../domain/engine/irregularity.dart';
import '../../domain/engine/ovulation.dart';
import '../../domain/engine/patterns.dart';
import '../../domain/engine/predictor.dart';
import '../../domain/engine/status.dart';
import '../../domain/models/cycle.dart';
import '../../domain/models/day_log.dart';
import '../../domain/models/symptoms.dart';

class ReportOptions {
  const ReportOptions({
    required this.from,
    required this.to,
    this.name,
    this.includeNotes = false,
    this.includeSex = false,
  });

  final DateTime from;
  final DateTime to;
  final String? name;
  final bool includeNotes;
  final bool includeSex;
}

class CycleRow {
  const CycleRow({
    required this.cycle,
    required this.heaviestFlow,
    this.ovulation,
  });

  final Cycle cycle;
  final FlowLevel heaviestFlow;
  final ConfirmedOvulation? ovulation;
}

class SymptomRow {
  const SymptomRow({
    required this.label,
    required this.days,
    required this.cyclesWith,
    this.usualPhase,
  });

  final String label;
  final int days;

  /// How many of the report's cycles had this symptom at least once.
  final int cyclesWith;
  final Phase? usualPhase;
}

class SexSummary {
  const SexSummary({
    required this.partnered,
    required this.unprotected,
    required this.solo,
  });

  final int partnered;
  final int unprotected;
  final int solo;
}

/// Everything the doctor report shows, already filtered to the date range.
class ReportData {
  const ReportData({
    required this.options,
    required this.generated,
    required this.cycles,
    required this.stats,
    required this.lengthRange,
    required this.nextPeriod,
    required this.symptoms,
    required this.flags,
    required this.pregnancyTests,
    required this.notes,
    required this.sex,
  });

  final ReportOptions options;
  final DateTime generated;
  final List<CycleRow> cycles;
  final CycleStats? stats;
  final ({int shortest, int longest})? lengthRange;
  final CyclePrediction? nextPeriod;
  final List<SymptomRow> symptoms;
  final List<Irregularity> flags;
  final List<(DateTime, TestResult)> pregnancyTests;
  final List<(DateTime, String)> notes;
  final SexSummary? sex;
}

ReportData buildReportData({
  required ReportOptions options,
  required DateTime today,
  required List<Cycle> allCycles,
  required List<DayLog> dayLogs,
  required List<SymptomEntry> symptomEntries,
  required List<SexEntry> sexEntries,
  required Map<String, String> tagLabels,
  required Map<DateTime, ConfirmedOvulation> ovulations,
  required List<Irregularity> allFlags,
  required List<SymptomPattern> patterns,
  required List<CyclePrediction> predictions,
}) {
  final from = dateOnly(options.from);
  final to = dateOnly(options.to);
  bool inRange(DateTime d) => !d.isBefore(from) && !d.isAfter(to);

  final cycles = allCycles.where((c) => inRange(c.start)).toList();
  final logsByDay = {for (final l in dayLogs) l.date: l};

  final rows = [
    for (final c in cycles)
      CycleRow(
        cycle: c,
        heaviestFlow: [
          for (var d = c.start; !d.isAfter(c.periodEnd); d = addDays(d, 1))
            logsByDay[d]?.flow ?? FlowLevel.none,
        ].reduce((a, b) => b.index > a.index ? b : a),
        ovulation: ovulations[c.start],
      ),
  ];

  // Symptom frequency, counting which cycle each logged day belongs to.
  Cycle? cycleOf(DateTime d) {
    for (final c in cycles.reversed) {
      if (!d.isBefore(c.start)) return c;
    }
    return null;
  }

  final days = <String, int>{};
  final cycleSets = <String, Set<DateTime>>{};
  for (final e in symptomEntries.where((e) => inRange(e.date))) {
    days[e.symptom] = (days[e.symptom] ?? 0) + 1;
    final c = cycleOf(e.date);
    if (c != null) cycleSets.putIfAbsent(e.symptom, () => {}).add(c.start);
  }
  final phaseOf = {for (final p in patterns) p.symptom: p.peakPhase};
  final symptomRows = [
    for (final e in days.entries)
      SymptomRow(
        label: tagLabels[e.key] ?? symptomLabel(e.key),
        days: e.value,
        cyclesWith: cycleSets[e.key]?.length ?? 0,
        usualPhase: phaseOf[e.key],
      ),
  ]..sort((a, b) => b.days.compareTo(a.days));

  final complete = cycles.where((c) => c.isComplete).toList();
  final sexInRange = sexEntries.where((e) => inRange(e.date)).toList();

  return ReportData(
    options: options,
    generated: today,
    cycles: rows,
    stats: computeStats(complete),
    lengthRange: cycleLengthRange(complete),
    nextPeriod: predictions.isEmpty ? null : predictions.first,
    symptoms: symptomRows,
    flags: allFlags
        .where((f) => f.cycleStart == null || inRange(f.cycleStart!))
        .toList(),
    pregnancyTests: [
      for (final l in dayLogs)
        if (l.pregnancyTest != null && inRange(l.date))
          (l.date, l.pregnancyTest!),
    ],
    notes: options.includeNotes
        ? [
            for (final l in dayLogs)
              if (l.note != null && inRange(l.date)) (l.date, l.note!),
          ]
        : const [],
    sex: options.includeSex
        ? SexSummary(
            partnered: sexInRange
                .where((e) => e.kind == SexKind.partnered)
                .length,
            unprotected: sexInRange
                .where(
                  (e) =>
                      e.kind == SexKind.partnered &&
                      e.protection == SexProtection.unprotected,
                )
                .length,
            solo: sexInRange.where((e) => e.kind == SexKind.solo).length,
          )
        : null,
  );
}
