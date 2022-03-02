import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:swesshome/core/functions/store_notification.dart';

import 'local_notifications.dart';


Future initializeFirebase()async{
  await Firebase.initializeApp();
  // background messages initializing:
  FirebaseMessaging.onBackgroundMessage(backgroundFirebaseMessagesHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    badge: true,
    sound: true,
    alert: true,
  );
  // local notifications initializing:
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (_) {});
}


// On background messages:

Future<void> backgroundFirebaseMessagesHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null && message.notification!.body != null) {
    print(" On background firebase message");
    await storeNotification() ;
  }
}
