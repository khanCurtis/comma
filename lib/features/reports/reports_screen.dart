import 'dart:convert';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../domain/dates.dart';
import 'csv_export.dart';
import 'pdf_report.dart';
import 'report_data.dart';

enum _Range {
  threeMonths('3 months', 3),
  sixMonths('6 months', 6),
  year('1 year', 12),
  all('All time', null);

  const _Range(this.label, this.months);
  final String label;
  final int? months;
}

void openReports(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ReportsScreen()));

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  var _range = _Range.sixMonths;
  final _name = TextEditingController();
  var _includeNotes = false;
  var _includeSex = false;
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  DateTime get _from {
    final today = ref.read(todayProvider);
    final months = _range.months;
    if (months == null) return DateTime.utc(1970);
    return dateOnly(DateTime.utc(today.year, today.month - months, today.day));
  }

  Future<Uint8List> _buildPdf() async {
    final db = ref.read(databaseProvider);
    final today = ref.read(todayProvider);
    final data = buildReportData(
      options: ReportOptions(
        from: _from,
        to: today,
        name: _name.text,
        includeNotes: _includeNotes,
        includeSex: _includeSex,
      ),
      today: today,
      allCycles: ref.read(cyclesProvider).value ?? const [],
      dayLogs: await db.allDayLogs(),
      symptomEntries: await db.allSymptomEntries(),
      sexEntries: _includeSex ? await db.allSexEntries() : const [],
      tagLabels: {
        for (final t in await db.select(db.customTags).get()) t.key: t.label,
      },
      ovulations: ref.read(ovulationsProvider),
      allFlags: ref.read(irregularitiesProvider),
      patterns: ref.read(symptomPatternsProvider),
      predictions: ref.read(predictionsProvider),
    );
    final country = PlatformDispatcher.instance.locale.countryCode;
    return buildPdfReport(
      data,
      regular: pw.Font.ttf(
        await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
      ),
      bold: pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf')),
      pageFormat: const {'US', 'CA'}.contains(country)
          ? PdfPageFormat.letter
          : PdfPageFormat.a4,
    );
  }

  String get _pdfName =>
      'cycle-report-${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf';

  /// Writes files to a private temporary folder, clearing earlier exports.
  Future<List<XFile>> _writeTemp(Map<String, (List<int>, String)> files) async {
    final dir = Directory(
      p.join((await getTemporaryDirectory()).path, 'exports'),
    );
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    dir.createSync(recursive: true);
    return [
      for (final MapEntry(key: name, value: (bytes, mime)) in files.entries)
        () {
          final path = p.join(dir.path, name);
          File(path).writeAsBytesSync(bytes);
          return XFile(path, mimeType: mime);
        }(),
    ];
  }

  Future<void> _run(Future<void> Function() task) async {
    setState(() => _busy = true);
    try {
      await task();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sharePdf() => _run(() async {
    final files = await _writeTemp({
      _pdfName: (await _buildPdf(), 'application/pdf'),
    });
    await SharePlus.instance.share(
      ShareParams(files: files, subject: 'Cycle report'),
    );
  });

  Future<void> _savePdf() => _run(() async {
    final saved = await FilePicker.saveFile(
      fileName: _pdfName,
      bytes: await _buildPdf(),
      mimeType: 'application/pdf',
    );
    if (saved != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Report saved')));
    }
  });

  Future<void> _shareCsv() => _run(() async {
    final db = ref.read(databaseProvider);
    final tags = {
      for (final t in await db.select(db.customTags).get()) t.key: t.label,
    };
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final files = await _writeTemp({
      'comma-days-$date.csv': (
        _utf8(
          dayLogsCsv(await db.allDayLogs(), await db.allSymptomEntries(), tags),
        ),
        'text/csv',
      ),
      'comma-cycles-$date.csv': (
        _utf8(
          cyclesCsv(
            ref.read(cyclesProvider).value ?? const [],
            ref.read(ovulationsProvider),
          ),
        ),
        'text/csv',
      ),
      'comma-sexual-activity-$date.csv': (
        _utf8(sexEntriesCsv(await db.allSexEntries())),
        'text/csv',
      ),
    });
    await SharePlus.instance.share(
      ShareParams(files: files, subject: 'Comma data export'),
    );
  });

  /// UTF-8 with a byte order mark, so spreadsheet apps read accents correctly.
  static List<int> _utf8(String s) => [
    0xEF,
    0xBB,
    0xBF,
    ...const Utf8Codec().encode(s),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & export')),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text('Report for your doctor', style: text.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'A PDF summary of your cycles, symptoms and anything worth '
              'discussing. Nothing is sent anywhere until you choose where '
              'to share or save it.',
            ),
            const SizedBox(height: 20),
            Text('Time period', style: text.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final r in _Range.values)
                  ChoiceChip(
                    label: Text(r.label),
                    selected: _range == r,
                    onSelected: (_) => setState(() => _range = r),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name on report (optional)',
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _includeNotes,
              onChanged: (v) => setState(() => _includeNotes = v),
              title: const Text('Include notes'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _includeSex,
              onChanged: (v) => setState(() => _includeSex = v),
              title: const Text('Include sexual activity'),
              subtitle: const Text('Counts only, no details'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share PDF'),
                    onPressed: _sharePdf,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save PDF'),
                    onPressed: _savePdf,
                  ),
                ),
              ],
            ),
            if (_busy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            const Divider(height: 48),
            Text('Export your data', style: text.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Spreadsheet (CSV) files with every day, cycle and sexual '
              'activity entry. These files are not encrypted. To move to a '
              'new phone, use Settings → Back up data instead.',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.table_view),
              label: const Text('Share CSV files'),
              onPressed: _shareCsv,
            ),
          ],
        ),
      ),
    );
  }
}
