import 'package:comma/app/app.dart';
import 'package:comma/app/providers.dart';
import 'package:comma/data/db/database.dart';
import 'package:comma/domain/dates.dart';
import 'package:comma/domain/reminders.dart';
import 'package:comma/features/log/day_log_sheet.dart';
import 'package:comma/features/medications/medications_screen.dart';
import 'package:comma/features/reminders/notification_service.dart';
import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotifications implements NotificationService {
  final applied = <List<PlannedNotification>>[];
  var permissionRequests = 0;

  @override
  Future<void> apply(List<PlannedNotification> plan) async => applied.add(plan);

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return true;
  }
}

void main() {
  late AppDatabase db;
  late FakeNotifications notifications;

  Widget app(Widget home) => ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      notificationServiceProvider.overrideWithValue(notifications),
    ],
    child: MaterialApp(home: home),
  );

  setUp(() {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    notifications = FakeNotifications();
  });

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await db.close();
  }

  testWidgets('add a pill pack with a reminder and tick it off', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(const MedicationsScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Pill');
    await tester.tap(find.text('This is birth control'));
    await tester.tap(find.text('21 + 7 break'));
    await tester.tap(find.text('Daily reminder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // time picker
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final med = (await db.select(db.medications).get()).single;
    expect(
      (med.name, med.isContraceptive, med.activeDays, med.breakDays),
      ('Pill', true, 21, 7),
    );
    expect(med.reminderMinute, 21 * 60);
    expect(notifications.permissionRequests, 1);
    expect(find.text('Pill'), findsOneWidget);

    final today = dateOnly(DateTime.now());
    await tester.pumpWidget(app(Scaffold(body: DayLogSheet(day: today))));
    await tester.pumpAndSettle();
    final pillRow = find.text('Pill 1 of 21');
    await tester.scrollUntilVisible(
      pillRow,
      300,
      scrollable: find
          .descendant(
            of: find.byType(DayLogSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.ensureVisible(pillRow);
    await tester.pumpAndSettle();
    await tester.tap(pillRow);
    await tester.pumpAndSettle();
    expect(
      (await db.select(db.medicationLogs).get()).single.medicationId,
      med.id,
    );
    await finish(tester);
  });

  testWidgets('the app schedules planned reminders', (tester) async {
    await db.setSetting(SettingKeys.onboarded, 'true');
    await db.setSetting(SettingKeys.dailyLogReminderMinute, '${23 * 60 + 59}');
    await db.saveMedication(
      MedicationsCompanion.insert(
        name: 'Iron',
        startDate: DateTime.utc(2020),
        reminderMinute: const Value(23 * 60 + 59),
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          notificationServiceProvider.overrideWithValue(notifications),
        ],
        child: const CommaApp(),
      ),
    );
    await tester.pumpAndSettle();

    final plan = notifications.applied.last;
    expect(plan.where((n) => n.id >= 100000), isNotEmpty); // Iron
    expect(plan.where((n) => n.id >= 1000 && n.id < 2000), isNotEmpty);
    expect(plan.every((n) => n.body == 'You have a reminder'), isTrue);
    await finish(tester);
  });
}
