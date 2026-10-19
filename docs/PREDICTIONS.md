# How Comma's predictions work

All prediction code lives in `lib/domain/engine/`, is plain Dart and has unit tests in `test/engine/`. Nothing here is a black box, and nothing here is contraception.

## Periods and cycles (`cycle_builder.dart`)
- A **period day** is any day logged as light, medium or heavy flow. Spotting does not count.
- Period days separated by **2 or fewer** unlogged or non-bleeding days are merged into one period, so a forgotten log doesn't split a period in two.
- A **cycle** runs from the first day of one period to the day before the next period starts.

## Cycle and period length (`predictor.dart`)
- Comma uses up to the **12 most recent complete cycles**.
- Cycles shorter than 15 or longer than 90 days are treated as data errors or special events, and left out. You can also exclude any cycle by hand, for example one just after stopping hormonal birth control.
- **Cycle length** is an exponentially weighted mean. Each cycle back counts 0.85× as much as the one after it.
- **Period length** is the median of the same cycles.

## Next period
- Predicted start = last period start + cycle length.
- With fewer than 3 complete cycles, confidence is **low** and the range is ±3 days.
- Otherwise the range is ±max(2, standard deviation) days. Confidence is **high** when the standard deviation is ≤ 3 days, and **medium** otherwise.
- Each cycle predicted further ahead widens the range and is always low confidence.

## Ovulation and fertile window
- **Estimated ovulation** = predicted period start − luteal phase length.
- The luteal phase defaults to **14 days**. Once ovulation has been confirmed in some cycles, Comma uses your personal average instead, limited to 10–16 days.
- **Fertile window** = 5 days before ovulation through 1 day after. Sperm can survive up to about 5 days, and the egg about 1 day (Wilcox et al., *NEJM* 1995).

## Confirming ovulation with temperature (`bbt.dart`)
Comma uses the "3 over 6" rule from fertility-awareness methods:
- Find three consecutive readings that are all higher than the highest of the 6 readings before them (the "cover line").
- The third reading must be at least **0.2 °C** above the cover line.
- Ovulation is placed on the last low day before the rise.
- Readings marked as disturbed (illness, alcohol, poor sleep, a different measuring time) are skipped.

A positive LH (ovulation) test means ovulation is likely within about 24–36 hours.

## Things to discuss with a doctor (`irregularity.dart`)
These thresholds come from the FIGO System 1 definitions of normal uterine bleeding (Munro et al., *Int J Gynecol Obstet* 2018):

| Flag | Rule |
|---|---|
| Short cycle | under 24 days |
| Long cycle | over 38 days |
| Irregular cycles | shortest and longest of the last 6 cycles differ by more than 9 days |
| Long period | bleeding for more than 8 days |
| Missed periods | 90+ days since the last period (not shown in pregnancy mode) |

A flag doesn't mean something is wrong. It's information worth bringing to a healthcare provider, and it's included in the doctor report.
