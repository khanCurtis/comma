import 'package:comma/app/app.dart';
import 'package:comma/app/providers.dart';
import 'package:comma/data/db/database.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding leads to the Today screen and logging works', (
    tester,
  ) async {
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(),
        closeStreamsSynchronously: true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const CommaApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Comma'), findsOneWidget);
    final start = find.text('Get started');
    await tester.scrollUntilVisible(start, 200);
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(start);
    await tester.pumpAndSettle();

    expect(find.text('Log your period to see predictions'), findsOneWidget);

    await tester.tap(find.text('Period started'));
    await tester.pumpAndSettle();
    expect(find.text('Flow'), findsOneWidget); // log sheet opened
    await tester.tapAt(const Offset(10, 10)); // dismiss sheet
    await tester.pumpAndSettle();

    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Next period'), findsOneWidget);

    for (final tab in ['Calendar', 'Insights', 'Settings']) {
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
    }
    expect(find.text('Delete all data'), findsOneWidget);

    // Unmount so drift's stream subscriptions are cancelled before closing.
    await tester.pumpWidget(const SizedBox());
    await db.close();
  });
}
