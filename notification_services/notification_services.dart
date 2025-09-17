
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../model_view/reminder_screen_provider.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //Initialize Firebase Messaging
  Future<void> initialize() async {

    //Initialize local notifications
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/launcher_icon");

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await _localNotificationsPlugin.initialize(
        initializationSettings,
      onDidReceiveNotificationResponse: notificationCallback,
      onDidReceiveBackgroundNotificationResponse:notificationCallback

    );
    initializeTimeZones();

  }

  static scheduledNotification(String title, String body, Duration duration, int id) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'sleep_soundscape_channel', // Channel ID
        'Sleep SoundScape', // Channel Name
        importance: Importance.max,
        priority: Priority.high,
        icon: "@mipmap/launcher_icon",
      playSound: true,
      ongoing: true ,///keep the notification visible until user interacts
      autoCancel: false, ///prevent auto-dismiss
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
            'STOP_ALARM', ///Unique id for stop action
            'STOP ALARM', ///button label
          showsUserInterface: true,
          cancelNotification: true, /// Dismiss notification when pressed
        ),
        AndroidNotificationAction(
          'SNOOZE_ALARM',
          'SNOOZE ALARM',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ]



    );

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
    NotificationDetails(android: androidNotificationDetails,iOS: iosDetails);

    await _localNotificationsPlugin.zonedSchedule(
      id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(duration),
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,

    );



  }

}