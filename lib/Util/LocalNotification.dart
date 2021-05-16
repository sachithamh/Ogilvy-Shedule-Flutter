import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class LocalNotification extends ChangeNotifier {
  static LocalNotification sheard = LocalNotification();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotification() {
    initialize();
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  Future initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("ic_launcher");
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  showNotification(String title,String description) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, title, description, platform,
        payload: '');
  }

  Future sheduledNotification(int notificationId, DateTime datetime,
      String title, String description) async {
    final now = DateTime.now();    
    var difference =  datetime.difference(now).inSeconds; 
    print("time:${difference}");
    if (difference<= 0){
      return;
    }   
    await cancelNotification(notificationId);

    var android = AndroidNotificationDetails("id", "channel", "description");

    var platform = new NotificationDetails(android: android);

    await configureLocalTimeZone();

    var androidAllowWhileIdle = true;
    
    
    
    var timeing = tz.TZDateTime.now(tz.local).add(Duration(seconds: difference));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, title, description, timeing, platform,
        androidAllowWhileIdle: androidAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  // zonedSchedule(
  //   int id,
  //   String? title,
  //   String? body,
  //   TZDateTime scheduledDate,
  //   NotificationDetails notificationDetails, {
  //   required UILocalNotificationDateInterpretation
  //       uiLocalNotificationDateInterpretation,
  //   required bool androidAllowWhileIdle,
  //   String? payload,
  //   DateTimeComponents? matchDateTimeComponents,
  // })

  Future<void> cancelNotification(
    int notificationId,
  ) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
