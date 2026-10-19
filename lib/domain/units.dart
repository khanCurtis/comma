/// Unit conversion. Values are stored in metric and converted for display.
library;

enum TempUnit { celsius, fahrenheit }

enum WeightUnit { kg, lb }

double toDisplayTemp(double celsius, TempUnit unit) =>
    unit == TempUnit.celsius ? celsius : celsius * 9 / 5 + 32;

double fromDisplayTemp(double value, TempUnit unit) =>
    unit == TempUnit.celsius ? value : (value - 32) * 5 / 9;

double toDisplayWeight(double kg, WeightUnit unit) =>
    unit == WeightUnit.kg ? kg : kg / 0.45359237;

double fromDisplayWeight(double value, WeightUnit unit) =>
    unit == WeightUnit.kg ? value : value * 0.45359237;

String tempSymbol(TempUnit unit) => unit == TempUnit.celsius ? '°C' : '°F';

String weightSymbol(WeightUnit unit) => unit == WeightUnit.kg ? 'kg' : 'lb';
