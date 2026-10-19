# Comma

**A private, open-source menstrual cycle tracker.** Your data stays on your device: no accounts, no ads, no analytics, and no servers.

> ⚠️ **Comma is not a medical device and is not a form of contraception.** Predictions are estimates based on the data you enter. Talk to a healthcare provider about medical decisions.

---

## Why Comma?

Cycle data is some of the most sensitive health data a person can have. Many popular trackers send it to third parties or keep it on servers that can be subpoenaed. Comma works differently:

- **Local-first.** Everything is stored in an encrypted database on your phone.
- **No network access.** The app does not request internet permission on Android.
- **No accounts.** There's nothing to sign up for and nothing to leak.
- **Open source.** Anyone can audit the code.
- **You own your data.** Export everything at any time as CSV, JSON or a PDF report.

## Features

### Tracking
- Period start and end dates, with daily flow intensity (spotting, light, medium, heavy) and an optional product count
- Symptoms: cramps, headache, bloating, breast tenderness, acne, back pain, nausea, fatigue and more, each with a severity
- Mood and energy
- Cervical mucus and discharge
- Basal body temperature (BBT)
- Ovulation (LH) and pregnancy test results
- Sexual activity: log partnered sex and masturbation separately, as many times a day as needed, with optional time, protection used (for partnered sex), orgasm and notes
- Medications and birth control, with pill reminders
- Sleep, weight and free-text notes
- Your own custom tags

### Predictions and insights
- Next period prediction, with a confidence range
- Estimated ovulation day and fertile window
- Ovulation confirmation from your BBT shift and LH tests (when you log them)
- Cycle and period length history, averages and variability
- Alerts for irregular patterns worth raising with a doctor, such as very short or long cycles, missed periods, or unusually long bleeding
- Symptom patterns by cycle phase

### Modes
- Standard tracking
- Trying to conceive
- Pregnancy (week-by-week, with due date)
- Postpartum and breastfeeding
- Perimenopause

### Learn and get help
- Short, sourced articles on period pain, period products, heavy periods, PMS/PMDD, when to see a doctor, emergency contraception, STI testing, contraception, pain during sex, sex drive, consent, the fertile window and pregnancy tests
- Tips on the Today screen based on where you are in your cycle
- After you log unprotected sex, a gentle pointer to emergency contraception and STI testing information
- A "Get help" page with emergency numbers and confidential support lines (US, UK, Canada, Australia, plus a worldwide directory). Calls and links open in your phone's own apps, and Comma sends nothing anywhere.

### Reports for doctors
- A clean, printable **PDF report** for a chosen date range: cycle history table, cycle length chart, period length and flow summary, symptom frequency, medications and flagged irregularities
- Full data export as **CSV** and **JSON**
- Share the report through your phone's share sheet (email, messaging, print, save to files)

### Privacy and security
- Encrypted on-device database (SQLCipher)
- Optional app lock with PIN or biometrics
- Discreet app icon and neutral notification text
- Encrypted backup file that you control: save it anywhere, restore it anywhere
- Panic wipe option

## Installation

### Android
Requires Android 7.0 or newer.

- **F-Droid**: *(coming soon)*
- **GitHub Releases**: download the latest signed APK from the [Releases](../../releases) page
- **Obtainium**: add this repository's URL to get automatic updates from GitHub Releases

### iOS / iPadOS
Comma is not on the App Store. Each release includes an unsigned `.ipa` that you can sideload with [AltStore](https://altstore.io) or [SideStore](https://sidestore.io), using a free Apple ID. With a free Apple ID, sideloaded apps must be refreshed every 7 days. AltStore and SideStore can do this automatically.

## Backing up your data

Your data lives only on your phone. **Uninstalling the app permanently deletes it.** The encryption key is stored in your phone's secure storage and is removed along with the app.

To keep your data safe:
1. Go to **Settings → Back up data**, choose a password, and save the `.comma` file somewhere other than your phone (a computer, USB drive or your own cloud storage).
2. To restore, choose **Restore from a backup** on the welcome screen, or **Settings → Restore from backup**.

Backups are encrypted with AES-256-GCM using a key derived from your password. If you forget the password, nobody can open the backup, including you. The file format is documented in [`docs/BACKUP_FORMAT.md`](docs/BACKUP_FORMAT.md), so your data is never locked into the app.

Back up before switching phones, and before installing Comma from a different source (for example, moving from GitHub Releases to F-Droid). Android refuses to install an update signed by a different key, so you'd need to uninstall first.

## Building from source

Comma is built with [Flutter](https://flutter.dev).

```bash
# Prerequisites: Flutter SDK (stable channel), Android SDK, and Xcode for iOS (macOS only)
git clone https://github.com/<your-username>/comma.git
cd comma
flutter pub get

# Run in debug mode on a connected device or emulator
flutter run

# Build a release APK
flutter build apk --release

# Build an unsigned iOS app (requires macOS)
flutter build ios --release --no-codesign
```

Run the tests with:

```bash
flutter test
```

## How predictions work

Comma uses transparent, well-documented methods. There is no black-box model:

1. **Cycle length**: a weighted average of your recent cycles (the most recent count for more), with a confidence range taken from your cycle-to-cycle variation.
2. **Ovulation**: estimated as the predicted next period minus your luteal phase length. The default is 14 days, and Comma personalizes it once you have confirmed ovulations.
3. **Confirmation**: a sustained rise in BBT (the "3 over 6" rule) and/or a positive LH test confirms ovulation after the fact.
4. **Fertile window**: the 5 days before estimated ovulation plus the day of ovulation.

See [`docs/PREDICTIONS.md`](docs/PREDICTIONS.md) for details.

## Contributing

Contributions are welcome! Please read [`CONTRIBUTING.md`](CONTRIBUTING.md) first. We especially welcome:
- Translations
- Accessibility improvements
- Review from medical professionals
- Bug reports with steps to reproduce

Please **never** include real personal health data in issues, screenshots or test fixtures.

## License

Comma is licensed under the [GNU General Public License v3.0](LICENSE).

## Disclaimer

Comma is provided for informational purposes only. It is not intended to diagnose, treat, cure or prevent any disease, and it must not be used as contraception. Always seek the advice of a qualified healthcare provider.
