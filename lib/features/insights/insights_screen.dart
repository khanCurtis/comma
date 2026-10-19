import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../domain/engine/irregularity.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final cycles = ref.watch(cyclesProvider).value ?? const [];
    final flags = ref.watch(irregularitiesProvider);
    final text = Theme.of(context).textTheme;
    final fmt = DateFormat.yMMMd();

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
              subtitle: Text('Period ${c.periodLength} days'),
              trailing: Text(c.length == null ? 'Current' : '${c.length} days'),
            ),
        ],
      ],
    );
  }

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
