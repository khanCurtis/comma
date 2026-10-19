# Comma: Project Plan

## 0. Ground rules (legal and ethical)

This is a **clean-room, independent implementation** of features common to cycle-tracking apps. Feature ideas such as period logging, ovulation estimates and symptom tracking are not protected. Someone else's code, assets and branding are.

- **Do not** decompile, disassemble or copy code, assets, strings, icons, illustrations, color schemes or UI layouts from any commercial app.
- **Do not** use any competitor's name or trademark in the code, docs, store listings, commit messages, issues or marketing.
- Base every feature on **public medical literature** and on our own design. Cite sources in `docs/PREDICTIONS.md`.
- Write all UI copy and design all screens from scratch.
- Keep the medical disclaimer visible: we are not a medical device and not contraception. This keeps us out of FDA/MDR "software as a medical device" territory.

## 1. Tech stack

| Concern | Choice | Why |
|---|---|---|
| Framework | **Flutter (Dart)** | One codebase for Android and iOS; F-Droid accepts Flutter apps |
| Database | **drift** + **sqlcipher_flutter_libs** | Typed SQL, migrations, and encryption at rest |
| Key storage | **flutter_secure_storage** | Keeps the DB key in Android Keystore / iOS Keychain |
| State | **Riverpod** | Testable, no codegen required |
| PDF | **pdf** + **printing** packages | Builds the doctor report on-device and opens the native share/print sheet |
| Charts | **fl_chart** | Cycle length, BBT and symptom charts |
| Notifications | **flutter_local_notifications** | Period and pill reminders, entirely local |
| Biometrics | **local_auth** | App lock |
| i18n | Flutter `intl` / ARB files | Community translations through Weblate |

**No** Firebase, Google Play Services, analytics SDKs or crash reporters. These are required for F-Droid inclusion and for the privacy promise. On Android, the `INTERNET` permission is left out of the manifest entirely.

## 2. Architecture

```
lib/
  main.dart
  app/            # routing, theme, app lock gate
  data/
    db/           # drift tables, DAOs, migrations
    repositories/
  domain/
    models/       # pure Dart entities
    engine/       # cycle math: predictions, ovulation detection, irregularity rules
  features/
    calendar/     # month view + daily log sheet
    today/        # home screen: cycle day, phase, next prediction
    log/          # daily logging UI
    insights/     # charts and stats
    reports/      # PDF / CSV / JSON export
    reminders/
    settings/     # modes, lock, backup, wipe
  l10n/
test/
  engine/         # heavy unit test coverage on the prediction engine
```

The `domain/engine` folder is **pure Dart with no Flutter imports**. This keeps it 100% unit-testable and lets it be reused later (for example in a web build).

## 3. Data model

```
Profile        id, birth_year?, typical_cycle_len?, typical_period_len?, luteal_len_default=14,
               mode (standard|ttc|pregnant|postpartum|perimenopause), units (C/F, kg/lb)

Cycle          id, start_date, end_date? (derived: day before next start),
               period_end_date?, ovulation_date?, ovulation_source (estimated|bbt|lh|manual),
               excluded_from_stats (bool; e.g. post-pill, pregnancy loss)

DayLog         date (PK), flow (none|spotting|light|medium|heavy), products_used?,
               mucus (dry|sticky|creamy|watery|egg_white)?, cervix_position?,
               bbt?, bbt_time?, bbt_disturbed (bool),
               lh_test (neg|pos|peak)?, pregnancy_test (neg|pos)?,
               sex (none|protected|unprotected)?, libido?, mood[], energy?,
               sleep_hours?, weight?, note?

SymptomEntry   date, symptom_id, severity (1-3)
Symptom        id, name, category (pain|digestive|skin|mood|other), is_custom
Medication     id, name, dose, schedule, is_contraceptive, active_from, active_to
MedicationLog  date, medication_id, taken (bool), time
Tag / DayTag   custom user tags
Reminder       type, time, enabled, custom_text
Pregnancy      id, lmp_date, due_date, ended_date?, outcome?
```

Cycles are **derived** from DayLog flow plus the user's "period started" taps, then cached in `Cycle`. They are recomputed whenever a log changes.

## 4. Prediction engine (`domain/engine`)

1. **Cycle length**: an exponentially weighted mean of the last 6–12 non-excluded cycles. The confidence range is ±1 SD, with a floor of ±2 days. With fewer than 3 cycles, fall back to the user's onboarding values or 28 days, and show low confidence.
2. **Period length**: the median of recent periods.
3. **Ovulation estimate**: next predicted start − personal luteal length. The personal luteal length is the average across cycles with confirmed ovulation, and defaults to 14.
4. **BBT confirmation**: apply the "3 over 6" rule. Three consecutive temperatures that are each ≥0.2 °C above the highest of the previous 6 confirm ovulation on the day before the rise. Readings marked as disturbed are skipped.
5. **LH**: ovulation is estimated 1 day after the first positive or peak result.
6. **Fertile window**: estimated ovulation −5 to +1 days.
7. **Irregularity flags** (doctor-relevant, based on FIGO System 1):
   - Cycle < 24 or > 38 days
   - Cycle-to-cycle variation > 9 days
   - Period > 8 days
   - No period for 90+ days (when not pregnant)
   - Bleeding between periods
   - Heavy flow every hour for several hours
