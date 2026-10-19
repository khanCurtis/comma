import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../domain/dates.dart';
import '../../domain/engine/predictor.dart';
import '../../domain/models/cycle.dart';
import '../log/day_log_sheet.dart';
import '../sex/sex_entry_sheet.dart';

enum _DayKind { none, period, predictedPeriod, fertile, ovulation }

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _month = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
  );

  void _shift(int months) =>
      setState(() => _month = DateTime.utc(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final cycles = ref.watch(cyclesProvider).value ?? const [];
    final predictions = ref.watch(predictionsProvider);
    final today = ref.watch(todayProvider);
    final text = Theme.of(context).textTheme;
    final colors = CycleColors.of(context);

    final first = _month;
    final daysInMonth = DateTime.utc(first.year, first.month + 1, 0).day;
    final sexDays = {
      for (final e
          in ref
                  .watch(
                    sexEntriesProvider((
                      first,
                      DateTime.utc(first.year, first.month, daysInMonth),
                    )),
                  )
                  .value ??
              const [])
        e.date,
    };
    final leading = (first.weekday + 6) % 7; // Monday first
    final weekdays = [
      for (var i = 0; i < 7; i++)
        DateFormat.E().format(DateTime.utc(2024, 1, 1 + i)), // Jan 1 2024 = Mon
    ];

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous month',
                onPressed: () => _shift(-1),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM().format(first),
                  style: text.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next month',
                onPressed: () => _shift(1),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final w in weekdays)
                Expanded(
                  child: Text(
                    w,
                    textAlign: TextAlign.center,
                    style: text.labelMedium,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          // Keep cells a sensible size on tablets and in landscape.
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < leading; i++) const SizedBox.shrink(),
                  for (var d = 1; d <= daysInMonth; d++)
                    _DayCell(
                      day: DateTime.utc(first.year, first.month, d),
                      kind: _kindOf(
                        DateTime.utc(first.year, first.month, d),
                        cycles,
                        predictions,
                      ),
                      isToday:
                          DateTime.utc(first.year, first.month, d) == today,
                      hasSex: sexDays.contains(
                        DateTime.utc(first.year, first.month, d),
                      ),
                      colors: colors,
                    ),
                ],
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _Legend(color: colors.period, label: 'Period'),
            _Legend(color: colors.period, label: 'Predicted', outlined: true),
            _Legend(color: colors.fertile, label: 'Fertile'),
            _Legend(color: colors.ovulation, label: 'Ovulation'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite,
                  size: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                const Text('Sex'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _DayKind _kindOf(
    DateTime day,
    List<Cycle> cycles,
    List<CyclePrediction> predictions,
  ) {
    bool within(DateTime from, DateTime to) =>
        !day.isBefore(from) && !day.isAfter(to);

    for (final c in cycles) {
      if (within(c.start, c.periodEnd)) return _DayKind.period;
    }
    // Only show predictions for days after the latest logged period.
    if (cycles.isNotEmpty && !day.isAfter(cycles.last.periodEnd)) {
      return _DayKind.none;
    }
    for (final p in predictions) {
      if (within(p.periodStart, p.periodEnd)) return _DayKind.predictedPeriod;
      if (day == p.ovulation) return _DayKind.ovulation;
      if (within(p.fertileStart, p.fertileEnd)) return _DayKind.fertile;
    }
    return _DayKind.none;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.kind,
    required this.isToday,
    required this.hasSex,
    required this.colors,
  });

  final DateTime day;
  final _DayKind kind;
  final bool isToday;
  final bool hasSex;
  final CycleColors colors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color? fill, Color? border, Color? fg) = switch (kind) {
      _DayKind.period => (colors.period, null, colors.onPeriod),
      _DayKind.predictedPeriod => (null, colors.period, null),
      _DayKind.fertile => (colors.fertile, null, null),
      _DayKind.ovulation => (colors.ovulation, null, scheme.onTertiary),
      _DayKind.none => (null, null, null),
    };

    return Padding(
      padding: const EdgeInsets.all(3),
      child: Material(
        color: fill ?? Colors.transparent,
        shape: CircleBorder(
          side: border != null
              ? BorderSide(color: border, width: 2)
              : isToday
              ? BorderSide(color: scheme.outline)
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: day.isAfter(dateOnly(DateTime.now()))
              ? null
              : () => showDayLogSheet(context, day),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${day.day}',
                style: TextStyle(
                  color: fg,
                  fontWeight: isToday ? FontWeight.bold : null,
                ),
              ),
              if (hasSex)
                Positioned(
                  bottom: 2,
                  child: Icon(
                    Icons.favorite,
                    size: 9,
                    color: fg ?? scheme.primary,
                    semanticLabel: 'Sex logged',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.color,
    required this.label,
    this.outlined = false,
  });

  final Color color;
  final String label;
  final bool outlined;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: outlined ? null : color,
          border: outlined ? Border.all(color: color, width: 2) : null,
        ),
      ),
      const SizedBox(width: 6),
      Text(label),
    ],
  );
}
