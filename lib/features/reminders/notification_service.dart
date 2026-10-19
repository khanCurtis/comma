import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/reminders.dart';

/// Schedules reminders with the OS. Everything stays on the device.
class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;

  Future<void> _init() => _ready ??= () async {
    tzdata.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }();

  /// Asks the user for permission to show notifications.
  Future<bool> requestPermission() async {
    try {
      await _init();
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ??
          await ios?.requestPermissions(alert: true, sound: true) ??
          false;
    } catch (e) {
      debugPrint('Notification permission failed: $e');
      return false;
    }
  }

  /// Replaces every scheduled reminder with [plan].
  Future<void> apply(List<PlannedNotification> plan) async {
    try {
      await _init();
      await _plugin.cancelAll();
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          'Reminders',
          channelDescription: 'Period, medication and logging reminders',
          importance: Importance.high,
          priority: Priority.high,
          // Hide content on the lock screen; the app's discreet setting
          // controls the wording itself.
          visibility: NotificationVisibility.private,
        ),
        iOS: DarwinNotificationDetails(),
      );
      for (final n in plan) {
        await _plugin.zonedSchedule(
          id: n.id,
          scheduledDate: tz.TZDateTime(
            tz.local,
            n.when.year,
            n.when.month,
            n.when.day,
            n.when.hour,
            n.when.minute,
          ),
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          title: n.title,
          body: n.body,
        );
      }
    } catch (e) {
      debugPrint('Scheduling reminders failed: $e');
    }
  }
}
