import 'package:flutter/material.dart';

const _seed = Color(0xFFB4436C);

ThemeData buildTheme(Brightness brightness) => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
  useMaterial3: true,
);

/// Colors for cycle states, shared by the calendar and Today screen.
class CycleColors {
  CycleColors.of(BuildContext context)
    : period = Theme.of(context).colorScheme.primary,
      onPeriod = Theme.of(context).colorScheme.onPrimary,
      fertile = Theme.of(context).colorScheme.tertiaryContainer,
      ovulation = Theme.of(context).colorScheme.tertiary;

  final Color period;
  final Color onPeriod;
  final Color fertile;
  final Color ovulation;
}
