import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../data/db/database.dart';
import '../../domain/dates.dart';
import '../../domain/medication_schedule.dart';
import '../reminders/reminders_screen.dart';

void openMedications(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const MedicationsScreen()));

MedSchedule scheduleOf(Medication m) => MedSchedule(
  start: m.startDate,
  end: m.endDate,
  activeDays: m.activeDays,
  breakDays: m.breakDays,
);

/// Common pill pack patterns: (label, active days, break days).
const packPatterns = [
  ('Every day', 0, 0),
  ('21 + 7 break', 21, 7),
  ('24 + 4 break', 24, 4),
  ('84 + 7 break', 84, 7),
];

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(medicationsProvider).value ?? const [];
    final today = ref.watch(todayProvider);
    final current = meds.where(
      (m) => m.endDate == null || !m.endDate!.isBefore(today),
    );
    final past = meds.where(
      (m) => m.endDate != null && m.endDate!.isBefore(today),
    );
    final fmt = DateFormat.yMMMd();

    Widget tile(Medication m) => ListTile(
      leading: Icon(
        m.isContraceptive ? Icons.event_repeat : Icons.medication_outlined,
      ),
      title: Text(m.name),
      subtitle: Text(
        [
          if (m.dose != null) m.dose!,
          if (m.reminderMinute != null)
            'reminder ${formatMinute(context, m.reminderMinute!)}',
          if (m.endDate != null)
            '${fmt.format(m.startDate)} – ${fmt.format(m.endDate!)}'
          else
            'since ${fmt.format(m.startDate)}',
        ].join(' · '),
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => _edit(context, m),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Medications & birth control')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        onPressed: () => _edit(context, null),
      ),
      body: meds.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Add birth control or any medication to get reminders and '
                  'tick it off each day.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                ...current.map(tile),
                if (past.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text('Stopped'),
                  ),
                  ...past.map(tile),
                ],
              ],
            ),
    );
  }

  static void _edit(BuildContext context, Medication? existing) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MedicationEditor(existing: existing),
        ),
      );
}

class MedicationEditor extends ConsumerStatefulWidget {
  const MedicationEditor({super.key, this.existing});
  final Medication? existing;

  @override
  ConsumerState<MedicationEditor> createState() => _MedicationEditorState();
}

class _MedicationEditorState extends ConsumerState<MedicationEditor> {
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _dose = TextEditingController(text: widget.existing?.dose);
  late var _contraceptive = widget.existing?.isContraceptive ?? false;
  late var _start = widget.existing?.startDate ?? dateOnly(DateTime.now());
  late DateTime? _end = widget.existing?.endDate;
  late var _pattern = (
    widget.existing?.activeDays ?? 0,
    widget.existing?.breakDays ?? 0,
  );
  late int? _reminder = widget.existing?.reminderMinute;

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    if (_reminder != null) {
      await ref.read(notificationServiceProvider).requestPermission();
    }
    await ref
        .read(databaseProvider)
        .saveMedication(
          MedicationsCompanion(
            id: widget.existing == null
                ? const Value.absent()
                : Value(widget.existing!.id),
            name: Value(name),
            dose: Value(_dose.text.trim().isEmpty ? null : _dose.text.trim()),
            isContraceptive: Value(_contraceptive),
            startDate: Value(_start),
            endDate: Value(_end),
            activeDays: Value(_pattern.$1),
            breakDays: Value(_pattern.$2),
            reminderMinute: Value(_reminder),
          ),
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete medication?'),
        content: const Text(
          'This also deletes every day it was marked as taken. To keep the '
          'history, set a stop date instead.',
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
    if (ok != true) return;
    await ref.read(databaseProvider).deleteMedication(widget.existing!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.yMMMd();
    final text = Theme.of(context).textTheme;

    Future<DateTime?> pickDate(DateTime initial) async {
      final d = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDate: initial,
      );
      return d == null ? null : dateOnly(d);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add medication' : 'Edit'),
        actions: [
          if (widget.existing != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
              hintText: 'e.g. Birth control pill, Iron',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dose,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Dose (optional)',
              hintText: 'e.g. 1 tablet, 200 mg',
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _contraceptive,
            onChanged: (v) => setState(() => _contraceptive = v ?? false),
            title: const Text('This is birth control'),
          ),
          const SizedBox(height: 8),
          Text('Schedule', style: text.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final (label, active, off) in packPatterns)
                ChoiceChip(
                  label: Text(label),
                  selected: _pattern == (active, off),
                  onSelected: (_) => setState(() => _pattern = (active, off)),
                ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_pattern.$2 > 0 ? 'Day 1 of a pack' : 'Started'),
            trailing: Text(fmt.format(_start)),
            onTap: () async {
              final d = await pickDate(_start);
              if (d != null) setState(() => _start = d);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Stopped'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_end == null ? 'Still taking' : fmt.format(_end!)),
                if (_end != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Still taking',
                    onPressed: () => setState(() => _end = null),
                  ),
              ],
            ),
            onTap: () async {
              final d = await pickDate(_end ?? dateOnly(DateTime.now()));
              if (d != null) setState(() => _end = d);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Daily reminder'),
            subtitle: Text(
              _reminder == null
                  ? 'Off'
                  : formatMinute(context, _reminder!) +
                        (_pattern.$2 > 0 ? ', skipped on break days' : ''),
            ),
            value: _reminder != null,
            onChanged: (on) async {
              if (!on) return setState(() => _reminder = null);
              final m = await pickMinute(context, 21 * 60);
              if (m != null) setState(() => _reminder = m);
            },
          ),
          if (_reminder != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  final m = await pickMinute(context, _reminder!);
                  if (m != null) setState(() => _reminder = m);
                },
                child: const Text('Change time'),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}

/// Medications due on [day], with a checkbox to mark each as taken.
class MedicationChecklist extends ConsumerWidget {
  const MedicationChecklist({super.key, required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final meds = ref.watch(medicationsProvider).value ?? const [];
    final taken = ref.watch(_takenProvider(day)).value ?? const {};
    final active = meds.where((m) {
      final s = scheduleOf(m);
      final inRange =
          !day.isBefore(s.start) && (s.end == null || !day.isAfter(s.end!));
      return inRange;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final m in active)
          () {
            final s = scheduleOf(m);
            final due = s.isDueOn(day);
            final packDay = s.packDay(day);
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: taken.contains(m.id),
              onChanged: (v) => db.setMedicationTaken(day, m.id, v ?? false),
              title: Text(m.name),
              subtitle: packDay == null
                  ? (m.dose == null ? null : Text(m.dose!))
                  : Text(
                      due
                          ? 'Pill $packDay of ${m.activeDays}'
                          : 'Break day ${packDay - m.activeDays} of ${m.breakDays}',
                    ),
            );
          }(),
        TextButton.icon(
          icon: const Icon(Icons.medication_outlined),
          label: Text(active.isEmpty ? 'Add medication' : 'Manage'),
          onPressed: () => openMedications(context),
        ),
      ],
    );
  }
}

final _takenProvider = StreamProvider.family<Set<int>, DateTime>(
  (ref, day) => ref.watch(databaseProvider).watchMedicationsTaken(day),
);
