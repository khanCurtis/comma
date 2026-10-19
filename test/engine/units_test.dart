import 'package:comma/domain/units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('temperature round trips', () {
    expect(toDisplayTemp(37, TempUnit.fahrenheit), closeTo(98.6, 1e-9));
    expect(fromDisplayTemp(98.6, TempUnit.fahrenheit), closeTo(37, 1e-9));
    expect(toDisplayTemp(36.5, TempUnit.celsius), 36.5);
  });

  test('weight round trips', () {
    expect(toDisplayWeight(1, WeightUnit.lb), closeTo(2.20462, 1e-5));
    expect(
      fromDisplayWeight(toDisplayWeight(61.2, WeightUnit.lb), WeightUnit.lb),
      closeTo(61.2, 1e-9),
    );
  });
}
