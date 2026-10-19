import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/dates.dart';
import '../../domain/models/cycle.dart';

/// Shared styling: one series in the theme's primary color, a recessive
/// grid, muted axis text, and values on touch rather than on every point.
FlGridData _grid(ColorScheme scheme) => FlGridData(
  drawVerticalLine: false,
  getDrawingHorizontalLine: (_) => FlLine(
    color: scheme.outlineVariant.withValues(alpha: 0.5),
    strokeWidth: 1,
  ),
);

AxisTitles _axis(
  BuildContext context, {
  required double reservedSize,
  double? interval,
  String Function(double)? format,
}) => AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: reservedSize,
    interval: interval,
    getTitlesWidget: (value, meta) => SideTitleWidget(
      meta: meta,
      child: Text(
        format?.call(value) ?? meta.formattedValue,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ),
  ),
);

const _noTitles = AxisTitles();

/// A round step that gives about four gridlines across [span].
double _niceStep(double span) {
  for (final step in [0.1, 0.2, 0.25, 0.5, 1.0, 2.0]) {
    if (span / step <= 5) return step;
  }
  return 5;
}

/// Temperature by cycle day for one cycle, with the estimated ovulation day
/// marked when known.
class TemperatureChart extends StatelessWidget {
  const TemperatureChart({
    super.key,
    required this.cycleStart,
    required this.readings,
    required this.unitSymbol,
    this.ovulation,
  });

  final DateTime cycleStart;

  /// (date, value in display units), excluding disturbed readings.
  final List<(DateTime, double)> readings;
  final String unitSymbol;
  final DateTime? ovulation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spots = [
      for (final (date, value) in readings)
        FlSpot(daysBetween(cycleStart, date) + 1.0, value),
    ];
    final values = spots.map((s) => s.y);
    final minY = values.reduce(math.min);
    final maxY = values.reduce(math.max);
    final step = _niceStep(maxY - minY + 0.4);
    // Snap the visible range to whole steps so gridlines and labels line up.
    final lowY = ((minY - step / 2) / step).floorToDouble() * step;
    final highY = ((maxY + step / 2) / step).ceilToDouble() * step;
    final ovulationDay = ovulation == null
        ? null
        : daysBetween(cycleStart, ovulation!) + 1.0;

    return Semantics(
      label: 'Temperature chart, ${spots.length} readings',
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            minY: lowY,
            maxY: highY,
            minX: 1,
            maxX: math.max(spots.last.x, 14),
            gridData: _grid(scheme),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: _noTitles,
              rightTitles: _noTitles,
              leftTitles: _axis(
                context,
                reservedSize: 52,
                interval: step,
                format: (v) => v.toStringAsFixed(step < 0.25 ? 1 : 2),
              ),
              bottomTitles: _axis(
                context,
                reservedSize: 24,
                interval: 7,
                format: (v) => v % 7 == 0 ? 'Day ${v.toInt()}' : '',
              ),
            ),
            extraLinesData: ExtraLinesData(
              verticalLines: [
                if (ovulationDay != null)
                  VerticalLine(
                    x: ovulationDay,
                    color: scheme.tertiary,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                    label: VerticalLineLabel(
                      show: true,
                      // Lower right is empty: temperatures rise after ovulation.
                      alignment: Alignment.bottomRight,
                      style: Theme.of(context).textTheme.labelSmall,
                      labelResolver: (_) => 'Ovulation',
                    ),
                  ),
              ],
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => scheme.inverseSurface,
                fitInsideHorizontally: true,
                getTooltipItems: (spots) => [
                  for (final s in spots)
                    LineTooltipItem(
                      'Day ${s.x.toInt()}\n'
                      '${s.y.toStringAsFixed(2)} $unitSymbol',
                      TextStyle(color: scheme.onInverseSurface),
                    ),
                ],
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                color: scheme.primary,
                barWidth: 2,
                dotData: FlDotData(
                  getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                    radius: 4,
                    color: scheme.primary,
                    strokeWidth: 2,
                    strokeColor: scheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Length of each recent complete cycle, with the typical 24–38 day range
/// shown as dashed reference lines.
class CycleLengthChart extends StatelessWidget {
  const CycleLengthChart({super.key, required this.cycles});

  /// Complete cycles, oldest first.
  final List<Cycle> cycles;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat.MMMd();
    final maxLength = cycles.map((c) => c.length!).reduce(math.max);

    HorizontalLine reference(double y) => HorizontalLine(
      y: y,
      color: scheme.outline,
      strokeWidth: 1,
      dashArray: [4, 4],
    );

    return Semantics(
      label: 'Cycle length chart, ${cycles.length} cycles',
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: ((math.max(45, maxLength + 5) / 10).ceil() * 10).toDouble(),
            gridData: _grid(scheme),
            borderData: FlBorderData(show: false),
            extraLinesData: ExtraLinesData(
              horizontalLines: [reference(24), reference(38)],
            ),
            titlesData: FlTitlesData(
              topTitles: _noTitles,
              rightTitles: _noTitles,
              leftTitles: _axis(context, reservedSize: 32, interval: 10),
              bottomTitles: _axis(
                context,
                reservedSize: 24,
                format: (v) {
                  final i = v.toInt();
                  // Label every other bar when crowded.
                  if (cycles.length > 6 && i.isOdd) return '';
                  return fmt.format(cycles[i].start);
                },
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => scheme.inverseSurface,
                fitInsideHorizontally: true,
                getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                  '${fmt.format(cycles[group.x].start)}\n'
                  '${rod.toY.toInt()} days',
                  TextStyle(color: scheme.onInverseSurface),
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < cycles.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: cycles[i].length!.toDouble(),
                      color: scheme.primary,
                      width: 14,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
