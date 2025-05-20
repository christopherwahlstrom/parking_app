import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class NotificationRepository {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    // Init timezones
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Android: använd anpassad ikon och (om du vill) ljud
    var androidSettings = const AndroidInitializationSettings('@drawable/ic_notification'); // Anpassad ikon!
    var initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final impl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await impl?.requestNotificationsPermission();
    }
  }

  /// VG: Anpassad text och ikon
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime deliveryTime,
    required int id,
  }) async {
    await requestPermissions();

    var androidDetails = AndroidNotificationDetails(
      const Uuid().v4(),
      'parking_reminders', // kanalnamn
      channelDescription: 'Påminnelser om parkering i Parking4U',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_notification', 
    );
    var details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(deliveryTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
