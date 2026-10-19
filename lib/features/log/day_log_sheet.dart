import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../data/db/database.dart';
import '../../domain/dates.dart';
import '../../domain/models/day_log.dart';
import '../../domain/models/symptoms.dart';
import '../../domain/units.dart';
import '../sex/sex_entry_sheet.dart';

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
    final tags = ref.watch(customTagsProvider).value ?? const [];
    final tempUnit = ref.watch(tempUnitProvider);
    final weightUnit = ref.watch(weightUnitProvider);
    final text = Theme.of(context).textTheme;

    void save(DayLogsCompanion entry) =>
        db.saveDay(entry.copyWith(date: Value(day)));

    Widget section(String title, Widget child, {String? hint}) => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleSmall),
          if (hint != null) Text(hint, style: text.bodySmall),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );

    // Tapping a selected symptom steps through mild → moderate → severe → off.
    Widget severityChips(List<SymptomDef> defs) => Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final s in defs)
          FilterChip(
            label: Text(
              symptoms[s.key] == null
                  ? s.label
                  : '${s.label} · ${severityLabels[symptoms[s.key]!.clamp(1, 3)]}',
            ),
            selected: symptoms.containsKey(s.key),
            onSelected: (_) =>
                db.setSymptom(day, s.key, ((symptoms[s.key] ?? 0) + 1) % 4),
          ),
      ],
    );

    Widget toggleChips(List<SymptomDef> defs) => Wrap(
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

    Widget choice<T>(
      List<T> values,
      T? selected,
      String Function(T) label,
      void Function(T?) onChanged,
    ) => Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final v in values)
          ChoiceChip(
            label: Text(label(v)),
            selected: selected == v,
            onSelected: (on) => onChanged(on ? v : null),
          ),
      ],
    );

    final bleeding = log?.flow.isBleeding ?? false;

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                choice(
                  FlowLevel.values,
                  log?.flow ?? FlowLevel.none,
                  _flowLabel,
                  (f) => db.setFlow(day, f ?? FlowLevel.none),
                ),
                if (bleeding || log?.products != null)
                  _Counter(
                    label: 'Pads, tampons or cups used',
                    value: log?.products ?? 0,
                    onChanged: (v) => save(
                      DayLogsCompanion(products: Value(v == 0 ? null : v)),
                    ),
                  ),
              ],
            ),
          ),
          section(
            'Symptoms',
            severityChips(physicalSymptoms),
            hint: 'Tap again to set how bad it is',
          ),
          section('Mood', toggleChips(moods)),
          section(
            'Energy',
            choice(
              EnergyLevel.values,
              log?.energy,
              (e) => switch (e) {
                EnergyLevel.low => 'Low',
                EnergyLevel.normal => 'Normal',
                EnergyLevel.high => 'High',
              },
              (e) => save(DayLogsCompanion(energy: Value(e))),
            ),
          ),
          section(
            'Cervical mucus',
            choice(
              Mucus.values,
              log?.mucus,
              _mucusLabel,
              (m) => save(DayLogsCompanion(mucus: Value(m))),
            ),
          ),
          section(
            'Ovulation test (LH)',
            choice(
              TestResult.values,
              log?.lhTest,
              (r) => switch (r) {
                TestResult.negative => 'Negative',
                TestResult.positive => 'Positive',
                TestResult.peak => 'Peak',
              },
              (r) => save(DayLogsCompanion(lhTest: Value(r))),
            ),
          ),
          section(
            'Pregnancy test',
            choice(
              const [TestResult.negative, TestResult.positive],
              log?.pregnancyTest,
              (r) => r == TestResult.negative ? 'Negative' : 'Positive',
              (r) => save(DayLogsCompanion(pregnancyTest: Value(r))),
            ),
          ),
          section(
            'Basal body temperature',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NumberField(
                  key: ValueKey(('bbt', day, tempUnit)),
                  initial: log?.bbt == null
                      ? null
                      : toDisplayTemp(log!.bbt!, tempUnit),
                  decimals: 2,
                  suffix: tempSymbol(tempUnit),
                  hint: tempUnit == TempUnit.celsius ? '36.50' : '97.70',
                  onChanged: (v) => save(
                    DayLogsCompanion(
                      bbt: Value(
                        v == null ? null : fromDisplayTemp(v, tempUnit),
                      ),
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: log?.bbtDisturbed ?? false,
                  onChanged: (v) =>
                      save(DayLogsCompanion(bbtDisturbed: Value(v ?? false))),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Reading may be off'),
                  subtitle: const Text(
                    'Illness, alcohol, poor sleep or a different time',
                  ),
                ),
              ],
            ),
            hint: 'Take it right after waking, before getting up',
          ),
          section(
            'Sleep',
            _NumberField(
              key: ValueKey(('sleep', day)),
              initial: log?.sleepHours,
              decimals: 1,
              suffix: 'hours',
              hint: '7.5',
              onChanged: (v) => save(DayLogsCompanion(sleepHours: Value(v))),
            ),
          ),
          section(
            'Weight',
            _NumberField(
              key: ValueKey(('weight', day, weightUnit)),
              initial: log?.weightKg == null
                  ? null
                  : toDisplayWeight(log!.weightKg!, weightUnit),
              decimals: 1,
              suffix: weightSymbol(weightUnit),
              onChanged: (v) => save(
                DayLogsCompanion(
                  weightKg: Value(
                    v == null ? null : fromDisplayWeight(v, weightUnit),
                  ),
                ),
              ),
            ),
          ),
          section(
            'Your tags',
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in tags)
                  FilterChip(
                    label: Text(t.label),
                    selected: symptoms.containsKey(t.key),
                    onSelected: (on) => db.setSymptom(day, t.key, on ? 1 : 0),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('New tag'),
                  onPressed: () async {
                    final label = await _askTagName(context);
                    if (label == null || label.isEmpty) return;
                    final key = await db.addCustomTag(label);
                    await db.setSymptom(day, key, 1);
                  },
                ),
              ],
            ),
            hint: tags.isEmpty
                ? 'Track anything else, like medication side effects or '
                      'exercise'
                : 'Manage tags in Settings',
          ),
          section('Sexual activity', SexEntriesList(day: day)),
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

  static Future<String?> _askTagName(BuildContext context) =>
      showDialog<String>(context: context, builder: (_) => const _TagDialog());

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

