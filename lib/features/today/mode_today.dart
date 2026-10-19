import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../domain/dates.dart';
import '../../domain/modes.dart';
import '../learn/articles.dart';
import '../learn/learn_screen.dart';
import '../log/day_log_sheet.dart';

Widget _circle(BuildContext context, List<Widget> children) {
  final scheme = Theme.of(context).colorScheme;
  return Center(
    child: Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.tertiaryContainer,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: DefaultTextStyle.merge(
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onTertiaryContainer),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    ),
  );
}

Widget _card(
  BuildContext context,
  IconData icon,
  String text, {
  String? articleId,
  bool urgent = false,
}) => Card(
  color: urgent ? Theme.of(context).colorScheme.errorContainer : null,
  child: ListTile(
    leading: Icon(icon),
    title: Text(text),
    trailing: articleId == null ? null : const Icon(Icons.chevron_right),
    onTap: articleId == null ? null : () => openArticle(context, articleId),
  ),
);

class PregnancyToday extends ConsumerWidget {
  const PregnancyToday({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final cycles = ref.watch(cyclesProvider).value ?? const [];
    final lmp =
        ref.watch(pregnancyLastPeriodProvider) ??
        (cycles.isEmpty ? null : cycles.last.start);
    final text = Theme.of(context).textTheme;

    if (lmp == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Set the first day of your last period in Settings → Mode to see '
            'how far along you are.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final cycleLength = ref.watch(statsProvider)?.cycleLength.round() ?? 28;
    final info = pregnancyInfo(lmp, today, cycleLength: cycleLength);
    final daysToGo = daysBetween(today, info.due);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(DateFormat.yMMMMEEEEd().format(today), style: text.titleMedium),
        const SizedBox(height: 32),
        _circle(context, [
          Text('Pregnant', style: text.titleMedium),
          Text('${info.weeks} weeks', style: text.displaySmall),
          if (info.days > 0) Text('+ ${info.days} days'),
          const SizedBox(height: 4),
          Text('Due ${DateFormat.MMMd().format(info.due)}'),
        ]),
        const SizedBox(height: 32),
        FilledButton.icon(
          icon: const Icon(Icons.edit_note),
          label: const Text('Log today'),
          onPressed: () => showDayLogSheet(context, today),
        ),
        const SizedBox(height: 16),
        _card(
          context,
          Icons.event_outlined,
          'Trimester ${info.trimester}. '
          '${daysToGo > 0 ? '$daysToGo days until your due date.' : 'Your due date has arrived.'}',
        ),
        if (pregnancyMilestone(info.weeks) case final milestone?)
          _card(context, Icons.flag_outlined, milestone),
        _card(
          context,
          Icons.warning_amber,
          'Know the warning signs that need a call to your midwife or '
          'doctor straight away.',
          articleId: ArticleIds.pregnancyWarningSigns,
          urgent: true,
        ),
        const SizedBox(height: 8),
        Text(
          'Dates are estimated from your last period. A dating scan gives '
          'a more accurate due date.',
          style: text.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PostpartumToday extends ConsumerWidget {
  const PostpartumToday({super.key, required this.birth});
  final DateTime birth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final breastfeeding =
        ref.watch(settingProvider(SettingKeys.breastfeeding)).value == 'true';
    final text = Theme.of(context).textTheme;
    final weeks = daysBetween(birth, today) ~/ 7;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(DateFormat.yMMMMEEEEd().format(today), style: text.titleMedium),
        const SizedBox(height: 32),
        _circle(context, [
          Text('Since birth', style: text.titleMedium),
          Text(
            weeks == 1 ? '1 week' : '$weeks weeks',
            style: text.displaySmall,
          ),
          const SizedBox(height: 4),
          const SizedBox(
            width: 160,
            child: Text('Log your first period when it comes back'),
          ),
        ]),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.water_drop),
                label: const Text('Log bleeding'),
                onPressed: () => showDayLogSheet(context, today),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (weeks < 6)
          _card(
            context,
            Icons.info_outline,
            'Bleeding in the first six weeks is normal and won\'t be counted '
            'as a period.',
          ),
        if (breastfeeding)
          _card(
            context,
            Icons.info_outline,
            'Breastfeeding can delay your period for months. That\'s normal.',
          ),
        _card(
          context,
          Icons.health_and_safety_outlined,
          'You can get pregnant before your first period returns. Here\'s '
          'what to know about your body after birth.',
          articleId: ArticleIds.afterBirth,
        ),
      ],
    );
  }
}
