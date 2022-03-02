import 'package:swesshome/core/storage/shared_preferences/notifications_shared_preferences.dart';

Future storeNotification() async {
  // initialize shared preferences :
  await NotificationsSharedPreferences.init();
  await NotificationsSharedPreferences.reload();
  // update notifications count:
  int count =
  NotificationsSharedPreferences.getNotificationsCount();
  await NotificationsSharedPreferences.setNotificationsCount(count + 1);
  print("notification Data stored ");
}