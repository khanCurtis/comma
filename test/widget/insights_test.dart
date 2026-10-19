import 'package:comma/app/providers.dart';
import 'package:comma/data/db/database.dart';
import 'package:comma/domain/dates.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:comma/domain/units.dart';
import 'package:comma/features/insights/charts.dart';
import 'package:comma/features/insights/insights_screen.dart';
import 'package:comma/features/reports/reports_screen.dart';
import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('insights shows charts, patterns and confirmed ovulation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    // Three complete cycles plus the current one; cramps on period days.
    final today = dateOnly(DateTime.now());
    final starts = [
      for (final back in [86, 58, 30, 2]) addDays(today, -back),
    ];
    for (final s in starts) {
      for (var i = 0; i < 4; i++) {
        await db.setFlow(addDays(s, i), FlowLevel.medium);
        if (s != starts.last) await db.setSymptom(addDays(s, i), 'cramps', 2);
      }
    }
    // Temperatures in the previous cycle with a shift after day 14.
    final prev = starts[2];
    for (var i = 0; i < 26; i++) {
      await db.saveDay(
        DayLogsCompanion(
          date: Value(addDays(prev, i)),
          bbt: Value(i < 14 ? 36.4 : 36.8),
        ),
      );
    }
    // A few readings in the current cycle so the chart shows.
    for (var i = 0; i < 3; i++) {
      await db.saveDay(
        DayLogsCompanion(
          date: Value(addDays(starts.last, i)),
          bbt: Value(36.3 + i / 10),
        ),
      );
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tempUnitProvider.overrideWithValue(TempUnit.celsius),
        ],
        child: const MaterialApp(home: Scaffold(body: InsightsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Your cycles have all been 28 days'),
      findsOneWidget,
    );
    expect(find.byType(CycleLengthChart), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(TemperatureChart), 300);
    expect(find.byType(TemperatureChart), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Symptom patterns'), 300);
    await tester.scrollUntilVisible(find.text('Cramps'), 200);
    expect(
      find.textContaining('Mostly during your period (12 of 12 days)'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(find.textContaining('(temperature)'), 300);
    expect(find.textContaining('(temperature)'), findsOneWidget);

    // The doctor report screen opens from Insights.
    await tester.scrollUntilVisible(find.text('Doctor report'), -500);
    await tester.tap(find.text('Doctor report'));
    await tester.pumpAndSettle();
    expect(find.text('Report for your doctor'), findsOneWidget);
    expect(find.text('Share PDF'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Share CSV files'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ReportsScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    await tester.pumpWidget(const SizedBox());
    await db.close();
  });
}
