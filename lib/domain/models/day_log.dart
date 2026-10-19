enum FlowLevel {
  none,
  spotting,
  light,
  medium,
  heavy;

  /// Spotting does not count as a period day.
  bool get isBleeding => index >= FlowLevel.light.index;
}

enum Mucus { dry, sticky, creamy, watery, eggWhite }

enum TestResult { negative, positive, peak }

enum SexActivity { none, protected, unprotected }
