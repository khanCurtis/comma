import 'dart:convert';

import 'package:comma/data/backup/backup.dart';
import 'package:comma/data/db/database.dart';
import 'package:comma/domain/models/day_log.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime d(int y, int m, int day) => DateTime.utc(y, m, day);

// Low cost keeps tests fast; real backups use the default.
const codec = BackupCodec(iterations: 1000);

Future<AppDatabase> seeded() async {
  final db = AppDatabase(NativeDatabase.memory());
  await db.setFlow(d(2026, 1, 1), FlowLevel.heavy);
  await db.saveDay(
    DayLogsCompanion(
      date: Value(d(2026, 1, 14)),
      mucus: const Value(Mucus.eggWhite),
      bbt: const Value(36.45),
      lhTest: const Value(TestResult.peak),
      note: const Value('Notes with "quotes" and émojis 🌙'),
    ),
  );
  await db.setSymptom(d(2026, 1, 1), 'cramps', 3);
  await db.saveSexEntry(
    SexEntriesCompanion.insert(
      date: d(2026, 1, 14),
      minuteOfDay: const Value(22 * 60 + 30),
      protection: const Value(SexProtection.condom),
      orgasm: const Value(true),
    ),
  );
  await db.saveSexEntry(SexEntriesCompanion.insert(date: d(2026, 1, 14)));
  await db.saveSexEntry(
    SexEntriesCompanion.insert(
      date: d(2026, 1, 15),
      kind: const Value(SexKind.solo),
    ),
  );
  final pill = await db.saveMedication(
    MedicationsCompanion.insert(
      name: 'Pill',
      startDate: d(2026, 1, 1),
      isContraceptive: const Value(true),
      activeDays: const Value(21),
      breakDays: const Value(7),
      reminderMinute: const Value(21 * 60),
    ),
  );
  await db.setMedicationTaken(d(2026, 1, 2), pill, true);
  await db.setSetting('onboarded', 'true');
  return db;
}

void main() {
  test('round trip restores every field', () async {
    final source = await seeded();
    final target = AppDatabase(NativeDatabase.memory());
    addTearDown(source.close);
    addTearDown(target.close);
    await target.setFlow(d(2020, 1, 1), FlowLevel.light); // replaced on import

    final bytes = await codec.encode(
      await exportBackup(source),
      password: 'hunter2',
    );
    final restored = await importBackup(
      target,
      await codec.decode(bytes, password: 'hunter2'),
    );

    expect(restored, 2);
    expect(
      await target.select(target.dayLogs).get(),
      await source.select(source.dayLogs).get(),
    );
    expect(await target.watchSymptoms(d(2026, 1, 1)).first, {'cramps': 3});
    expect(
      await target.select(target.sexEntries).get(),
      await source.select(source.sexEntries).get(),
    );
    expect(await target.watchSetting('onboarded').first, 'true');
  });

  test('encrypted backups do not contain readable data', () async {
    final db = await seeded();
    addTearDown(db.close);
    final bytes = await codec.encode(await exportBackup(db), password: 'pw');
    final text = utf8.decode(bytes);
    expect(text, isNot(contains('cramps')));
    expect(text, isNot(contains('2026-01-01')));
    expect(BackupCodec.isEncrypted(bytes), isTrue);
  });

  test('wrong or missing password is rejected', () async {
    final db = await seeded();
    addTearDown(db.close);
    final bytes = await codec.encode(await exportBackup(db), password: 'pw');
    expect(
      () => codec.decode(bytes),
      throwsA(isA<PasswordRequiredException>()),
    );
    expect(
      () => codec.decode(bytes, password: 'nope'),
      throwsA(isA<WrongPasswordException>()),
    );
  });

  test('tampered encrypted data is rejected', () async {
    final db = await seeded();
    addTearDown(db.close);
    final bytes = await codec.encode(await exportBackup(db), password: 'pw');
    final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    final data = base64.decode(json['data'] as String);
    data[0] ^= 1;
    json['data'] = base64.encode(data);
    expect(
      () => codec.decode(utf8.encode(jsonEncode(json)), password: 'pw'),
      throwsA(isA<WrongPasswordException>()),
    );
  });

  test('unencrypted backups are readable JSON', () async {
    final db = await seeded();
    addTearDown(db.close);
    final bytes = await codec.encode(await exportBackup(db));
    expect(BackupCodec.isEncrypted(bytes), isFalse);
    final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    expect(json['dayLogs'], contains(containsPair('flow', 'heavy')));
  });

  test('version 1 backups convert day-level sex to entries', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await importBackup(db, {
      'format': 'comma-backup',
      'version': 1,
      'dayLogs': [
        {'date': '2026-01-01', 'flow': 'none', 'sex': 'unprotected'},
        {'date': '2026-01-02', 'flow': 'light', 'sex': 'protected'},
        {'date': '2026-01-03', 'flow': 'light', 'sex': 'none'},
      ],
      'symptomEntries': [],
      'settings': {},
    });
    final entries = await db.select(db.sexEntries).get();
    expect(entries.map((e) => (e.date, e.protection)), [
      (d(2026, 1, 1), SexProtection.unprotected),
      (d(2026, 1, 2), SexProtection.otherProtection),
    ]);
  });

  test('version 2 sex entries import as partnered', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await importBackup(db, {
      'format': 'comma-backup',
      'version': 2,
      'dayLogs': [],
      'symptomEntries': [],
      'sexEntries': [
        {'date': '2026-01-01', 'protection': 'condom'},
      ],
      'settings': {},
    });
    final entry = (await db.select(db.sexEntries).get()).single;
    expect(entry.kind, SexKind.partnered);
    expect(entry.protection, SexProtection.condom);
  });

  test('garbage and newer versions are rejected', () async {
    expect(
      () => codec.decode(utf8.encode('not json')),
      throwsA(isA<BackupException>()),
    );
    expect(
      () => codec.decode(
        utf8.encode(jsonEncode({'format': 'comma-backup', 'version': 99})),
      ),
      throwsA(isA<BackupException>()),
    );
  });

  test('an invalid backup leaves existing data untouched', () async {
    final db = await seeded();
    addTearDown(db.close);
    final bad = {
      'format': 'comma-backup',
      'version': 2,
      'sexEntries': [],
      'dayLogs': [
        {'date': '2026-02-01', 'flow': 'torrential'},
      ],
      'symptomEntries': [],
      'settings': {},
    };
    await expectLater(importBackup(db, bad), throwsA(isA<BackupException>()));
    expect(await db.watchBleedingDays().first, [d(2026, 1, 1)]);
  });
}
