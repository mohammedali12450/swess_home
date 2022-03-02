import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'application_shared_preferences.dart';
import 'notifications_shared_preferences.dart';
import 'recent_searches_shared_preferences.dart';

Future initializeSharedPreferences() async {
  await UserSharedPreferences.init();
  await ApplicationSharedPreferences.init();
  await RecentSearchesSharedPreferences.init();
  await NotificationsSharedPreferences.init();
  await NotificationsSharedPreferences.reload();
}

Future clearSharedPreferences() async {
  await UserSharedPreferences.clear();
  await ApplicationSharedPreferences.clear();
  await RecentSearchesSharedPreferences.clear();
  await NotificationsSharedPreferences.clear();
}
