import 'dart:io';

import 'package:comma/data/db/connection.dart';
import 'package:comma/data/db/database.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

DateTime d(int y, int m, int day) => DateTime.utc(y, m, day);

void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('comma_test');
    file = File('${dir.path}/test.db');
  });
  tearDown(() => dir.deleteSync(recursive: true));

  group('encryption', () {
    test('file contents are not readable plain SQLite', () async {
      final db = AppDatabase(openEncryptedDatabase(file, 'secret-key'));
      await db.setSetting('canary', 'very-private-value');
      await db.close();

      final bytes = file.readAsBytesSync();
      final header = String.fromCharCodes(bytes.take(15));
      expect(header, isNot('SQLite format 3'));
      expect(
        String.fromCharCodes(bytes),
        isNot(contains('very-private-value')),
      );
    });

    test('reopens with the right key and refuses the wrong one', () async {
      var db = AppDatabase(openEncryptedDatabase(file, 'secret-key'));
      await db.setSetting('canary', 'ok');
      await db.close();

      db = AppDatabase(openEncryptedDatabase(file, 'secret-key'));
      expect(await db.watchSetting('canary').first, 'ok');
      await db.close();

      db = AppDatabase(openEncryptedDatabase(file, 'wrong-key'));
      await expectLater(db.watchSetting('canary').first, throwsA(anything));
      await db.close();
    });
  });

  group('queries', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(openEncryptedDatabase(file, 'k')));
    tearDown(() => db.close());

    test('bleeding days exclude spotting and none', () async {
      await db.setFlow(d(2026, 1, 1), FlowLevel.heavy);
      await db.setFlow(d(2026, 1, 2), FlowLevel.light);
      await db.setFlow(d(2026, 1, 3), FlowLevel.spotting);
      await db.setFlow(d(2026, 1, 4), FlowLevel.none);
      expect(await db.watchBleedingDays().first, [
        d(2026, 1, 1),
        d(2026, 1, 2),
      ]);
    });

    test('saving a day only changes the given columns', () async {
      await db.setFlow(d(2026, 1, 1), FlowLevel.medium);
      await db.saveDay(
        DayLogsCompanion(
          date: Value(d(2026, 1, 1)),
          note: const Value('tired'),
        ),
      );
      final day = await db.watchDay(d(2026, 1, 1)).first;
      expect(day!.flow, FlowLevel.medium);
      expect(day.note, 'tired');
    });

    test('local times are stored as the calendar day', () async {
      await db.setFlow(DateTime(2026, 1, 1, 23, 30), FlowLevel.light);
      expect(await db.watchBleedingDays().first, [d(2026, 1, 1)]);
    });

    test('symptoms can be set, updated and removed', () async {
      await db.setSymptom(d(2026, 1, 1), 'cramps', 2);
      await db.setSymptom(d(2026, 1, 1), 'headache', 1);
      await db.setSymptom(d(2026, 1, 1), 'cramps', 3);
      expect(await db.watchSymptoms(d(2026, 1, 1)).first, {
        'cramps': 3,
        'headache': 1,
      });
      await db.setSymptom(d(2026, 1, 1), 'headache', 0);
      expect(await db.watchSymptoms(d(2026, 1, 1)).first, {'cramps': 3});
    });

    test('wipe removes everything', () async {
      await db.setFlow(d(2026, 1, 1), FlowLevel.heavy);
      await db.setSetting('a', 'b');
      await db.wipe();
      expect(await db.watchBleedingDays().first, isEmpty);
      expect(await db.watchSetting('a').first, isNull);
    });
  });
}
