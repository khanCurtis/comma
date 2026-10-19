import 'package:comma/app/app.dart';
import 'package:comma/app/providers.dart';
import 'package:comma/data/db/database.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:comma/features/lock/lock_controller.dart';
import 'package:comma/features/lock/lock_screen.dart';
import 'package:comma/features/lock/lock_store.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'medications_test.dart' show FakeNotifications;

class FakeBiometrics implements Biometrics {
  FakeBiometrics(this.result);
  final bool result;
  var prompts = 0;

  @override
  Future<bool> get available async => true;

  @override
  Future<bool> authenticate() async {
    prompts++;
    return result;
  }
}

void main() {
  late AppDatabase db;
  late MemorySecretStore secrets;
  late FakeNotifications notifications;

  setUp(() async {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    secrets = MemorySecretStore();
    notifications = FakeNotifications();
  });

  Future<void> pumpApp(WidgetTester tester, {Biometrics? biometrics}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          notificationServiceProvider.overrideWithValue(notifications),
          secretStoreProvider.overrideWithValue(secrets),
          lockStoreProvider.overrideWithValue(
            LockStore(secrets, iterations: 1000),
          ),
          if (biometrics != null)
            biometricsProvider.overrideWithValue(biometrics),
        ],
        child: const CommaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterPin(WidgetTester tester, String pin) async {
    for (final d in pin.split('')) {
      await tester.tap(
        find.descendant(of: find.byType(LockScreen), matching: find.text(d)),
      );
      await tester.pump();
    }
    await tester.tap(find.bySemanticsLabel('Unlock'));
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await db.close();
  }

  testWidgets('no lock: app opens straight away', (tester) async {
    await db.setSetting(SettingKeys.onboarded, 'true');
    await pumpApp(tester);
    expect(find.byType(LockScreen), findsNothing);
    expect(find.text('Log today'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('locked on launch; wrong PIN rejected, right PIN unlocks', (
    tester,
  ) async {
    await db.setSetting(SettingKeys.onboarded, 'true');
    await LockStore(secrets, iterations: 1000).setPin('2468');
    await pumpApp(tester);

    expect(find.byType(LockScreen), findsOneWidget);
    await enterPin(tester, '1111');
    expect(find.text('Wrong PIN'), findsOneWidget);
    expect(find.byType(LockScreen), findsOneWidget);

    await enterPin(tester, '2468');
    expect(find.byType(LockScreen), findsNothing);
    expect(find.text('Log today'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('five wrong tries pause unlocking', (tester) async {
    await db.setSetting(SettingKeys.onboarded, 'true');
    await LockStore(secrets, iterations: 1000).setPin('2468');
    await pumpApp(tester);
    for (var i = 0; i < 5; i++) {
      await enterPin(tester, '0000');
    }
    await enterPin(tester, '2468');
    expect(find.textContaining('Too many tries'), findsOneWidget);
    expect(find.byType(LockScreen), findsOneWidget);
    await finish(tester);
  });

  testWidgets('biometrics unlock automatically when enabled', (tester) async {
    await db.setSetting(SettingKeys.onboarded, 'true');
    final store = LockStore(secrets, iterations: 1000);
    await store.setPin('2468');
    await store.setBiometrics(true);
    final bio = FakeBiometrics(true);
    await pumpApp(tester, biometrics: bio);
    expect(bio.prompts, 1);
    expect(find.byType(LockScreen), findsNothing);
    await finish(tester);
  });

  testWidgets('emergency PIN wipes everything and opens a fresh app', (
    tester,
  ) async {
    await db.setSetting(SettingKeys.onboarded, 'true');
    await db.setFlow(DateTime.utc(2026, 1, 1), FlowLevel.heavy);
    final store = LockStore(secrets, iterations: 1000);
    await store.setPin('2468');
    await store.setEmergencyPin('1357');
    await pumpApp(tester);

    await enterPin(tester, '1357');
    expect(find.byType(LockScreen), findsNothing);
    expect(find.text('Welcome to Comma'), findsOneWidget);
    expect(await db.select(db.dayLogs).get(), isEmpty);
    expect(secrets.values, isEmpty);
    expect(notifications.applied.last, isEmpty);
    await finish(tester);
  });
}