class _TagDialog extends StatefulWidget {
  const _TagDialog();

  @override
  State<_TagDialog> createState() => _TagDialogState();
}

class _TagDialogState extends State<_TagDialog> {
  // Owned by the dialog so it outlives the closing animation.
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('New tag'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      maxLength: 30,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(hintText: 'e.g. Ran 5k'),
      onSubmitted: (v) => Navigator.pop(context, v.trim()),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _controller.text.trim()),
        child: const Text('Add'),
      ),
    ],
  );
}

/// Keeps its own count so quick repeated taps aren't lost while the
/// database catches up.
class _Counter extends StatefulWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  late var _value = widget.value;

  @override
  void didUpdateWidget(_Counter old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) _value = widget.value;
  }

  void _set(int v) {
    setState(() => _value = v);
    widget.onChanged(v);
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(widget.label)),
      IconButton(
        icon: const Icon(Icons.remove),
        tooltip: 'Fewer',
        onPressed: _value > 0 ? () => _set(_value - 1) : null,
      ),
      Text('$_value'),
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'More',
        onPressed: _value < 50 ? () => _set(_value + 1) : null,
      ),
    ],
  );
}

/// A decimal input that saves as you type. Empty means "not logged".
class _NumberField extends StatefulWidget {
  const _NumberField({
    super.key,
    required this.initial,
    required this.decimals,
    required this.suffix,
    required this.onChanged,
    this.hint,
  });

  final double? initial;
  final int decimals;
  final String suffix;
  final String? hint;
  final ValueChanged<double?> onChanged;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final _controller = TextEditingController(
    text: widget.initial?.toStringAsFixed(widget.decimals),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 200,
    child: TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixText: widget.suffix,
        hintText: widget.hint,
        isDense: true,
      ),
      onChanged: (v) {
        final value = double.tryParse(v.replaceAll(',', '.'));
        if (v.trim().isEmpty || value != null) widget.onChanged(value);
      },
    ),
  );
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
