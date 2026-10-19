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
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

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
    await tester.scrollUntilVisible(find.text('Next period'), 200);
    expect(find.text('Next period'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, 2000));
    await tester.pumpAndSettle();

    // Log sex twice on the same day; unprotected shows a help prompt.
    final logSex = find.widgetWithText(FilledButton, 'Log sex');
    await tester.scrollUntilVisible(logSex, 200);
    await tester.tap(logSex);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unprotected'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Learn more'), findsOneWidget);
    expect(find.textContaining('unprotected sex recently'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Log sex (1 today)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Condom'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Log sex (2 today)'), findsOneWidget);
    expect(await db.select(db.sexEntries).get(), hasLength(2));
    ScaffoldMessenger.of(tester.element(find.byType(NavigationBar)))
        .clearSnackBars();
    await tester.pumpAndSettle();

    // Learn tab, an article, and the help page.
    await tester.tap(find.text('Learn'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Easing period pain'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Sources'), 300);
    expect(find.text('Sources'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get help'));
    await tester.pumpAndSettle();
    expect(find.textContaining('emergency number'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    for (final tab in ['Calendar', 'Insights', 'Settings']) {
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
    }
    expect(find.text('Delete all data'), findsOneWidget);
    expect(find.text('Never backed up'), findsOneWidget);

    // Backup dialog validates the password before doing anything.
    await tester.tap(find.text('Back up data'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Backup password'),
      'abcdef',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Confirm password'),
      'abcdeg',
    );
    await tester.tap(find.text('Save backup'));
    await tester.pumpAndSettle();
    expect(find.text("Passwords don't match"), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Unmount so drift's stream subscriptions are cancelled before closing.
    await tester.pumpWidget(const SizedBox());
    await db.close();
  });
}
