import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import '../../domain/models/day_log.dart';
import '../db/database.dart';

/// Backup files are JSON. Unencrypted:
///
///     {"format": "comma-backup", "version": 1, "exportedAt": "...",
///      "dayLogs": [...], "symptomEntries": [...], "sexEntries": [...],
///      "settings": {...}}
///
/// Encrypted, the same JSON is sealed with AES-256-GCM using a key derived
/// from the user's password with PBKDF2-HMAC-SHA256:
///
///     {"format": "comma-backup-encrypted", "version": 1,
///      "kdf": {"algorithm": "pbkdf2-hmac-sha256", "iterations": N, "salt": b64},
///      "cipher": {"algorithm": "aes-256-gcm", "nonce": b64},
///      "data": b64(ciphertext + 16-byte tag)}
///
/// The format is documented so data can always be recovered without the app.
const _plainFormat = 'comma-backup';
const _encryptedFormat = 'comma-backup-encrypted';
const _version = 3;
const _maxIterations = 10000000;

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

class PasswordRequiredException extends BackupException {
  const PasswordRequiredException()
    : super('This backup is encrypted. Enter its password.');
}

class WrongPasswordException extends BackupException {
  const WrongPasswordException()
    : super('Wrong password, or the file is damaged.');
}

class BackupCodec {
  /// [iterations] is the PBKDF2 cost for new backups (OWASP 2023 guidance).
  /// Decoding always uses the count stored in the file.
  const BackupCodec({this.iterations = 600000});

  final int iterations;

  static final _cipher = AesGcm.with256bits();

  static bool isEncrypted(Uint8List bytes) =>
      _decodeJson(bytes)['format'] == _encryptedFormat;

  Future<Uint8List> encode(
    Map<String, Object?> backup, {
    String? password,
  }) async {
    final plain = utf8.encode(jsonEncode(backup));
    if (password == null) return plain;

    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final key = await _deriveKey(password, salt, iterations);
    final box = await _cipher.encrypt(plain, secretKey: key);
    return utf8.encode(
      jsonEncode({
        'format': _encryptedFormat,
        'version': _version,
        'kdf': {
          'algorithm': 'pbkdf2-hmac-sha256',
          'iterations': iterations,
          'salt': base64.encode(salt),
        },
        'cipher': {
          'algorithm': 'aes-256-gcm',
          'nonce': base64.encode(box.nonce),
        },
        'data': base64.encode([...box.cipherText, ...box.mac.bytes]),
      }),
    );
  }

  Future<Map<String, Object?>> decode(
    Uint8List bytes, {
    String? password,
  }) async {
    final outer = _decodeJson(bytes);
    if (outer['format'] == _plainFormat) return _checkVersion(outer);
    if (outer['format'] != _encryptedFormat) {
      throw const BackupException('This is not a Comma backup file.');
    }
    _checkVersion(outer);
    if (password == null) throw const PasswordRequiredException();

    try {
      final kdf = outer['kdf'] as Map<String, Object?>;
      final cipher = outer['cipher'] as Map<String, Object?>;
      final iterations = kdf['iterations'] as int;
      if (kdf['algorithm'] != 'pbkdf2-hmac-sha256' ||
          cipher['algorithm'] != 'aes-256-gcm' ||
          iterations < 1 ||
          iterations > _maxIterations) {
        throw const BackupException('Unsupported backup encryption.');
      }
      final salt = base64.decode(kdf['salt'] as String);
      final data = base64.decode(outer['data'] as String);
      final key = await _deriveKey(password, salt, iterations);
      final plain = await _cipher.decrypt(
        SecretBox(
          data.sublist(0, data.length - 16),
          nonce: base64.decode(cipher['nonce'] as String),
          mac: Mac(data.sublist(data.length - 16)),
        ),
        secretKey: key,
      );
      return _checkVersion(_decodeJson(Uint8List.fromList(plain)));
    } on SecretBoxAuthenticationError {
      throw const WrongPasswordException();
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupException('The backup file is damaged.');
    }
  }

  static Future<SecretKey> _deriveKey(
    String password,
    List<int> salt,
    int iterations,
  ) => Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  ).deriveKeyFromPassword(password: password, nonce: salt);

  static Map<String, Object?> _decodeJson(Uint8List bytes) {
    try {
      return jsonDecode(utf8.decode(bytes)) as Map<String, Object?>;
    } catch (_) {
      throw const BackupException('This is not a Comma backup file.');
    }
  }

  static Map<String, Object?> _checkVersion(Map<String, Object?> json) {
    final version = json['version'];
    if (version is! int || version > _version) {
      throw const BackupException(
        'This backup was made by a newer version of Comma. Update the app '
        'and try again.',
      );
    }
    return json;
  }
}

String _day(DateTime d) => d.toIso8601String().substring(0, 10);

