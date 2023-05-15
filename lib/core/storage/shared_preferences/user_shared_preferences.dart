import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static late SharedPreferences _preferences;

  static const String accessTokenKey = "access_token";
  static const String userPhoneNumKey = "user_Phone_Num_Key";
  static const String dateShowReviewKey = "date_show_review_key";

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future clear() async {
    bool success = false;
    success = await removeAccessToken();
    if (success) {
      debugPrint("UserSharedPreferences is clear now!");
    }
    return success;
  }

  static setAccessToken(String accessToken) async {
    await _preferences.setString(accessTokenKey, accessToken);
  }

  static Future<bool> removeAccessToken() async {
    return await _preferences.remove(accessTokenKey);
  }

  static String? getAccessToken() {
    return _preferences.getString(accessTokenKey);
  }

  static setPhoneNumber(String phoneNum) async {
    await _preferences.setString(userPhoneNumKey, phoneNum);
  }

  static String? getPhoneNumber() {
    return _preferences.getString(userPhoneNumKey);
  }

  static Future<void> setDateShowReview(String dateShowReview) async {
    await _preferences.setString(dateShowReviewKey, dateShowReview);
  }

  static String? getDateShowReview() {
    return _preferences.getString(dateShowReviewKey);
  }
}
