import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesSharedPreferences {
  static late SharedPreferences _preferences;
  static const String recentSearchesKey = "recent_searches_key";

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future clear() async {
    bool success = false;
    success = await removeRecentSearches();
    if (success) {
      debugPrint("RecentSearchesSharedPreferences is clear now!!!");
    }
    return success;
  }

  static Future<bool> setRecentSearches(List<String> recentSearches) async {
    return await _preferences.setStringList(recentSearchesKey, recentSearches);
  }

  static Future<bool> removeRecentSearches() async {
    return await _preferences.remove(recentSearchesKey);
  }

  static List<String>? getRecentSearches() {
    return _preferences.getStringList(recentSearchesKey);
  }
}
