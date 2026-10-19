import 'package:comma/app/providers.dart';
import 'package:comma/data/db/database.dart';
import 'package:comma/domain/dates.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:comma/domain/modes.dart';
import 'package:comma/features/modes/mode_screen.dart';
import 'package:comma/features/today/today_screen.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'medications_test.dart' show FakeNotifications;

String iso(DateTime d) => d.toIso8601String().substring(0, 10);

void main() {
  late AppDatabase db;
  final today = dateOnly(DateTime.now());

  setUp(() {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  Future<void> pump(WidgetTester tester, Widget home) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          notificationServiceProvider.overrideWithValue(FakeNotifications()),
        ],
        child: MaterialApp(home: Scaffold(body: home)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await db.close();
  }

  Future<void> logPeriod(DateTime start) async {
    for (var i = 0; i < 4; i++) {
      await db.setFlow(addDays(start, i), FlowLevel.medium);
    }
  }

  testWidgets('pregnancy shows weeks, due date and warning signs', (
    tester,
  ) async {
    final lmp = addDays(today, -87);
    await logPeriod(lmp);
    await db.setSetting(SettingKeys.mode, TrackingMode.pregnant.name);
    await db.setSetting(SettingKeys.pregnancyLastPeriod, iso(lmp));
    await pump(tester, const TodayScreen());

    expect(find.text('12 weeks'), findsOneWidget);
    expect(find.text('+ 3 days'), findsOneWidget);
    expect(find.textContaining('Trimester 1'), findsOneWidget);
    expect(find.textContaining('warning signs'), findsOneWidget);
    expect(find.text('Next period'), findsNothing);
    await finish(tester);
  });

  testWidgets('ending a pregnancy after a loss excludes that cycle', (
    tester,
  ) async {
    final lmp = addDays(today, -60);
    await logPeriod(lmp);
    await db.setSetting(SettingKeys.mode, TrackingMode.pregnant.name);
    await db.setSetting(SettingKeys.pregnancyLastPeriod, iso(lmp));
    await pump(tester, const ModeScreen());

    await tester.tap(find.text('Track my cycle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I had a miscarriage or pregnancy loss'));
    await tester.pumpAndSettle();

    final settings = {
      for (final s in await db.select(db.settings).get()) s.key: s.value,
    };
    expect(settings[SettingKeys.mode], TrackingMode.standard.name);
    expect(settings[SettingKeys.excludedCycles], iso(lmp));
    expect(find.text('Pregnancy loss'), findsOneWidget); // article opened
    await finish(tester);
  });

  testWidgets('postpartum ignores bleeding right after birth', (tester) async {
    final birth = addDays(today, -15);
    await logPeriod(addDays(birth, -300)); // before pregnancy
    await logPeriod(addDays(birth, 1)); // lochia
    await db.setSetting(SettingKeys.mode, TrackingMode.postpartum.name);
    await db.setSetting(SettingKeys.birthDate, iso(birth));
    await pump(tester, const TodayScreen());

    expect(find.text('2 weeks'), findsOneWidget);
    expect(find.textContaining("won't be counted"), findsOneWidget);
    await finish(tester);
  });

  testWidgets('trying to conceive relabels the fertile window', (tester) async {
    // A 28-day cycle that started 10 days ago: today is in the fertile window.
    await logPeriod(addDays(today, -38));
    await logPeriod(addDays(today, -10));
    await db.setSetting(SettingKeys.mode, TrackingMode.ttc.name);
    await pump(tester, const TodayScreen());

    expect(find.text('Good days to try'), findsOneWidget);
    expect(find.textContaining('every 1 to 2 days'), findsOneWidget);
    await finish(tester);
  });
}
