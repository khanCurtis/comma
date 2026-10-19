import 'package:comma/app/providers.dart';
import 'package:comma/data/db/database.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:comma/domain/units.dart';
import 'package:comma/features/log/day_log_sheet.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final day = DateTime.utc(2026, 3, 2);

// One-off queries: drift's watch() streams rely on timers that never fire
// inside a widget test's fake clock.
Future<DayLog> logOf(AppDatabase db) => db.select(db.dayLogs).getSingle();

Future<Map<String, int>> symptomsOf(AppDatabase db) async => {
  for (final r in await db.select(db.symptomEntries).get())
    r.symptom: r.severity,
};

void main() {
  late AppDatabase db;

  Future<void> pumpSheet(WidgetTester tester) async {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tempUnitProvider.overrideWithValue(TempUnit.fahrenheit),
        ],
        child: MaterialApp(
          home: Scaffold(body: DayLogSheet(day: day)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find
          .descendant(
            of: find.byType(DayLogSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await db.close();
  }

  testWidgets('symptom severity cycles mild → moderate → severe → off', (
    tester,
  ) async {
    await pumpSheet(tester);
    for (final expected in [
      'Cramps · mild',
      'Cramps · moderate',
      'Cramps · severe',
    ]) {
      await tester.tap(find.textContaining('Cramps'));
      await tester.pumpAndSettle();
      expect(find.text(expected), findsOneWidget);
    }
    await tester.tap(find.textContaining('Cramps'));
    await tester.pumpAndSettle();
    expect(await symptomsOf(db), isEmpty);
    await close(tester);
  });

  testWidgets('product count appears with bleeding and saves', (tester) async {
    await pumpSheet(tester);
    expect(find.text('Pads, tampons or cups used'), findsNothing);
    await tester.tap(find.text('Heavy'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More'));
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    expect((await logOf(db)).products, 2);
    await close(tester);
  });

  testWidgets('temperature in °F is stored in °C', (tester) async {
    await pumpSheet(tester);
    final field = find.widgetWithText(TextField, '97.70');
    await scrollTo(tester, field);
    await tester.enterText(field, '98.6');
    await tester.pumpAndSettle();
    expect((await logOf(db)).bbt, closeTo(37, 1e-9));
    await close(tester);
  });

  testWidgets('tests and energy save', (tester) async {
    await pumpSheet(tester);
    await scrollTo(tester, find.text('Low'));
    await tester.tap(find.text('Low'));
    await scrollTo(tester, find.text('Peak'));
    await tester.tap(find.text('Peak'));
    await tester.pumpAndSettle();
    final log = (await logOf(db));
    expect(log.lhTest, TestResult.peak);
    expect(log.energy, EnergyLevel.low);
    await close(tester);
  });

  testWidgets('new tag is created and logged on the day', (tester) async {
    await pumpSheet(tester);
    await scrollTo(tester, find.text('New tag'));
    await tester.tap(find.text('New tag'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Ran 5k');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    expect(await symptomsOf(db), {'custom.ran_5k': 1});
    expect(find.widgetWithText(FilterChip, 'Ran 5k'), findsOneWidget);
    await close(tester);
  });
}
