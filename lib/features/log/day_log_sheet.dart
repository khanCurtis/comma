import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../data/db/database.dart';
import '../../domain/dates.dart';
import '../../domain/models/day_log.dart';
import '../../domain/models/symptoms.dart';

final _dayProvider = StreamProvider.family<DayLog?, DateTime>(
  (ref, day) => ref.watch(databaseProvider).watchDay(day),
);

final _symptomsProvider = StreamProvider.family<Map<String, int>, DateTime>(
  (ref, day) => ref.watch(databaseProvider).watchSymptoms(day),
);

Future<void> showDayLogSheet(BuildContext context, DateTime day) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => DayLogSheet(day: dateOnly(day)),
    );

class DayLogSheet extends ConsumerWidget {
  const DayLogSheet({super.key, required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final log = ref.watch(_dayProvider(day)).value;
    final symptoms = ref.watch(_symptomsProvider(day)).value ?? const {};
    final text = Theme.of(context).textTheme;

    void save(DayLogsCompanion entry) =>
        db.saveDay(entry.copyWith(date: Value(day)));

    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleSmall),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );

    Widget symptomChips(List<SymptomDef> defs) => Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final s in defs)
          FilterChip(
            label: Text(s.label),
            selected: symptoms.containsKey(s.key),
            onSelected: (on) => db.setSymptom(day, s.key, on ? 1 : 0),
          ),
      ],
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        children: [
          Text(DateFormat.yMMMMEEEEd().format(day), style: text.titleLarge),
          section(
            'Flow',
            Wrap(
              spacing: 8,
              children: [
                for (final f in FlowLevel.values)
                  ChoiceChip(
                    label: Text(_flowLabel(f)),
                    selected: (log?.flow ?? FlowLevel.none) == f,
                    onSelected: (_) => db.setFlow(day, f),
                  ),
              ],
            ),
          ),
          section('Symptoms', symptomChips(physicalSymptoms)),
          section('Mood', symptomChips(moods)),
          section(
            'Cervical mucus',
            Wrap(
              spacing: 8,
              children: [
                for (final m in Mucus.values)
                  ChoiceChip(
                    label: Text(_mucusLabel(m)),
                    selected: log?.mucus == m,
                    onSelected: (on) =>
                        save(DayLogsCompanion(mucus: Value(on ? m : null))),
                  ),
              ],
            ),
          ),
          section(
            'Sex',
            Wrap(
              spacing: 8,
              children: [
                for (final s in SexActivity.values.skip(1))
                  ChoiceChip(
                    label: Text(
                      s == SexActivity.protected ? 'Protected' : 'Unprotected',
                    ),
                    selected: log?.sex == s,
                    onSelected: (on) =>
                        save(DayLogsCompanion(sex: Value(on ? s : null))),
                  ),
              ],
            ),
          ),
          section(
            'Notes',
            _NoteField(
              key: ValueKey(day),
              initial: log?.note ?? '',
              onSaved: (v) =>
                  save(DayLogsCompanion(note: Value(v.isEmpty ? null : v))),
            ),
          ),
        ],
      ),
    );
  }

  static String _flowLabel(FlowLevel f) => switch (f) {
    FlowLevel.none => 'None',
    FlowLevel.spotting => 'Spotting',
    FlowLevel.light => 'Light',
    FlowLevel.medium => 'Medium',
    FlowLevel.heavy => 'Heavy',
  };

  static String _mucusLabel(Mucus m) => switch (m) {
    Mucus.dry => 'Dry',
    Mucus.sticky => 'Sticky',
    Mucus.creamy => 'Creamy',
    Mucus.watery => 'Watery',
    Mucus.eggWhite => 'Egg white',
  };
}

class _NoteField extends StatefulWidget {
  const _NoteField({super.key, required this.initial, required this.onSaved});

  final String initial;
  final ValueChanged<String> onSaved;

  @override
  State<_NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends State<_NoteField> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    final note = _controller.text.trim();
    if (note != widget.initial) widget.onSaved(note);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    maxLines: 4,
    minLines: 2,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Anything else about today',
    ),
    onSubmitted: (v) => widget.onSaved(v.trim()),
  );
}
