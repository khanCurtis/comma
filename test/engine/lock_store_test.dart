import 'package:comma/features/lock/lock_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MemorySecretStore secrets;
  late LockStore lock;

  setUp(() {
    secrets = MemorySecretStore();
    lock = LockStore(secrets, iterations: 1000);
  });

  test('off until a PIN is set', () async {
    expect(await lock.enabled, isFalse);
    await lock.setPin('1234');
    expect(await lock.enabled, isTrue);
  });

  test('checks PINs without storing them', () async {
    await lock.setPin('1234');
    expect(await lock.check('1234'), PinCheck.correct);
    expect(await lock.check('4321'), PinCheck.wrong);
    expect(secrets.values.values.join(), isNot(contains('1234')));
  });

  test('emergency PIN is recognised and must differ', () async {
    await lock.setPin('1234');
    await lock.setEmergencyPin('9999');
    expect(await lock.check('9999'), PinCheck.emergency);
    expect(() => lock.setEmergencyPin('1234'), throwsArgumentError);
  });

  test('same PIN hashes differently each time (salted)', () async {
    await lock.setPin('1234');
    final first = secrets.values['comma.lock.pin'];
    await lock.setPin('1234');
    expect(secrets.values['comma.lock.pin'], isNot(first));
  });

  test('clear removes everything', () async {
    await lock.setPin('1234');
    await lock.setEmergencyPin('0000');
    await lock.setBiometrics(true);
    await lock.clear();
    expect(secrets.values, isEmpty);
    expect(await lock.check('1234'), PinCheck.wrong);
  });
}
