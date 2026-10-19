import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../domain/units.dart';
import 'backup_flow.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmWipe(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all data?'),
        content: const Text(
          'This permanently deletes every log and setting on this device. '
          'It cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed == true) await ref.read(databaseProvider).wipe();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleLength =
        ref.watch(settingProvider(SettingKeys.cycleLength)).value ?? '28';
    final periodLength =
        ref.watch(settingProvider(SettingKeys.periodLength)).value ?? '5';
    final lastBackup = DateTime.tryParse(
      ref.watch(settingProvider(SettingKeys.lastBackup)).value ?? '',
    );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListTile(
          title: const Text('Default cycle length'),
          subtitle: const Text('Used until you have logged a few cycles'),
          trailing: Text('$cycleLength days'),
        ),
        ListTile(
          title: const Text('Default period length'),
          trailing: Text('$periodLength days'),
        ),
        const Divider(),
        ListTile(
          title: const Text('Temperature'),
          trailing: SegmentedButton<TempUnit>(
            segments: const [
              ButtonSegment(value: TempUnit.celsius, label: Text('°C')),
              ButtonSegment(value: TempUnit.fahrenheit, label: Text('°F')),
            ],
            selected: {ref.watch(tempUnitProvider)},
            onSelectionChanged: (v) => ref
                .read(databaseProvider)
                .setSetting(SettingKeys.tempUnit, v.single.name),
          ),
        ),
        ListTile(
          title: const Text('Weight'),
          trailing: SegmentedButton<WeightUnit>(
            segments: const [
              ButtonSegment(value: WeightUnit.kg, label: Text('kg')),
              ButtonSegment(value: WeightUnit.lb, label: Text('lb')),
            ],
            selected: {ref.watch(weightUnitProvider)},
            onSelectionChanged: (v) => ref
                .read(databaseProvider)
                .setSetting(SettingKeys.weightUnit, v.single.name),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.label_outline),
          title: const Text('Your tags'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const _TagsScreen())),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.save_alt),
          title: const Text('Back up data'),
          subtitle: Text(
            lastBackup == null
                ? 'Never backed up'
                : 'Last backup ${DateFormat.yMMMd().format(lastBackup)}',
          ),
          onTap: () => exportBackupFlow(context, ref),
        ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: const Text('Restore from backup'),
          subtitle: const Text('Replaces all data on this device'),
          onTap: () => importBackupFlow(context, ref),
        ),
        const Divider(),
        ListTile(
          leading: Icon(
            Icons.delete_forever,
            color: Theme.of(context).colorScheme.error,
          ),
          title: const Text('Delete all data'),
          onTap: () => _confirmWipe(context, ref),
        ),
        const Divider(),
        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationName: 'Comma',
          applicationLegalese:
              'GPL-3.0. Comma is not a medical device and '
              'must not be used as contraception.',
        ),
      ],
    );
  }
}

class _TagsScreen extends ConsumerWidget {
  const _TagsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(customTagsProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: const Text('Your tags')),
      body: tags.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No tags yet. Add one from the "Your tags" section when '
                  'logging a day.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              children: [
                for (final t in tags)
                  ListTile(
                    title: Text(t.label),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete tag',
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete "${t.label}"?'),
                            content: const Text(
                              'This also removes it from every day it was '
                              'logged on.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await ref
                              .read(databaseProvider)
                              .deleteCustomTag(t.key);
                        }
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
