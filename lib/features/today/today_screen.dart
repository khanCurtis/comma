import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../domain/engine/predictor.dart';
import '../../domain/engine/status.dart';
import '../../domain/models/day_log.dart';
import '../log/day_log_sheet.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final cycles = ref.watch(cyclesProvider).value ?? const [];
    final predictions = ref.watch(predictionsProvider);
    final status = cycleStatus(cycles, predictions, today);
    final next = predictions.isEmpty ? null : predictions.first;
    final text = Theme.of(context).textTheme;
    final colors = CycleColors.of(context);
    final fmt = DateFormat.MMMd();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(DateFormat.yMMMMEEEEd().format(today), style: text.titleMedium),
        const SizedBox(height: 32),
        Center(
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status?.phase == Phase.period
                  ? colors.period
                  : Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: status?.phase == Phase.period ? colors.onPeriod : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: status == null
                    ? [const Text('Log your period to see predictions')]
                    : [
                        Text(
                          _phaseLabel(status.phase),
                          style: text.titleMedium?.copyWith(
                            color: status.phase == Phase.period
                                ? colors.onPeriod
                                : null,
                          ),
                        ),
                        Text(
                          'Day ${status.cycleDay}',
                          style: text.displaySmall?.copyWith(
                            color: status.phase == Phase.period
                                ? colors.onPeriod
                                : null,
                          ),
                        ),
                        if (status.daysUntilPeriod case final d?)
                          Text(_countdown(d)),
                      ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.water_drop),
                label: Text(
                  status?.phase == Phase.period ? 'Log flow' : 'Period started',
                ),
                onPressed: () async {
                  if (status?.phase != Phase.period) {
                    await ref
                        .read(databaseProvider)
                        .setFlow(today, FlowLevel.medium);
                  }
                  if (context.mounted) showDayLogSheet(context, today);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text('Log today'),
                onPressed: () => showDayLogSheet(context, today),
              ),
            ),
          ],
        ),
        if (next != null) ...[
          const SizedBox(height: 32),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.water_drop_outlined,
                    color: colors.period,
                  ),
                  title: const Text('Next period'),
                  subtitle: Text(
                    '${fmt.format(next.periodStart)}  '
                    '(${fmt.format(next.earliestStart)} – '
                    '${fmt.format(next.latestStart)})',
                  ),
                  trailing: _ConfidenceChip(next.confidence),
                ),
                ListTile(
                  leading: Icon(Icons.egg_outlined, color: colors.ovulation),
                  title: const Text('Fertile window'),
                  subtitle: Text(
                    '${fmt.format(next.fertileStart)} – '
                    '${fmt.format(next.fertileEnd)}, '
                    'ovulation around ${fmt.format(next.ovulation)}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Estimates only. Not for use as contraception.',
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  static String _phaseLabel(Phase phase) => switch (phase) {
    Phase.period => 'Period',
    Phase.follicular => 'Follicular phase',
    Phase.fertile => 'Fertile window',
    Phase.ovulation => 'Ovulation (estimated)',
    Phase.luteal => 'Luteal phase',
  };

  static String _countdown(int days) => switch (days) {
    0 => 'Period expected today',
    1 => 'Period in 1 day',
    > 1 => 'Period in $days days',
    -1 => 'Period 1 day late',
    _ => 'Period ${-days} days late',
  };
}

class _ConfidenceChip extends StatelessWidget {
  const _ConfidenceChip(this.confidence);
  final Confidence confidence;

  @override
  Widget build(BuildContext context) {
    final label = switch (confidence) {
      Confidence.low => 'Low confidence',
      Confidence.medium => 'Medium',
      Confidence.high => 'High',
    };
    return Text(label, style: Theme.of(context).textTheme.labelSmall);
  }
}
