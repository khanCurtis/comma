import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../data/backup/backup.dart';

const _codec = BackupCodec();

/// Asks for a password, then saves a backup file wherever the user chooses.
Future<void> exportBackupFlow(BuildContext context, WidgetRef ref) async {
  final choice = await showDialog<_PasswordChoice>(
    context: context,
    builder: (_) => const _NewPasswordDialog(),
  );
  if (choice == null || !context.mounted) return;

  final db = ref.read(databaseProvider);
  final bytes = await _withProgress(
    context,
    'Preparing backup…',
    () async =>
        _codec.encode(await exportBackup(db), password: choice.password),
  );
  if (bytes == null || !context.mounted) return;

  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final Uri? saved;
  try {
    saved = await FilePicker.saveFile(
      fileName: 'comma-backup-$today.comma',
      bytes: bytes,
      mimeType: 'application/json',
    );
  } catch (e) {
    if (context.mounted) _snack(context, 'Could not save the backup: $e');
    return;
  }
  if (saved == null) return;
  await db.setSetting(SettingKeys.lastBackup, DateTime.now().toIso8601String());
  if (context.mounted) _snack(context, 'Backup saved');
}

/// Lets the user pick a backup file and replaces all data with it.
/// Returns true if data was restored.
Future<bool> importBackupFlow(BuildContext context, WidgetRef ref) async {
  final List<PlatformFile> files;
  try {
    files = await FilePicker.pickFiles(dialogTitle: 'Choose a Comma backup');
  } catch (e) {
    if (context.mounted) _snack(context, 'Could not open the file: $e');
    return false;
  }
  if (files.isEmpty || !context.mounted) return false;
  final bytes = await files.single.xFile.readAsBytes();
  if (!context.mounted) return false;

  Map<String, Object?>? backup;
  String? password;
  try {
    if (BackupCodec.isEncrypted(bytes)) {
      while (backup == null) {
        if (!context.mounted) return false;
        password = await showDialog<String>(
          context: context,
          builder: (_) => _PasswordDialog(retry: password != null),
        );
        if (password == null || !context.mounted) return false;
        try {
          backup = await _withProgress(
            context,
            'Unlocking backup…',
            () => _codec.decode(bytes, password: password),
            rethrowErrors: true,
          );
          if (backup == null) return false;
        } on WrongPasswordException {
          // Ask again.
        }
      }
    } else {
      backup = await _codec.decode(bytes);
    }
  } on BackupException catch (e) {
    if (context.mounted) _snack(context, e.message);
    return false;
  }
  if (!context.mounted) return false;

  final days = (backup['dayLogs'] as List?)?.length ?? 0;
  final exportedAt = DateTime.tryParse(backup['exportedAt'] as String? ?? '');
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Restore this backup?'),
      content: Text(
        '${exportedAt == null ? 'This backup' : 'The backup from ${DateFormat.yMMMd().add_jm().format(exportedAt.toLocal())}'} '
        'has $days logged days. Restoring replaces everything currently '
        'on this device.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Restore'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return false;

  final db = ref.read(databaseProvider);
  try {
    await importBackup(db, backup);
    // Restoring always counts as finishing onboarding.
    await db.setSetting(SettingKeys.onboarded, 'true');
  } on BackupException catch (e) {
    if (context.mounted) _snack(context, e.message);
    return false;
  }
  if (context.mounted) _snack(context, 'Restored $days days');
  return true;
}

/// Runs [task] behind a modal spinner. Returns null if it failed, unless
/// [rethrowErrors] is set.
Future<T?> _withProgress<T>(
  BuildContext context,
  String message,
  Future<T> Function() task, {
  bool rethrowErrors = false,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 24),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    ),
  );
  try {
    return await task();
  } catch (e) {
    if (rethrowErrors) rethrow;
    if (context.mounted) _snack(context, 'Something went wrong: $e');
    return null;
  } finally {
    navigator.pop();
  }
}

void _snack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

class _PasswordChoice {
  const _PasswordChoice(this.password);
  final String? password;
}

class _NewPasswordDialog extends StatefulWidget {
  const _NewPasswordDialog();

  @override
  State<_NewPasswordDialog> createState() => _NewPasswordDialogState();
}

class _NewPasswordDialogState extends State<_NewPasswordDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _encrypt = true;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_encrypt) {
      Navigator.pop(context, const _PasswordChoice(null));
    } else if (_password.text.length < 6) {
      setState(() => _error = 'Use at least 6 characters');
    } else if (_password.text != _confirm.text) {
      setState(() => _error = "Passwords don't match");
    } else {
      Navigator.pop(context, _PasswordChoice(_password.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Back up your data'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Save the backup somewhere other than this phone, such as a '
              'computer or USB drive, so you can restore it if the app is '
              'reinstalled or you get a new phone.',
            ),
            const SizedBox(height: 16),
            if (_encrypt) ...[
              TextField(
                controller: _password,
                obscureText: true,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Backup password'),
              ),
              TextField(
                controller: _confirm,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  errorText: _error,
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 8),
              Text(
                "If you forget this password, the backup can't be opened by "
                'anyone, including you.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            CheckboxListTile(
              value: !_encrypt,
              onChanged: (v) => setState(() => _encrypt = !(v ?? false)),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Don't encrypt"),
              subtitle: const Text('Anyone with the file can read it'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save backup')),
      ],
    );
  }
}

class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({required this.retry});
  final bool retry;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Backup password'),
      content: TextField(
        controller: _password,
        obscureText: true,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: widget.retry ? 'Wrong password, try again' : null,
        ),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _password.text),
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}
