import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _keyName = 'comma.db_key';

/// Opens the app database, encrypted with a random key kept in the Android
/// Keystore / iOS Keychain. The key never leaves the device.
QueryExecutor openAppDatabase() => LazyDatabase(() async {
  final dir = await getApplicationSupportDirectory();
  final file = File(p.join(dir.path, 'comma.db'));
  return openEncryptedDatabase(file, await _loadOrCreateKey());
});

/// Opens [file] with SQLite3 Multiple Ciphers using [key].
/// [key] must not contain single quotes.
QueryExecutor openEncryptedDatabase(File file, String key) =>
    NativeDatabase.createInBackground(
      file,
      setup: (db) {
        db.execute("PRAGMA key = '$key';");
        // Fails here, rather than on first use, if the key is wrong.
        db.select('SELECT count(*) FROM sqlite_master;');
      },
    );

Future<String> _loadOrCreateKey() async {
  const storage = FlutterSecureStorage();
  final existing = await storage.read(key: _keyName);
  if (existing != null) return existing;

  final random = Random.secure();
  final bytes = List<int>.generate(32, (_) => random.nextInt(256));
  final key = base64Url.encode(bytes).replaceAll('=', '');
  await storage.write(key: _keyName, value: key);
  return key;
}
