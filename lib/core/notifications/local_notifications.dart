import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Flutter local notifications plugin //

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Initializing settings //
//android:
const AndroidInitializationSettings initializationSettingsAndroid =
AndroidInitializationSettings('@mipmap/ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {
          
          });
//initializing:
InitializationSettings initializationSettings =  InitializationSettings(
  android: initializationSettingsAndroid,iOS: initializationSettingsIOS);

// Android Notifications Channel //
const AndroidNotificationChannel androidNotificationsChannel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: "This Channel is used for importance notifications",
    importance: Importance.high,
    playSound: true);
