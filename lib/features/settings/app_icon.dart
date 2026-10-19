import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Switches between the normal and discreet launcher icon (Android only).
class AppIconService {
  static const _channel = MethodChannel('comma/app_icon');

  bool get supported => !kIsWeb && Platform.isAndroid;

  Future<bool> isDiscreet() async {
    if (!supported) return false;
    try {
      return await _channel.invokeMethod<bool>('isDiscreet') ?? false;
    } on PlatformException catch (_) {
      return false;
    } on MissingPluginException catch (_) {
      return false;
    }
  }

  Future<void> setDiscreet(bool discreet) =>
      _channel.invokeMethod('setDiscreet', discreet);
}

final appIconServiceProvider = Provider((_) => AppIconService());

final discreetIconProvider = FutureProvider(
  (ref) => ref.watch(appIconServiceProvider).isDiscreet(),
);