8. **Pregnancy mode**: due date = LMP + 280 days (Naegele's rule), adjusted for cycle length.

Every rule has unit tests built on synthetic fixture data, never real user data.

## 5. Doctor export

**PDF report** (`features/reports`), with user-selectable date range and sections:
- Header: report date, range and optional name/age. Everything is opt-in, and the default is anonymous.
- Summary: average cycle length (range), average period length, number of cycles, last period start
- Table: one row per cycle with start date, cycle length, period length, peak flow, ovulation date and source
- Chart: cycle length over time
- Symptom frequency: % of cycles with each symptom, grouped by phase
- BBT chart (if logged)
- Medications and contraception history
- Flagged irregularities, in plain language
- User notes (optional)
- Footer disclaimer

**Data export**: CSV (one file per table, zipped) and full JSON for backup and portability.
**Import**: a generic CSV importer with column mapping, so users can bring data from other apps' exports.

## 6. Roadmap

### Phase 1: MVP (core tracking)
- [ ] Flutter project scaffold, CI, license, CONTRIBUTING, code of conduct
- [ ] Encrypted drift DB + key management
- [ ] Onboarding (typical cycle and period length, last period date)
- [ ] Calendar view + daily log sheet (flow, symptoms, mood, notes)
- [ ] Today screen: cycle day, phase, next period countdown
- [ ] Prediction engine v1 (cycle length, period length, ovulation estimate, fertile window), fully tested
- [ ] Period reminders

### Phase 2: Fertility signals and export
- [ ] BBT, mucus, LH and pregnancy tests
- [ ] BBT chart + ovulation confirmation
- [ ] PDF doctor report
- [ ] CSV / JSON export, encrypted backup and restore
- [ ] App lock (PIN + biometrics)

### Phase 3: Insights and modes
- [ ] Insights screen (charts, stats, symptom patterns)
- [ ] Irregularity flags
- [ ] Medications and pill reminders
- [ ] Pregnancy, postpartum, perimenopause and trying-to-conceive modes
- [ ] Custom symptoms and tags
- [ ] CSV import

### Phase 4: Polish and reach
- [ ] Accessibility audit (screen readers, contrast, text scaling)
- [ ] Translations through Weblate
- [ ] Discreet icon option, panic wipe
- [ ] Home screen widget
- [ ] Optional: user-controlled encrypted sync (WebDAV / Syncthing folder), still with no first-party server

## 7. Releasing

### Android (APK)
1. Create an upload keystore. Store it as a GitHub Actions secret, and **never commit it**.
2. A GitHub Actions workflow on tag `v*` runs `flutter test`, then `flutter build apk --release --split-per-abi` plus a universal APK, signs them, and attaches them to a GitHub Release with SHA-256 checksums.
3. **F-Droid**: submit a merge request to `fdroiddata`. Requirements: no proprietary dependencies, no tracking, and a reproducible build recipe. Fastlane metadata goes in `fastlane/metadata/android/` so F-Droid picks up the description and screenshots.
4. **Obtainium / IzzyOnDroid**: both work directly from GitHub Releases. IzzyOnDroid is a good stopgap while F-Droid review is pending.

### iOS (sideload only, no App Store)
- A GitHub Actions `macos-latest` job runs `flutter build ios --release --no-codesign`, zips `Runner.app` into `Payload/`, and attaches the result as `comma-<version>.ipa` to the same GitHub Release.
- Users install it with **AltStore** or **SideStore** using a free Apple ID. Apps must be re-signed every 7 days, which those tools handle automatically.
- Optional later step: publish an AltStore "source" JSON file in the repo, so updates show up inside AltStore.

## 8. Privacy and compliance checklist
- [ ] No `INTERNET` permission on Android. Document this in the README as a verifiable claim.
- [ ] Privacy statement in the README stating that no data is collected
- [ ] Encrypted DB; exclude it from cloud backups (`android:allowBackup="false"`, iOS `NSURLIsExcludedFromBackupKey`) unless the user opts in
- [ ] Neutral notification wording by default ("Reminder" rather than "Your period is coming")
- [ ] Medical disclaimer during onboarding and in the PDF report
- [ ] Never use real health data in tests, issues or screenshots

## 9. Open decisions
1. ~~License~~: GPL-3.0 (no app-store distribution, so there is no conflict)
2. Whether to support optional sync at all, or stay strictly offline
3. Minimum OS versions (suggested: Android 7 / API 24, iOS 13)
4. Final app icon
