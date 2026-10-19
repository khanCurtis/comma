import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../data/db/database.dart';
import '../../domain/dates.dart';
import '../../domain/models/day_log.dart';
import '../learn/articles.dart';
import '../learn/learn_screen.dart';

final sexEntriesProvider =
    StreamProvider.family<List<SexEntry>, (DateTime, DateTime)>(
      (ref, range) =>
          ref.watch(databaseProvider).watchSexEntries(range.$1, range.$2),
    );

String protectionLabel(SexProtection p) => switch (p) {
  SexProtection.unprotected => 'Unprotected',
  SexProtection.condom => 'Condom',
  SexProtection.withdrawal => 'Withdrawal',
  SexProtection.otherProtection => 'Other protection',
};

String formatMinuteOfDay(BuildContext context, int minutes) =>
    TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60).format(context);

/// Opens the editor for a new entry on [day], or for [existing].
Future<void> showSexEntrySheet(
  BuildContext context, {
  DateTime? day,
  SexEntry? existing,
}) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (_) => SexEntrySheet(
    day: dateOnly(existing?.date ?? day ?? DateTime.now()),
    existing: existing,
  ),
);

class SexEntrySheet extends ConsumerStatefulWidget {
  const SexEntrySheet({super.key, required this.day, this.existing});

  final DateTime day;
  final SexEntry? existing;

  @override
  ConsumerState<SexEntrySheet> createState() => _SexEntrySheetState();
}

class _SexEntrySheetState extends ConsumerState<SexEntrySheet> {
  late var _day = widget.day;
  late int? _minute = widget.existing?.minuteOfDay;
  late SexProtection? _protection = widget.existing?.protection;
  late bool? _orgasm = widget.existing?.orgasm;
  late final _note = TextEditingController(text: widget.existing?.note);

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final note = _note.text.trim();
    await ref
        .read(databaseProvider)
        .saveSexEntry(
          SexEntriesCompanion(
            id: widget.existing == null
                ? const Value.absent()
                : Value(widget.existing!.id),
            date: Value(_day),
            minuteOfDay: Value(_minute),
            protection: Value(_protection),
            orgasm: Value(_orgasm),
            note: Value(note.isEmpty ? null : note),
          ),
        );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    navigator.pop();
    if (_protection == SexProtection.unprotected && widget.existing == null) {
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: const Text(
            'If you don\'t want to get pregnant, emergency contraception '
            'works best as soon as possible.',
          ),
          action: SnackBarAction(
            label: 'Learn more',
            onPressed: () => navigator.push(
              MaterialPageRoute<void>(
                builder: (_) => ArticleScreen(
                  article: articleById(ArticleIds.emergencyContraception)!,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _delete() async {
    await ref.read(databaseProvider).deleteSexEntry(widget.existing!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(s, style: text.titleSmall),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null ? 'Log sex' : 'Edit entry',
              style: text.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.event, size: 18),
                  label: Text(DateFormat.yMMMd().format(_day)),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      initialDate: _day,
                    );
                    if (picked != null) setState(() => _day = dateOnly(picked));
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.schedule, size: 18),
                  label: Text(
                    _minute == null
                        ? 'Add time'
                        : formatMinuteOfDay(context, _minute!),
                  ),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _minute == null
                          ? TimeOfDay.now()
                          : TimeOfDay(
                              hour: _minute! ~/ 60,
                              minute: _minute! % 60,
                            ),
                    );
                    if (picked != null) {
                      setState(
                        () => _minute = picked.hour * 60 + picked.minute,
                      );
                    }
                  },
                ),
                if (_minute != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: 'Remove time',
                    onPressed: () => setState(() => _minute = null),
                  ),
              ],
            ),
            label('Protection'),
            Wrap(
              spacing: 8,
              children: [
                for (final p in SexProtection.values)
                  ChoiceChip(
                    label: Text(protectionLabel(p)),
                    selected: _protection == p,
                    onSelected: (on) =>
                        setState(() => _protection = on ? p : null),
                  ),
              ],
            ),
            label('Orgasm'),
            Wrap(
              spacing: 8,
              children: [
                for (final (value, name) in [(true, 'Yes'), (false, 'No')])
                  ChoiceChip(
                    label: Text(name),
                    selected: _orgasm == value,
                    onSelected: (on) =>
                        setState(() => _orgasm = on ? value : null),
                  ),
              ],
            ),
            label('Notes'),
            TextField(
              controller: _note,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Optional',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (widget.existing != null)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    onPressed: _delete,
                  ),
                const Spacer(),
                FilledButton(onPressed: _save, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The entries logged on [day], with a button to add another.
class SexEntriesList extends ConsumerWidget {
  const SexEntriesList({super.key, required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(sexEntriesProvider((day, day))).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final e in entries)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.favorite_outline),
            title: Text(
              [
                if (e.minuteOfDay != null)
                  formatMinuteOfDay(context, e.minuteOfDay!),
                if (e.protection != null) protectionLabel(e.protection!),
                if (e.orgasm == true) 'Orgasm',
              ].join(' · ').ifEmpty('Logged'),
            ),
            subtitle: e.note == null ? null : Text(e.note!),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => showSexEntrySheet(context, existing: e),
          ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: Text(entries.isEmpty ? 'Log sex' : 'Add another'),
          onPressed: () => showSexEntrySheet(context, day: day),
        ),
      ],
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