/// Collects every row in [db] into an unencrypted backup map.
Future<Map<String, Object?>> exportBackup(AppDatabase db) async {
  final logs = await db.select(db.dayLogs).get();
  final symptoms = await db.select(db.symptomEntries).get();
  final sex = await db.select(db.sexEntries).get();
  final settings = await db.select(db.settings).get();
  return {
    'format': _plainFormat,
    'version': _version,
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'dayLogs': [
      for (final l in logs)
        {
          'date': _day(l.date),
          'flow': l.flow.name,
          if (l.mucus != null) 'mucus': l.mucus!.name,
          if (l.bbt != null) 'bbt': l.bbt,
          if (l.bbtDisturbed) 'bbtDisturbed': true,
          if (l.lhTest != null) 'lhTest': l.lhTest!.name,
          if (l.pregnancyTest != null) 'pregnancyTest': l.pregnancyTest!.name,
          if (l.note != null) 'note': l.note,
        },
    ],
    'symptomEntries': [
      for (final s in symptoms)
        {'date': _day(s.date), 'symptom': s.symptom, 'severity': s.severity},
    ],
    'sexEntries': [
      for (final e in sex)
        {
          'date': _day(e.date),
          'kind': e.kind.name,
          if (e.minuteOfDay != null) 'minuteOfDay': e.minuteOfDay,
          if (e.protection != null) 'protection': e.protection!.name,
          if (e.orgasm != null) 'orgasm': e.orgasm,
          if (e.note != null) 'note': e.note,
        },
    ],
    'settings': {for (final s in settings) s.key: s.value},
  };
}

/// Replaces everything in [db] with [backup]. The whole backup is validated
/// before anything is deleted, so a bad file never leaves the app empty.
/// Returns the number of days restored.
Future<int> importBackup(AppDatabase db, Map<String, Object?> backup) async {
  final List<DayLogsCompanion> logs;
  final List<SymptomEntriesCompanion> symptoms;
  final List<SexEntriesCompanion> sex;
  final List<SettingsCompanion> settings;
  try {
    final rawLogs = (backup['dayLogs'] as List).cast<Map<String, Object?>>();
    logs = [for (final raw in rawLogs) _parseDayLog(raw)];
    symptoms = [
      for (final raw in backup['symptomEntries'] as List)
        SymptomEntriesCompanion.insert(
          date: _parseDay((raw as Map)['date']),
          symptom: raw['symptom'] as String,
          severity: Value(raw['severity'] as int),
        ),
    ];
    sex = backup['version'] == 1
        // Version 1 stored at most one "sex" value per day log.
        ? [
            for (final raw in rawLogs)
              if (raw['sex'] case 'protected' || 'unprotected')
                SexEntriesCompanion.insert(
                  date: _parseDay(raw['date']),
                  protection: Value(
                    raw['sex'] == 'unprotected'
                        ? SexProtection.unprotected
                        : SexProtection.otherProtection,
                  ),
                ),
          ]
        : [
            for (final raw in backup['sexEntries'] as List)
              SexEntriesCompanion.insert(
                date: _parseDay((raw as Map)['date']),
                // Version 2 had no kind; everything was partnered.
                kind: Value(
                  _enum(SexKind.values, raw['kind']) ?? SexKind.partnered,
                ),
                minuteOfDay: Value(raw['minuteOfDay'] as int?),
                protection: Value(
                  _enum(SexProtection.values, raw['protection']),
                ),
                orgasm: Value(raw['orgasm'] as bool?),
                note: Value(raw['note'] as String?),
              ),
          ];
    settings = [
      for (final e in (backup['settings'] as Map).entries)
        SettingsCompanion.insert(
          key: e.key as String,
          value: e.value as String,
        ),
    ];
  } catch (_) {
    throw const BackupException('The backup file is damaged.');
  }

  await db.transaction(() async {
    await db.wipe();
    await db.batch((b) {
      b.insertAll(db.dayLogs, logs);
      b.insertAll(db.symptomEntries, symptoms);
      b.insertAll(db.sexEntries, sex);
      b.insertAll(db.settings, settings);
    });
  });
  return logs.length;
}

DateTime _parseDay(Object? value) {
  final d = DateTime.parse(value as String);
  return DateTime.utc(d.year, d.month, d.day);
}

T? _enum<T extends Enum>(List<T> values, Object? name) =>
    name == null ? null : values.byName(name as String);

DayLogsCompanion _parseDayLog(Map<String, Object?> raw) => DayLogsCompanion(
  date: Value(_parseDay(raw['date'])),
  flow: Value(_enum(FlowLevel.values, raw['flow']) ?? FlowLevel.none),
  mucus: Value(_enum(Mucus.values, raw['mucus'])),
  bbt: Value((raw['bbt'] as num?)?.toDouble()),
  bbtDisturbed: Value(raw['bbtDisturbed'] as bool? ?? false),
  lhTest: Value(_enum(TestResult.values, raw['lhTest'])),
  pregnancyTest: Value(_enum(TestResult.values, raw['pregnancyTest'])),
  note: Value(raw['note'] as String?),
);
