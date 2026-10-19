// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:comma/data/db/database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;
import 'generated/schema_v5.dart' as v5;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test(
    'v1 to v2 moves sex logs into entries and keeps everything else',
    () async {
      const jan1 = '2026-01-01T00:00:00.000Z';
      const jan2 = '2026-01-02T00:00:00.000Z';
      const jan3 = '2026-01-03T00:00:00.000Z';

      await verifier.testWithDataIntegrity(
        oldVersion: 1,
        newVersion: 2,
        createOld: v1.DatabaseAtV1.new,
        createNew: v2.DatabaseAtV2.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.dayLogs, [
            const v1.DayLogsData(
              date: jan1,
              flow: 'heavy',
              bbtDisturbed: 0,
              note: 'ouch',
            ),
            const v1.DayLogsData(
              date: jan2,
              flow: 'none',
              bbtDisturbed: 0,
              sex: 'protected',
            ),
            const v1.DayLogsData(
              date: jan3,
              flow: 'none',
              bbtDisturbed: 1,
              bbt: 36.6,
              sex: 'unprotected',
            ),
          ]);
          batch.insertAll(oldDb.symptomEntries, [
            const v1.SymptomEntriesData(
              date: jan1,
              symptom: 'cramps',
              severity: 2,
            ),
          ]);
          batch.insertAll(oldDb.settings, [
            const v1.SettingsData(key: 'onboarded', value: 'true'),
          ]);
        },
        validateItems: (newDb) async {
          expect(await newDb.select(newDb.dayLogs).get(), [
            const v2.DayLogsData(
              date: jan1,
              flow: 'heavy',
              bbtDisturbed: 0,
              note: 'ouch',
            ),
            const v2.DayLogsData(date: jan2, flow: 'none', bbtDisturbed: 0),
            const v2.DayLogsData(
              date: jan3,
              flow: 'none',
              bbtDisturbed: 1,
              bbt: 36.6,
            ),
          ]);
          expect(await newDb.select(newDb.sexEntries).get(), [
            const v2.SexEntriesData(
              id: 1,
              date: jan2,
              protection: 'otherProtection',
            ),
            const v2.SexEntriesData(
              id: 2,
              date: jan3,
              protection: 'unprotected',
            ),
          ]);
          expect(await newDb.select(newDb.symptomEntries).get(), [
            const v2.SymptomEntriesData(
              date: jan1,
              symptom: 'cramps',
              severity: 2,
            ),
          ]);
          expect(await newDb.select(newDb.settings).get(), [
            const v2.SettingsData(key: 'onboarded', value: 'true'),
          ]);
        },
      );
    },
  );

  test('v2 to v3 marks existing sex entries as partnered', () async {
    const jan2 = '2026-01-02T00:00:00.000Z';
    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.sexEntries, [
          const v2.SexEntriesData(
            id: 1,
            date: jan2,
            minuteOfDay: 600,
            protection: 'condom',
          ),
        ]);
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.sexEntries).get(), [
          const v3.SexEntriesData(
            id: 1,
            date: jan2,
            kind: 'partnered',
            minuteOfDay: 600,
            protection: 'condom',
          ),
        ]);
      },
    );
  });

  test('v3 to v4 keeps day logs and leaves new fields empty', () async {
    const jan1 = '2026-01-01T00:00:00.000Z';
    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.dayLogs, [
          const v3.DayLogsData(
            date: jan1,
            flow: 'medium',
            bbtDisturbed: 0,
            bbt: 36.4,
          ),
        ]);
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.dayLogs).get(), [
          const v4.DayLogsData(
            date: jan1,
            flow: 'medium',
            bbtDisturbed: 0,
            bbt: 36.4,
          ),
        ]);
        expect(await newDb.select(newDb.customTags).get(), isEmpty);
      },
    );
  });

  test('v4 to v5 adds empty medication tables', () async {
    const jan1 = '2026-01-01T00:00:00.000Z';
    await verifier.testWithDataIntegrity(
      oldVersion: 4,
      newVersion: 5,
      createOld: v4.DatabaseAtV4.new,
      createNew: v5.DatabaseAtV5.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.dayLogs, [
          const v4.DayLogsData(date: jan1, flow: 'light', bbtDisturbed: 0),
        ]);
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.dayLogs).get(), [
          const v5.DayLogsData(date: jan1, flow: 'light', bbtDisturbed: 0),
        ]);
        expect(await newDb.select(newDb.medications).get(), isEmpty);
      },
    );
  });
}
