import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../app/providers.dart';
import 'lock_store.dart';

/// Fingerprint / face unlock, behind an interface so tests can fake it.
class Biometrics {
  final _auth = LocalAuthentication();

  Future<bool> get available async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock Comma',
        biometricOnly: true,
      );
    } catch (e) {
      debugPrint('Biometric unlock failed: $e');
      return false;
    }
  }
}

final secretStoreProvider = Provider<SecretStore>((_) => SecureSecretStore());
final lockStoreProvider = Provider(
  (ref) => LockStore(ref.watch(secretStoreProvider)),
);
final biometricsProvider = Provider((_) => Biometrics());

@immutable
class LockState {
  const LockState({
    this.loading = true,
    this.enabled = false,
    this.locked = true,
    this.biometrics = false,
    this.failures = 0,
    this.retryAt,
  });

  final bool loading;
  final bool enabled;
  final bool locked;
  final bool biometrics;
  final int failures;
  final DateTime? retryAt;

  bool get showLock => loading || (enabled && locked);

  LockState copyWith({
    bool? loading,
    bool? enabled,
    bool? locked,
    bool? biometrics,
    int? failures,
    DateTime? Function()? retryAt,
  }) => LockState(
    loading: loading ?? this.loading,
    enabled: enabled ?? this.enabled,
    locked: locked ?? this.locked,
    biometrics: biometrics ?? this.biometrics,
    failures: failures ?? this.failures,
    retryAt: retryAt == null ? this.retryAt : retryAt(),
  );
}

enum UnlockResult { unlocked, wrong, waiting }

class LockController extends Notifier<LockState> {
  static const maxAttempts = 5;
  static const lockout = Duration(seconds: 30);

  @override
  LockState build() {
    reload(lockNow: true);
    return const LockState();
  }

  LockStore get _store => ref.read(lockStoreProvider);

  /// Re-reads settings, e.g. after they change in Settings.
  Future<void> reload({bool lockNow = false}) async {
    bool enabled;
    bool biometrics;
    try {
      enabled = await _store.enabled;
      biometrics = enabled && await _store.biometrics;
    } catch (e) {
      // Without secure storage the lock can't work; the database key lives
      // there too, so the app would fail to open anyway.
      debugPrint('Reading lock settings failed: $e');
      enabled = false;
      biometrics = false;
    }
    state = state.copyWith(
      loading: false,
      enabled: enabled,
      biometrics: biometrics,
      locked: lockNow ? enabled : state.locked && enabled,
    );
  }

  void lock() {
    if (state.enabled) state = state.copyWith(locked: true);
  }

  Future<UnlockResult> unlockWithPin(String pin) async {
    final retryAt = state.retryAt;
    if (retryAt != null && DateTime.now().isBefore(retryAt)) {
      return UnlockResult.waiting;
    }
    switch (await _store.check(pin)) {
      case PinCheck.correct:
        _unlocked();
        return UnlockResult.unlocked;
      case PinCheck.emergency:
        await ref.read(panicWipeProvider)();
        _unlocked();
        return UnlockResult.unlocked;
      case PinCheck.wrong:
        final failures = state.failures + 1;
        state = failures >= maxAttempts
            ? state.copyWith(
                failures: 0,
                retryAt: () => DateTime.now().add(lockout),
              )
            : state.copyWith(failures: failures);
        return UnlockResult.wrong;
    }
  }

  Future<bool> unlockWithBiometrics() async {
    if (!state.biometrics) return false;
    final ok = await ref.read(biometricsProvider).authenticate();
    if (ok) _unlocked();
    return ok;
  }

  void _unlocked() =>
      state = state.copyWith(locked: false, failures: 0, retryAt: () => null);
}

final lockControllerProvider = NotifierProvider<LockController, LockState>(
  LockController.new,
);

/// Erases every trace of the user's data: logs, settings, lock and
/// scheduled reminders. Used by the emergency PIN.
final panicWipeProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    await ref.read(databaseProvider).wipe();
    await ref.read(lockStoreProvider).clear();
    await ref.read(notificationServiceProvider).apply(const []);
    await ref.read(lockControllerProvider.notifier).reload();
  },
);
