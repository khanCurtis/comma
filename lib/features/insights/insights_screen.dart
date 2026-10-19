import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../domain/dates.dart';
import '../../domain/engine/irregularity.dart';
import '../../domain/engine/ovulation.dart';
import '../../domain/engine/patterns.dart';
import '../../domain/engine/status.dart';
import '../../domain/models/symptoms.dart';
import '../../domain/units.dart';
import 'charts.dart';
import '../../domain/models/day_log.dart';
import '../sex/sex_entry_sheet.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final cycles = ref.watch(cyclesProvider).value ?? const [];
    final flags = ref.watch(irregularitiesProvider);
    final text = Theme.of(context).textTheme;
    final fmt = DateFormat.yMMMd();
    final today = ref.watch(todayProvider);
    final sex =
        ref.watch(sexEntriesProvider((addDays(today, -89), today))).value ??
        const [];
    final cycleStart = cycles.isEmpty ? null : cycles.last.start;
    int countSince(DateTime from, SexKind kind) =>
        sex.where((e) => e.kind == kind && !e.date.isBefore(from)).length;
    final monthAgo = addDays(today, -29);
    final ovulations = ref.watch(ovulationsProvider);
    final patterns = ref.watch(symptomPatternsProvider);
    final tagLabels = {
      for (final t in ref.watch(customTagsProvider).value ?? const [])
        t.key: t.label,
    };
    final range = cycleLengthRange(cycles);
    final complete = cycles.where((c) => c.isComplete).toList();
    final tempUnit = ref.watch(tempUnitProvider);
    final temps = cycleStart == null
        ? const <(DateTime, double)>[]
        : <(DateTime, double)>[
            for (final FertilitySignal s
                in ref.watch(fertilitySignalsProvider).value ?? const [])
              if (s.bbt != null &&
                  !s.bbtDisturbed &&
                  !s.date.isBefore(cycleStart))
                (s.date, toDisplayTemp(s.bbt!, tempUnit)),
          ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Insights', style: text.headlineSmall),
        const SizedBox(height: 16),
        if (stats == null)
          const Text('Log at least two periods to see your cycle stats.')
        else
          Row(
            children: [
              _Stat('Avg. cycle', '${stats.cycleLength.toStringAsFixed(1)} d'),
              _Stat('Avg. period', '${stats.periodLength} d'),
              _Stat('Cycles', '${stats.sampleSize}'),
            ],
          ),
        if (range != null) ...[
          const SizedBox(height: 8),
          Text(
            range.shortest == range.longest
                ? 'Your cycles have all been ${range.shortest} days.'
                : 'Your cycles range from ${range.shortest} to '
                      '${range.longest} days (a spread of '
                      '${range.longest - range.shortest}).',
          ),
        ],
        if (complete.length >= 2) ...[
          const SizedBox(height: 24),
          Text('Cycle length', style: text.titleMedium),
          Text(
            'Dashed lines show the typical 24–38 day range',
            style: text.bodySmall,
          ),
          const SizedBox(height: 12),
          CycleLengthChart(
            cycles: complete.length > 12
                ? complete.sublist(complete.length - 12)
                : complete,
          ),
        ],
        if (temps.length >= 3) ...[
          const SizedBox(height: 24),
          Text('Temperature this cycle', style: text.titleMedium),
          if (ovulations[cycleStart] case final o?)
            Text(
              o.source == OvulationSource.bbt
                  ? 'Temperature shift suggests ovulation on '
                        '${DateFormat.MMMd().format(o.date)}'
                  : 'LH test suggests ovulation on '
                        '${DateFormat.MMMd().format(o.date)}',
              style: text.bodySmall,
            ),
          const SizedBox(height: 12),
          TemperatureChart(
            cycleStart: cycleStart!,
            readings: temps,
            unitSymbol: tempSymbol(tempUnit),
            ovulation: ovulations[cycleStart]?.date,
          ),
        ],
        if (patterns.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Symptom patterns', style: text.titleMedium),
          Text('From your complete cycles', style: text.bodySmall),
          for (final p in patterns.take(8))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(tagLabels[p.symptom] ?? symptomLabel(p.symptom)),
              subtitle: Text(
                'Mostly ${_phaseName(p.peakPhase)} '
                '(${p.byPhase[p.peakPhase]} of ${p.total} days)',
              ),
            ),
        ],
        if (sex.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Sexual activity', style: text.titleMedium),
          const SizedBox(height: 8),
          for (final (kind, label) in [
            (SexKind.partnered, 'Sex'),
            (SexKind.solo, 'Masturbation'),
          ])
            Row(
              children: [
                _Stat(
                  '$label, this cycle',
                  cycleStart == null ? '–' : '${countSince(cycleStart, kind)}',
                ),
                _Stat('$label, 30 days', '${countSince(monthAgo, kind)}'),
              ],
            ),
          Row(
            children: [
              _Stat(
                'Unprotected sex, 30 days',
                '${sex.where((e) => !e.date.isBefore(monthAgo) && e.protection == SexProtection.unprotected).length}',
              ),
            ],
          ),
        ],
        if (flags.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Worth mentioning to a doctor', style: text.titleMedium),
          for (final f in flags)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline),
              title: Text(_flagText(f)),
              subtitle: f.cycleStart == null
                  ? null
                  : Text('Cycle starting ${fmt.format(f.cycleStart!)}'),
            ),
        ],
        if (cycles.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Cycle history', style: text.titleMedium),
          for (final c in cycles.reversed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(fmt.format(c.start)),
              subtitle: Text(
                [
                  'Period ${c.periodLength} days',
                  if (ovulations[c.start] case final o?)
                    'ovulation ${DateFormat.MMMd().format(o.date)} '
                        '(${o.source == OvulationSource.bbt ? 'temperature' : 'LH test'})',
                ].join(', '),
              ),
              trailing: Text(c.length == null ? 'Current' : '${c.length} days'),
            ),
        ],
      ],
    );
  }

  static String _phaseName(Phase phase) => switch (phase) {
    Phase.period => 'during your period',
    Phase.follicular => 'after your period, before your fertile window',
    Phase.fertile => 'in your fertile window',
    Phase.ovulation => 'around ovulation',
    Phase.luteal => 'in the days before your period',
  };

  static String _flagText(Irregularity f) => switch (f.kind) {
    IrregularityKind.shortCycle => 'Short cycle (${f.days} days)',
    IrregularityKind.longCycle => 'Long cycle (${f.days} days)',
    IrregularityKind.highVariability => 'Cycle lengths vary by ${f.days} days',
    IrregularityKind.longPeriod => 'Long period (${f.days} days)',
    IrregularityKind.missedPeriods => 'No period for ${f.days} days',
  };
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ),
  );
}
