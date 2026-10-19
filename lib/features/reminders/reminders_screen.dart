import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../medications/medications_screen.dart';

String formatMinute(BuildContext context, int minute) =>
    TimeOfDay(hour: minute ~/ 60, minute: minute % 60).format(context);

Future<int?> pickMinute(BuildContext context, int initial) async {
  final t = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: initial ~/ 60, minute: initial % 60),
  );
  return t == null ? null : t.hour * 60 + t.minute;
}

void openReminders(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RemindersScreen()));

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final settings = ref.watch(reminderSettingsProvider);
    final text = Theme.of(context).textTheme;

    Future<void> enable(String key, String value) async {
      await ref.read(notificationServiceProvider).requestPermission();
      await db.setSetting(key, value);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Period coming up'),
            subtitle: Text(
              settings.periodDaysBefore == null
                  ? 'Off'
                  : '${settings.periodDaysBefore == 0 ? 'On the day' : '${settings.periodDaysBefore} days before'}, '
                        'at ${formatMinute(context, settings.periodMinute)}',
            ),
            value: settings.periodDaysBefore != null,
            onChanged: (on) => on
                ? enable(SettingKeys.periodReminderDays, '2')
                : db.setSetting(SettingKeys.periodReminderDays, ''),
          ),
          if (settings.periodDaysBefore != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final days in [0, 1, 2, 3, 5])
                    ChoiceChip(
                      label: Text(days == 0 ? 'Same day' : '$days days'),
                      selected: settings.periodDaysBefore == days,
                      onSelected: (_) => db.setSetting(
                        SettingKeys.periodReminderDays,
                        '$days',
                      ),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.schedule, size: 18),
                    label: Text(formatMinute(context, settings.periodMinute)),
                    onPressed: () async {
                      final m = await pickMinute(
                        context,
                        settings.periodMinute,
                      );
                      if (m != null) {
                        await db.setSetting(
                          SettingKeys.periodReminderMinute,
                          '$m',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          const Divider(height: 32),
          SwitchListTile(
            title: const Text('Daily logging reminder'),
            subtitle: Text(
              settings.dailyLogMinute == null
                  ? 'Off'
                  : 'Every day at ${formatMinute(context, settings.dailyLogMinute!)}',
            ),
            value: settings.dailyLogMinute != null,
            onChanged: (on) => on
                ? enable(SettingKeys.dailyLogReminderMinute, '${20 * 60}')
                : db.setSetting(SettingKeys.dailyLogReminderMinute, ''),
          ),
          if (settings.dailyLogMinute != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ActionChip(
                  avatar: const Icon(Icons.schedule, size: 18),
                  label: Text(formatMinute(context, settings.dailyLogMinute!)),
                  onPressed: () async {
                    final m = await pickMinute(
                      context,
                      settings.dailyLogMinute!,
                    );
                    if (m != null) {
                      await db.setSetting(
                        SettingKeys.dailyLogReminderMinute,
                        '$m',
                      );
                    }
                  },
                ),
              ),
            ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.medication_outlined),
            title: const Text('Medication and pill reminders'),
            subtitle: const Text('Set a reminder time on each medication'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openMedications(context),
          ),
          const Divider(height: 32),
          SwitchListTile(
            title: const Text('Discreet notifications'),
            subtitle: const Text(
              'Notifications just say "You have a reminder", so nothing '
              'personal shows on your lock screen',
            ),
            value: settings.discreet,
            onChanged: (on) =>
                db.setSetting(SettingKeys.discreetNotifications, '$on'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Reminders are scheduled on this phone only. Open Comma at '
              'least every two weeks to keep them going. They may arrive a '
              'few minutes late while your phone is saving battery.',
              style: text.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
