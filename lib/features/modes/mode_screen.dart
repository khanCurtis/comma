import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../domain/dates.dart';
import '../../domain/modes.dart';
import '../learn/articles.dart';
import '../learn/learn_screen.dart';

void openModes(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ModeScreen()));

String _iso(DateTime d) => d.toIso8601String().substring(0, 10);

enum _PregnancyEnd { birth, loss, other }

class ModeScreen extends ConsumerWidget {
  const ModeScreen({super.key});

  Future<DateTime?> _pickDate(
    BuildContext context, {
    required String help,
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      helpText: help,
      firstDate: now.subtract(const Duration(days: 400)),
      lastDate: now,
      initialDate: initial ?? now,
    );
    return d == null ? null : dateOnly(d);
  }

  /// Leaves this pregnancy's cycle out of averages.
  Future<void> _excludePregnancyCycle(WidgetRef ref, DateTime? lmp) async {
    if (lmp == null) return;
    final excluded = {...ref.read(excludedCyclesProvider), lmp};
    await ref
        .read(databaseProvider)
        .setSetting(SettingKeys.excludedCycles, excluded.map(_iso).join(','));
  }

  Future<void> _change(
    BuildContext context,
    WidgetRef ref,
    TrackingMode from,
    TrackingMode to,
  ) async {
    if (from == to) return;
    final db = ref.read(databaseProvider);
    final cycles = ref.read(cyclesProvider).value ?? const [];
    final lastPeriod = cycles.isEmpty ? null : cycles.last.start;

    if (from == TrackingMode.pregnant) {
      final lmp = ref.read(pregnancyLastPeriodProvider) ?? lastPeriod;
      final end = await showDialog<_PregnancyEnd>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('How did your pregnancy end?'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, _PregnancyEnd.birth),
              child: const Text('I gave birth'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, _PregnancyEnd.loss),
              child: const Text('I had a miscarriage or pregnancy loss'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, _PregnancyEnd.other),
              child: const Text('I\'d rather not say'),
            ),
          ],
        ),
      );
      if (end == null || !context.mounted) return;
      await _excludePregnancyCycle(ref, lmp);
      if (end == _PregnancyEnd.birth) {
        if (!context.mounted) return;
        final birth = await _pickDate(
          context,
          help: 'When did you give birth?',
        );
        if (birth == null) return;
        await db.setSetting(SettingKeys.birthDate, _iso(birth));
        await db.setSetting(SettingKeys.mode, TrackingMode.postpartum.name);
        return;
      }
      await db.setSetting(SettingKeys.mode, to.name);
      if (end == _PregnancyEnd.loss && context.mounted) {
        openArticle(context, ArticleIds.pregnancyLoss);
      }
      return;
    }

    switch (to) {
      case TrackingMode.pregnant:
        final lmp = await _pickDate(
          context,
          help: 'First day of your last period',
          initial: lastPeriod,
        );
        if (lmp == null) return;
        await db.setSetting(SettingKeys.pregnancyLastPeriod, _iso(lmp));
      case TrackingMode.postpartum:
        final birth = await _pickDate(
          context,
          help: 'When did you give birth?',
        );
        if (birth == null) return;
        await db.setSetting(SettingKeys.birthDate, _iso(birth));
      default:
        break;
    }
    await db.setSetting(SettingKeys.mode, to.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider);
    final db = ref.watch(databaseProvider);
    final fmt = DateFormat.yMMMd();
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mode')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Comma adjusts what it shows to where you are in life.',
              style: text.bodyMedium,
            ),
          ),
          RadioGroup<TrackingMode>(
            groupValue: mode,
            onChanged: (to) {
              if (to != null) _change(context, ref, mode, to);
            },
            child: Column(
              children: [
                for (final m in TrackingMode.values)
                  RadioListTile<TrackingMode>(
                    value: m,
                    title: Text(m.label),
                    subtitle: Text(switch (m) {
                      TrackingMode.standard =>
                        'Periods, symptoms and predictions',
                      TrackingMode.ttc =>
                        'Focus on your fertile window and ovulation',
                      TrackingMode.pregnant =>
                        'Weeks, due date and what to expect. Period '
                            'predictions are paused.',
                      TrackingMode.postpartum =>
                        'Bleeding after birth isn\'t counted as a period',
                      TrackingMode.perimenopause =>
                        'For irregular cycles in the years before menopause',
                    }),
                  ),
              ],
            ),
          ),
          const Divider(height: 32),
          if (mode == TrackingMode.pregnant)
            ListTile(
              title: const Text('First day of last period'),
              subtitle: const Text('Used to work out your due date'),
              trailing: Text(switch (ref.watch(pregnancyLastPeriodProvider)) {
                final d? => fmt.format(d),
                null => 'Not set',
              }),
              onTap: () async {
                final d = await _pickDate(
                  context,
                  help: 'First day of your last period',
                  initial: ref.read(pregnancyLastPeriodProvider),
                );
                if (d != null) {
                  await db.setSetting(SettingKeys.pregnancyLastPeriod, _iso(d));
                }
              },
            ),
          if (mode == TrackingMode.postpartum) ...[
            ListTile(
              title: const Text('Date of birth'),
              trailing: Text(switch (ref.watch(birthDateProvider)) {
                final d? => fmt.format(d),
                null => 'Not set',
              }),
              onTap: () async {
                final d = await _pickDate(
                  context,
                  help: 'When did you give birth?',
                  initial: ref.read(birthDateProvider),
                );
                if (d != null) {
                  await db.setSetting(SettingKeys.birthDate, _iso(d));
                }
              },
            ),
            SwitchListTile(
              title: const Text('Breastfeeding'),
              value:
                  ref.watch(settingProvider(SettingKeys.breastfeeding)).value ==
                  'true',
              onChanged: (on) =>
                  db.setSetting(SettingKeys.breastfeeding, '$on'),
            ),
          ],
          if (mode == TrackingMode.ttc)
            SwitchListTile(
              title: const Text('Remind me when my fertile window starts'),
              value: ref.watch(reminderSettingsProvider).fertileWindow,
              onChanged: (on) async {
                if (on) {
                  await ref
                      .read(notificationServiceProvider)
                      .requestPermission();
                }
                await db.setSetting(SettingKeys.fertileReminder, '$on');
              },
            ),
        ],
      ),
    );
  }
}
