import '../../data/db/database.dart';
import '../../domain/engine/ovulation.dart';
import '../../domain/models/cycle.dart';

/// Escapes one CSV field (RFC 4180).
String _field(Object? value) {
  final s = value?.toString() ?? '';
  return s.contains(RegExp('[",\r\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
}

String _csv(List<String> header, Iterable<List<Object?>> rows) => [
  header.map(_field).join(','),
  for (final r in rows) r.map(_field).join(','),
].join('\r\n');

String _day(DateTime d) => d.toIso8601String().substring(0, 10);

/// One row per logged day. Temperatures are °C and weights kg.
String dayLogsCsv(
  List<DayLog> logs,
  List<SymptomEntry> symptoms,
  Map<String, String> tagLabels,
) {
  final byDay = <DateTime, List<SymptomEntry>>{};
  for (final s in symptoms) {
    byDay.putIfAbsent(s.date, () => []).add(s);
  }
  final days = {...logs.map((l) => l.date), ...byDay.keys}.toList()..sort();
  final logByDay = {for (final l in logs) l.date: l};

  return _csv(
    [
      'date',
      'flow',
      'products',
      'symptoms',
      'moods',
      'tags',
      'energy',
      'cervical_mucus',
      'lh_test',
      'pregnancy_test',
      'bbt_c',
      'bbt_disturbed',
      'sleep_hours',
      'weight_kg',
      'note',
    ],
    [
      for (final d in days)
        () {
          final l = logByDay[d];
          final entries = byDay[d] ?? const [];
          String pick(
            bool Function(String) test,
            String Function(SymptomEntry) f,
          ) => entries.where((e) => test(e.symptom)).map(f).join('; ');
          return [
            _day(d),
            l?.flow.name,
            l?.products,
            pick(
              (k) => !k.startsWith('mood.') && !k.startsWith('custom.'),
              (e) => '${e.symptom}:${e.severity}',
            ),
            pick(
              (k) => k.startsWith('mood.'),
              (e) => e.symptom.substring('mood.'.length),
            ),
            pick(
              (k) => k.startsWith('custom.'),
              (e) => tagLabels[e.symptom] ?? e.symptom,
            ),
            l?.energy?.name,
            l?.mucus?.name,
            l?.lhTest?.name,
            l?.pregnancyTest?.name,
            l?.bbt,
            l == null ? null : (l.bbtDisturbed ? 'yes' : ''),
            l?.sleepHours,
            l?.weightKg,
            l?.note,
          ];
        }(),
    ],
  );
}

String cyclesCsv(
  List<Cycle> cycles,
  Map<DateTime, ConfirmedOvulation> ovulations,
) => _csv(
  [
    'start',
    'cycle_length_days',
    'period_days',
    'ovulation',
    'ovulation_source',
  ],
  [
    for (final c in cycles)
      [
        _day(c.start),
        c.length,
        c.periodLength,
        ovulations[c.start] == null ? null : _day(ovulations[c.start]!.date),
        ovulations[c.start]?.source.name,
      ],
  ],
);

String sexEntriesCsv(List<SexEntry> entries) => _csv(
  ['date', 'time', 'kind', 'protection', 'orgasm', 'note'],
  [
    for (final e in entries)
      [
        _day(e.date),
        e.minuteOfDay == null
            ? null
            : '${(e.minuteOfDay! ~/ 60).toString().padLeft(2, '0')}:'
                  '${(e.minuteOfDay! % 60).toString().padLeft(2, '0')}',
        e.kind.name,
        e.protection?.name,
        e.orgasm == null ? null : (e.orgasm! ? 'yes' : 'no'),
        e.note,
      ],
  ],
);
