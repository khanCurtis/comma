import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lock_controller.dart';

/// Wraps the whole app: shows the lock screen while locked, locks again
/// after time in the background, and covers the app in the app switcher.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key, required this.child});
  final Widget child;

  /// Short trips out (file picker, share sheet) don't relock.
  static const grace = Duration(seconds: 30);

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate>
    with WidgetsBindingObserver {
  DateTime? _leftAt;
  var _covered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final enabled = ref.read(lockControllerProvider).enabled;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        if (enabled && !_covered) setState(() => _covered = true);
      case AppLifecycleState.paused:
        _leftAt ??= DateTime.now();
      case AppLifecycleState.resumed:
        final leftAt = _leftAt;
        _leftAt = null;
        if (leftAt != null &&
            DateTime.now().difference(leftAt) >= LockGate.grace) {
          ref.read(lockControllerProvider.notifier).lock();
        }
        if (_covered) setState(() => _covered = false);
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(lockControllerProvider);
    return Stack(
      children: [
        // Keep the app out of the accessibility tree while it's hidden.
        ExcludeSemantics(excluding: lock.showLock, child: widget.child),
        if (lock.loading)
          ColoredBox(color: Theme.of(context).colorScheme.surface)
        else if (lock.showLock)
          const LockScreen(),
        if (_covered && !lock.showLock) const _PrivacyCover(),
      ],
    );
  }
}

class _PrivacyCover extends StatelessWidget {
  const _PrivacyCover();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surface,
    child: Center(
      child: Icon(
        Icons.lock_outline,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  var _pin = '';
  String? _message;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    // Offer biometrics straight away when enabled.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ref.read(lockControllerProvider).biometrics) {
        ref.read(lockControllerProvider.notifier).unlockWithBiometrics();
      }
    });
  }

  Future<void> _submit() async {
    if (_pin.length < 4 || _busy) return;
    setState(() => _busy = true);
    final result = await ref
        .read(lockControllerProvider.notifier)
        .unlockWithPin(_pin);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _pin = '';
      _message = switch (result) {
        UnlockResult.unlocked => null,
        UnlockResult.wrong => 'Wrong PIN',
        UnlockResult.waiting => 'Too many tries. Wait 30 seconds.',
      };
    });
    if (result != UnlockResult.unlocked) HapticFeedback.heavyImpact();
  }

  void _press(String digit) {
    if (_pin.length >= 8 || _busy) return;
    setState(() {
      _pin += digit;
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final biometrics = ref.watch(lockControllerProvider).biometrics;

    Widget key(Widget child, VoidCallback? onTap, {String? label}) => Padding(
      padding: const EdgeInsets.all(6),
      child: Semantics(
        button: true,
        label: label,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 72, height: 72, child: Center(child: child)),
        ),
      ),
    );

    return Material(
      color: scheme.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 40, color: scheme.primary),
                const SizedBox(height: 12),
                Text('Enter your PIN', style: text.titleLarge),
                const SizedBox(height: 16),
                Semantics(
                  label: '${_pin.length} digits entered',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < 4 || i < _pin.length; i++)
                        Container(
                          margin: const EdgeInsets.all(6),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < _pin.length ? scheme.primary : null,
                            border: Border.all(color: scheme.primary, width: 2),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                  child: _message == null
                      ? null
                      : Text(_message!, style: TextStyle(color: scheme.error)),
                ),
                for (final row in const [
                  ['1', '2', '3'],
                  ['4', '5', '6'],
                  ['7', '8', '9'],
                ])
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final d in row)
                        key(
                          Text(d, style: text.headlineSmall),
                          () => _press(d),
                        ),
                    ],
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    key(
                      Icon(
                        biometrics
                            ? Icons.fingerprint
                            : Icons.backspace_outlined,
                      ),
                      biometrics
                          ? () => ref
                                .read(lockControllerProvider.notifier)
                                .unlockWithBiometrics()
                          : () => setState(
                              () => _pin = _pin.isEmpty
                                  ? ''
                                  : _pin.substring(0, _pin.length - 1),
                            ),
                      label: biometrics ? 'Use fingerprint or face' : 'Delete',
                    ),
                    key(
                      Text('0', style: text.headlineSmall),
                      () => _press('0'),
                    ),
                    key(
                      const Icon(Icons.arrow_forward),
                      _pin.length >= 4 ? _submit : null,
                      label: 'Unlock',
                    ),
                  ],
                ),
                if (biometrics)
                  TextButton(
                    onPressed: () => setState(
                      () => _pin = _pin.isEmpty
                          ? ''
                          : _pin.substring(0, _pin.length - 1),
                    ),
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
