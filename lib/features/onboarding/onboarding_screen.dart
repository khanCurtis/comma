import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../domain/dates.dart';
import '../../domain/models/day_log.dart';
import '../../domain/modes.dart';
import '../settings/backup_flow.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  DateTime? _lastPeriod;
  var _cycleLength = 28;
  var _periodLength = 5;
  var _acknowledged = false;
  var _mode = TrackingMode.standard;
  DateTime? _birth;

  Future<void> _finish() async {
    final db = ref.read(databaseProvider);
    if (_lastPeriod != null) {
      for (var i = 0; i < _periodLength; i++) {
        await db.setFlow(addDays(_lastPeriod!, i), FlowLevel.medium);
      }
    }
    await db.setSetting(SettingKeys.mode, _mode.name);
    String iso(DateTime d) => d.toIso8601String().substring(0, 10);
    if (_mode == TrackingMode.pregnant && _lastPeriod != null) {
      await db.setSetting(SettingKeys.pregnancyLastPeriod, iso(_lastPeriod!));
    }
    if (_mode == TrackingMode.postpartum && _birth != null) {
      await db.setSetting(SettingKeys.birthDate, iso(_birth!));
    }
    await db.setSetting(SettingKeys.cycleLength, '$_cycleLength');
    await db.setSetting(SettingKeys.periodLength, '$_periodLength');
    await db.setSetting(SettingKeys.onboarded, 'true');
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Welcome to Comma', style: text.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'Your data stays on this phone, encrypted. There are no accounts '
              'and nothing is sent anywhere.',
            ),
            const SizedBox(height: 32),
            Text('What are you using Comma for?', style: text.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final m in TrackingMode.values)
                  ChoiceChip(
                    label: Text(m.label),
                    selected: _mode == m,
                    onSelected: (_) => setState(() => _mode = m),
                  ),
              ],
            ),
            if (_mode == TrackingMode.postpartum) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.child_friendly_outlined),
                label: Text(
                  _birth == null
                      ? 'When did you give birth?'
                      : 'Gave birth ${DateFormat.yMMMd().format(_birth!)}',
                ),
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: now.subtract(const Duration(days: 730)),
                    lastDate: now,
                    initialDate: _birth ?? now,
                  );
                  if (picked != null) setState(() => _birth = dateOnly(picked));
                },
              ),
            ],
            const SizedBox(height: 24),
            Text(
              _mode == TrackingMode.postpartum
                  ? 'When did your last period start? (optional)'
                  : 'When did your last period start?',
              style: text.titleMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.event),
              label: Text(
                _lastPeriod == null
                    ? 'Choose a date (optional)'
                    : DateFormat.yMMMd().format(_lastPeriod!),
              ),
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: now.subtract(const Duration(days: 365)),
                  lastDate: now,
                  initialDate: _lastPeriod ?? now,
                );
                if (picked != null) {
                  setState(() => _lastPeriod = dateOnly(picked));
                }
              },
            ),
            const SizedBox(height: 24),
            _Stepper(
              label: 'Typical cycle length',
              value: _cycleLength,
              min: 15,
              max: 60,
              onChanged: (v) => setState(() => _cycleLength = v),
            ),
            _Stepper(
              label: 'Typical period length',
              value: _periodLength,
              min: 1,
              max: 14,
              onChanged: (v) => setState(() => _periodLength = v),
            ),
            const SizedBox(height: 8),
            Text(
              "Not sure? Leave the defaults. Comma learns from what you log.",
              style: text.bodySmall,
            ),
            const SizedBox(height: 24),
            CheckboxListTile(
              value: _acknowledged,
              onChanged: (v) => setState(() => _acknowledged = v ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'I understand Comma is not a medical device and must not be '
                'used as contraception.',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _acknowledged ? _finish : null,
              child: const Text('Get started'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.restore),
              label: const Text('Restore from a backup'),
              onPressed: () => importBackupFlow(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Decrease',
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          Text('$value days'),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Increase',
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
