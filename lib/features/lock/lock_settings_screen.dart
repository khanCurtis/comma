import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lock_controller.dart';
import 'lock_store.dart';

void openLockSettings(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const LockSettingsScreen()));

final _biometricsAvailableProvider = FutureProvider(
  (ref) => ref.watch(biometricsProvider).available,
);

final _hasEmergencyProvider = FutureProvider(
  (ref) => ref.watch(lockStoreProvider).hasEmergencyPin,
);

class LockSettingsScreen extends ConsumerWidget {
  const LockSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(lockControllerProvider);
    final store = ref.watch(lockStoreProvider);
    final controller = ref.read(lockControllerProvider.notifier);
    final biometricsAvailable =
        ref.watch(_biometricsAvailableProvider).value ?? false;
    final hasEmergency = ref.watch(_hasEmergencyProvider).value ?? false;
    final text = Theme.of(context).textTheme;

    Future<void> refresh() async {
      await controller.reload();
      ref.invalidate(_hasEmergencyProvider);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('App lock')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Lock with a PIN'),
            subtitle: const Text(
              'Asks for your PIN when you open Comma, and after 30 seconds '
              'away',
            ),
            value: lock.enabled,
            onChanged: (on) async {
              if (on) {
                final pin = await choosePin(context, title: 'Choose a PIN');
                if (pin == null) return;
                await store.setPin(pin);
              } else {
                await store.clear();
              }
              await refresh();
            },
          ),
          if (lock.enabled) ...[
            ListTile(
              title: const Text('Change PIN'),
              onTap: () async {
                final pin = await choosePin(context, title: 'New PIN');
                if (pin == null) return;
                // The two PINs must never match.
                if (await store.check(pin) == PinCheck.emergency) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "That's your emergency PIN. Choose a different one.",
                        ),
                      ),
                    );
                  }
                  return;
                }
                await store.setPin(pin);
                await refresh();
              },
            ),
            if (biometricsAvailable)
              SwitchListTile(
                title: const Text('Unlock with fingerprint or face'),
                value: lock.biometrics,
                onChanged: (on) async {
                  if (on &&
                      !await ref.read(biometricsProvider).authenticate()) {
                    return;
                  }
                  await store.setBiometrics(on);
                  await refresh();
                },
              ),
            const Divider(height: 32),
            SwitchListTile(
              title: const Text('Emergency PIN'),
              subtitle: const Text(
                'Entering this PIN on the lock screen instantly and '
                'permanently deletes all your data, then opens Comma as if '
                'it were new.',
              ),
              value: hasEmergency,
              onChanged: (on) async {
                if (!on) {
                  await store.clearEmergencyPin();
                  return refresh();
                }
                final pin = await choosePin(
                  context,
                  title: 'Choose an emergency PIN',
                );
                if (pin == null) return;
                try {
                  await store.setEmergencyPin(pin);
                } on ArgumentError catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('${e.message}')));
                  }
                }
                await refresh();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Back up regularly. If you forget your PIN, the only way back '
                'in is to reinstall Comma and restore a backup.',
                style: text.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Asks for a new 4–8 digit PIN twice. Returns null if cancelled.
Future<String?> choosePin(BuildContext context, {required String title}) =>
    showDialog<String>(
      context: context,
      builder: (_) => _ChoosePinDialog(title: title),
    );

class _ChoosePinDialog extends StatefulWidget {
  const _ChoosePinDialog({required this.title});
  final String title;

  @override
  State<_ChoosePinDialog> createState() => _ChoosePinDialogState();
}

class _ChoosePinDialogState extends State<_ChoosePinDialog> {
  final _pin = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!RegExp(r'^\d{4,8}$').hasMatch(_pin.text)) {
      setState(() => _error = 'Use 4 to 8 digits');
    } else if (_pin.text != _confirm.text) {
      setState(() => _error = "PINs don't match");
    } else {
      Navigator.pop(context, _pin.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label, {String? error}) =>
        InputDecoration(labelText: label, errorText: error, counterText: '');
    final digits = [FilteringTextInputFormatter.digitsOnly];
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pin,
            autofocus: true,
            obscureText: true,
            maxLength: 8,
            keyboardType: TextInputType.number,
            inputFormatters: digits,
            decoration: deco('PIN'),
          ),
          TextField(
            controller: _confirm,
            obscureText: true,
            maxLength: 8,
            keyboardType: TextInputType.number,
            inputFormatters: digits,
            decoration: deco('Confirm PIN', error: _error),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
