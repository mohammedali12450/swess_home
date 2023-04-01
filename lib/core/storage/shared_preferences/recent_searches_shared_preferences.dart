import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../modules/data/models/estate.dart';

class RecentSearchesSharedPreferences {
  static late SharedPreferences _preferences;
  static const String recentSearchesKey = "recent_searches_key";
  static const String searchesKey = "searches_key";
  static const String searchesFilterKey = "searches_filter_key";
  static const String dateRefreshRecentKey = "date_refresh_recent_key";
  static const String isUpdateRecentKey = "is_update_recent_key";

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

  static setSearches(List<Estate> estates) async {
    // Encode and store data in SharedPreferences
    final String encodedData = Estate.encode(estates);

    return await _preferences.setString(searchesKey, encodedData);
  }

  static Future<bool> removeSearches() async {
    return await _preferences.remove(searchesKey);
  }

  static Future<List<Estate>> getSearches() async {
    // Fetch and decode data
    final String? estateString = _preferences.getString(searchesKey);
    List<Estate> estate = [];

    if (estateString != null) {
      estate = Estate.decode(estateString);
    }

    return estate;
  }

  static Future<bool> setRecentSearchesFilter(
      List<String> recentFilterSearches) async {
    return await _preferences.setStringList(
        searchesFilterKey, recentFilterSearches);
  }

  static Future<bool> removeRecentSearchesFilter() async {
    return await _preferences.remove(searchesFilterKey);
  }

  static List<String>? getRecentSearchesFilter() {
    return _preferences.getStringList(searchesFilterKey);
  }

  static Future<bool> setDateRefreshRecent(int dateRefreshRecent) async {
    return await _preferences.setInt(dateRefreshRecentKey, dateRefreshRecent);
  }

  static int? getDateRefreshRecent() {
    return _preferences.getInt(dateRefreshRecentKey);
  }

  static Future<bool> setIsUpdateRecent(bool isUpdateRecent) async {
    return await _preferences.setBool(isUpdateRecentKey, isUpdateRecent);
  }

  static bool getIsUpdateRecent() {
    return _preferences.getBool(isUpdateRecentKey) ?? false;
  }
}
