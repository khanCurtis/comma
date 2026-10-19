import '../dates.dart';

class TempReading {
  const TempReading(this.date, this.celsius, {this.disturbed = false});

  final DateTime date;
  final double celsius;

  /// Illness, alcohol, poor sleep, etc. Disturbed readings are ignored.
  final bool disturbed;
}

/// Detects ovulation within one cycle using the "3 over 6" rule.
///
/// Ovulation is confirmed when three consecutive readings are all above the
/// highest of the six readings before them (the cover line), and the third
/// is at least [threshold] °C above it. Returns the estimated ovulation day
/// (the last low reading before the rise), or null if no shift is found.
DateTime? detectBbtOvulation(
  List<TempReading> readings, {
  double threshold = 0.2,
}) {
  final temps = readings.where((r) => !r.disturbed).toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  for (var i = 6; i + 2 < temps.length; i++) {
    final cover = temps
        .sublist(i - 6, i)
        .map((r) => r.celsius)
        .reduce((a, b) => a > b ? a : b);
    final high = temps.sublist(i, i + 3);
    if (high.every((r) => r.celsius > cover) &&
        high.last.celsius >= cover + threshold - 1e-9) {
      return dateOnly(temps[i - 1].date);
    }
  }
  return null;
}
