import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static late SharedPreferences _preferences;

  static const String accessTokenKey = "access_token";

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future clear() async {
    bool success = false;
    success = await removeAccessToken() ;
    if (success) {
      debugPrint("UserSharedPreferences is clear now!");
    }
    return success;
  }

  static setAccessToken(String accessToken)async {
    await _preferences.setString(accessTokenKey, accessToken);
  }

  static Future<bool> removeAccessToken()async {
    return await _preferences.remove(accessTokenKey);
  }

  static String? getAccessToken() {
    return _preferences.getString(accessTokenKey);
  }
}
