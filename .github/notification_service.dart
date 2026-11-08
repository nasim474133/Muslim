import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Schedules a notification at each of the five prayer times.
/// Uses the default notification sound. A custom azan sound needs an audio
/// file in android/app/src/main/res/raw and a dedicated channel (see README).
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    // TODO: detect the device time zone (e.g. with the flutter_timezone package).
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));

    final impl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await impl?.requestNotificationsPermission();
    await impl?.requestExactAlarmsPermission();
  }

  static Future<void> schedulePrayers(PrayerTimes times) async {
    await _plugin.cancelAll();

    final items = <(int, String, DateTime)>[
      (1, 'ফজর', times.fajr),
      (2, 'যোহর', times.dhuhr),
      (3, 'আসর', times.asr),
      (4, 'মাগরিব', times.maghrib),
      (5, 'এশা', times.isha),
    ];

    for (final item in items) {
      if (item.$3.isBefore(DateTime.now())) continue;
      await _plugin.zonedSchedule(
        item.$1,
        'নামাজের সময়',
        '${item.$2} নামাজের ওয়াক্ত হয়েছে',
        tz.TZDateTime.from(item.$3, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel',
            'Prayer times',
            channelDescription: 'Prayer time alerts',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
