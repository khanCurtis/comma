/// Date helpers. All dates in the domain layer are calendar days stored as
/// UTC midnight, so arithmetic is never affected by DST changes.
library;

DateTime dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// Whole days from [a] to [b] (positive when [b] is later).
int daysBetween(DateTime a, DateTime b) =>
    dateOnly(b).difference(dateOnly(a)).inDays;

DateTime addDays(DateTime d, int days) {
  final base = dateOnly(d);
  return DateTime.utc(base.year, base.month, base.day + days);
}
