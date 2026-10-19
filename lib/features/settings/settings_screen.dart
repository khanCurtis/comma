import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
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
