import 'dart:io';

import 'package:comma/data/db/database.dart';
import 'package:comma/domain/dates.dart';
import 'package:comma/domain/engine/cycle_builder.dart';
import 'package:comma/domain/engine/irregularity.dart';
import 'package:comma/domain/engine/ovulation.dart';
import 'package:comma/domain/engine/predictor.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:comma/features/reports/csv_export.dart';
import 'package:comma/features/reports/pdf_report.dart';
import 'package:comma/features/reports/report_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

DateTime d(int y, int m, int day) => DateTime.utc(y, m, day);

DayLog log(
  DateTime date, {
  FlowLevel flow = FlowLevel.none,
  String? note,
  TestResult? pregnancy,
  double? bbt,
}) => DayLog(
  date: date,
  flow: flow,
  bbtDisturbed: false,
  note: note,
  pregnancyTest: pregnancy,
  bbt: bbt,
);

void main() {
  final starts = [d(2026, 1, 1), d(2026, 1, 29), d(2026, 3, 5)];
  final logs = [
    for (final s in starts)
      for (var i = 0; i < 4; i++)
        log(addDays(s, i), flow: i == 1 ? FlowLevel.heavy : FlowLevel.light),
    log(d(2026, 1, 10), note: 'Very tired, "bad" week'),
    log(d(2026, 2, 20), pregnancy: TestResult.negative),
  ];
  final cycles = buildCycles(
    logs.where((l) => l.flow.isBleeding).map((l) => l.date),
  );
  final symptoms = [
    SymptomEntry(date: d(2026, 1, 1), symptom: 'cramps', severity: 2),
    SymptomEntry(date: d(2026, 1, 30), symptom: 'cramps', severity: 1),
    SymptomEntry(date: d(2026, 1, 30), symptom: 'custom.ran', severity: 1),
  ];
  final sex = [
    SexEntry(
      id: 1,
      date: d(2026, 1, 14),
      kind: SexKind.partnered,
      protection: SexProtection.unprotected,
    ),
    SexEntry(id: 2, date: d(2026, 1, 15), kind: SexKind.solo),
  ];
  final ovulations = {
    d(2026, 1, 1): ConfirmedOvulation(d(2026, 1, 15), OvulationSource.bbt),
  };

  ReportData build(ReportOptions options) => buildReportData(
    options: options,
    today: d(2026, 3, 10),
    allCycles: cycles,
    dayLogs: logs,
    symptomEntries: symptoms,
    sexEntries: sex,
    tagLabels: {'custom.ran': 'Ran'},
    ovulations: ovulations,
    allFlags: findIrregularities(cycles, today: d(2026, 3, 10)),
    patterns: const [],
    predictions: predictUpcoming(cycles),
  );

  group('report data', () {
    test('summarises cycles, symptoms and tests in range', () {
      final data = build(
        ReportOptions(from: d(2026, 1, 1), to: d(2026, 3, 10)),
      );
      expect(data.cycles.map((r) => r.cycle.length), [28, 35, null]);
      expect(data.cycles.first.heaviestFlow, FlowLevel.heavy);
      expect(data.cycles.first.ovulation!.source, OvulationSource.bbt);
      expect(data.lengthRange, (shortest: 28, longest: 35));
      final cramps = data.symptoms.firstWhere((s) => s.label == 'Cramps');
      expect((cramps.days, cramps.cyclesWith), (2, 2));
      expect(data.symptoms.map((s) => s.label), contains('Ran'));
      expect(data.pregnancyTests.single.$2, TestResult.negative);
    });

    test('notes and sexual activity are opt-in', () {
      final off = build(ReportOptions(from: d(2026, 1, 1), to: d(2026, 3, 10)));
      expect(off.notes, isEmpty);
      expect(off.sex, isNull);

      final on = build(
        ReportOptions(
          from: d(2026, 1, 1),
          to: d(2026, 3, 10),
          includeNotes: true,
          includeSex: true,
        ),
      );
      expect(on.notes.single.$2, contains('Very tired'));
      expect((on.sex!.partnered, on.sex!.unprotected, on.sex!.solo), (1, 1, 1));
    });

    test('range excludes earlier cycles', () {
      final data = build(
        ReportOptions(from: d(2026, 2, 1), to: d(2026, 3, 10)),
      );
      expect(data.cycles.map((r) => r.cycle.start), [d(2026, 3, 5)]);
    });
  });

  group('csv', () {
    test('day log escapes quotes and joins symptoms', () {
      final csv = dayLogsCsv(logs, symptoms, {'custom.ran': 'Ran'});
      final lines = csv.split('\r\n');
      expect(lines.first, startsWith('date,flow,products,symptoms'));
      expect(csv, contains('"Very tired, ""bad"" week"'));
      final jan30 = lines.firstWhere((l) => l.startsWith('2026-01-30'));
      expect(jan30, contains('cramps:1'));
      expect(jan30, contains('Ran'));
    });

    test('cycles and sex entries', () {
      expect(
        cyclesCsv(cycles, ovulations).split('\r\n')[1],
        '2026-01-01,28,4,2026-01-15,bbt',
      );
      expect(
        sexEntriesCsv(sex).split('\r\n')[1],
        '2026-01-14,,partnered,unprotected,,',
      );
    });
  });

  test('pdf builds with every section', () async {
    final regular = pw.Font.ttf(
      File('assets/fonts/Roboto-Regular.ttf')
          .readAsBytesSync()
          .buffer
          .asByteData(),
    );
    final bold = pw.Font.ttf(
      File('assets/fonts/Roboto-Bold.ttf')
          .readAsBytesSync()
          .buffer
          .asByteData(),
    );
    final bytes = await buildPdfReport(
      build(
        ReportOptions(
          from: d(2026, 1, 1),
          to: d(2026, 3, 10),
          name: 'Test Person',
          includeNotes: true,
          includeSex: true,
        ),
      ),
      regular: regular,
      bold: bold,
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(5000));
    final out = Platform.environment['COMMA_PDF_OUT'];
    if (out != null) File(out).writeAsBytesSync(bytes);
  });
}
