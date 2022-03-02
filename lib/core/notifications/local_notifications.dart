import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Flutter local notifications plugin //

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Initializing settings //
//android:
const AndroidInitializationSettings initializationSettingsAndroid =
AndroidInitializationSettings('@mipmap/ic_launcher');
//initializing:
InitializationSettings initializationSettings = const InitializationSettings(
  android: initializationSettingsAndroid,);

// Android Notifications Channel //
const AndroidNotificationChannel androidNotificationsChannel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: "This Channel is used for importance notifications",
    importance: Importance.high,
    playSound: true);
