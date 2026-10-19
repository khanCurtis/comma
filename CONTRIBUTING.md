# Contributing to Comma

Thanks for helping! A few ground rules keep the project healthy, private and legally safe.

## Ground rules
- **Clean-room only.** Never copy code, text, icons, illustrations or screen designs from another cycle-tracking app, and never decompile one. Build features from public medical sources and our own designs.
- **Don't name other apps** in code, comments, commits, issues or docs.
- **No network code.** Comma must work with no internet permission. PRs that add analytics, crash reporting, ads or remote calls will be declined.
- **No real health data** in issues, screenshots, test fixtures or commits. Use made-up data.
- **Cite sources.** Changes to prediction or health logic must cite a medical source and update `docs/PREDICTIONS.md`.

## Development setup
1. Install Flutter. The pinned version is in `mise.toml`, and `mise install` sets it up. Any matching Flutter install works too.
2. `flutter pub get`
3. `flutter test`
4. `flutter run` with an Android device or emulator connected (or an iOS simulator on macOS).

After changing database tables (`lib/data/db/`), regenerate code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit the generated `*.g.dart` files. CI checks that they're up to date.

## Project layout
- `lib/domain/`: pure Dart models and the prediction engine (no Flutter imports)
- `lib/data/`: encrypted database
- `lib/features/`: screens
- `lib/app/`: app shell, theme and Riverpod providers
- `test/`: unit and widget tests. Engine changes need tests.

## Pull requests
- Keep them focused, with one feature or fix per PR.
- Make sure `flutter analyze` and `flutter test` pass.
- Describe what changed and how you tested it.
