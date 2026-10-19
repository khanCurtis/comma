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

enum SexKind { partnered, solo }

/// Protection used during one sexual encounter.
enum SexProtection {
  unprotected,
  condom,
  withdrawal,

  /// Any other method, or "protected" without details.
  otherProtection,
}
