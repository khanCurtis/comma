import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where lock settings are kept. Abstracted so tests can use memory.
abstract class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecureSecretStore implements SecretStore {
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class MemorySecretStore implements SecretStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

enum PinCheck { correct, emergency, wrong }

/// PIN lock settings. PINs are stored only as salted PBKDF2 hashes, in the
/// platform keystore rather than the database, so backups never carry them.
class LockStore {
  LockStore(this._store, {this.iterations = 100000});

  final SecretStore _store;
  final int iterations;

  static const _pinKey = 'comma.lock.pin';
  static const _emergencyKey = 'comma.lock.emergency';
  static const _biometricsKey = 'comma.lock.biometrics';

  Future<bool> get enabled async => await _store.read(_pinKey) != null;

  Future<bool> get hasEmergencyPin async =>
      await _store.read(_emergencyKey) != null;

  Future<bool> get biometrics async =>
      await _store.read(_biometricsKey) == 'true';

  Future<void> setBiometrics(bool on) =>
      on ? _store.write(_biometricsKey, 'true') : _store.delete(_biometricsKey);

  Future<void> setPin(String pin) async =>
      _store.write(_pinKey, await _hash(pin));

  /// Throws [ArgumentError] if it matches the normal PIN.
  Future<void> setEmergencyPin(String pin) async {
    if (await _matches(_pinKey, pin)) {
      throw ArgumentError('The emergency PIN must differ from your PIN.');
    }
    await _store.write(_emergencyKey, await _hash(pin));
  }

  Future<void> clearEmergencyPin() => _store.delete(_emergencyKey);

  /// Turns the lock off entirely.
  Future<void> clear() async {
    await _store.delete(_pinKey);
    await _store.delete(_emergencyKey);
    await _store.delete(_biometricsKey);
  }

  Future<PinCheck> check(String pin) async {
    if (await _matches(_pinKey, pin)) return PinCheck.correct;
    if (await _matches(_emergencyKey, pin)) return PinCheck.emergency;
    return PinCheck.wrong;
  }

  Future<bool> _matches(String key, String pin) async {
    final stored = await _store.read(key);
    if (stored == null) return false;
    final [iter, salt, hash] = stored.split(':');
    final candidate = await _derive(pin, base64.decode(salt), int.parse(iter));
    return _constantTimeEquals(candidate, base64.decode(hash));
  }

  Future<String> _hash(String pin) async {
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final hash = await _derive(pin, salt, iterations);
    return '$iterations:${base64.encode(salt)}:${base64.encode(hash)}';
  }

  static Future<List<int>> _derive(String pin, List<int> salt, int iter) async {
    final key = await Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iter,
      bits: 256,
    ).deriveKeyFromPassword(password: pin, nonce: salt);
    return key.extractBytes();
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
