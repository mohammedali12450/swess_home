import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSharedPreferences {
  static late SharedPreferences _preferences;

  static const String notificationsCountKey = "notifications_count_key";

  static init() async {
    _preferences = await SharedPreferences.getInstance();
    // Initializing:
    if (_preferences.getInt(notificationsCountKey) == null) {
      _preferences.setInt(notificationsCountKey, 0);
    }
  }

  static reload() async {
    await _preferences.reload();
  }

  static clear() async {
    bool success = false;
    success = await removeNotificationsCount();
    if (success) {
      debugPrint("NotificationsSharedPreferences is clear now!!");
    }
    return success;
  }

  static Future<bool> removeNotificationsCount() async {
    return await _preferences.remove(notificationsCountKey);
  }

  static setNotificationsCount(int notificationsCount) async {
    await _preferences.setInt(notificationsCountKey, notificationsCount);
  }

  static int getNotificationsCount() {
    return _preferences.getInt(notificationsCountKey) ?? 0;
  }
}
