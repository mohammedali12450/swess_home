import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSharedPreferences {
  static late SharedPreferences _preferences;

  static const String isWalkThroughPassed = "walk_through_passed";
  static const String isMapTutorialPassed = "map_tutorial_passed";

  static init() async {
    _preferences = await SharedPreferences.getInstance();
    // Initializing:
    if (_preferences.getBool(isWalkThroughPassed) == null) {
      _preferences.setBool(isWalkThroughPassed, false);
    }

    if (_preferences.getBool(isMapTutorialPassed) == null) {
      _preferences.setBool(isMapTutorialPassed, false);
    }
  }

  static Future clear() async {
    bool success = false;
    success = await removeWalkThroughPassState();
    success = success & await removeMapTutorialPassState();

    if (success) {
      debugPrint("ApplicationSharedPreferences is clear now!");
    }
    return success;
  }

  static Future<bool> removeMapTutorialPassState() async {
    return await _preferences.remove(isMapTutorialPassed);
  }

  static setMapTutorialPassState(bool isPassed) async {
    await _preferences.setBool(isMapTutorialPassed, isPassed);
  }

  static bool getMapTutorialPassState() {
    return _preferences.getBool(isMapTutorialPassed)!;
  }

  static setWalkThroughPassState(bool isPassed) {
    _preferences.setBool(isWalkThroughPassed, isPassed);
  }

  static Future<bool> removeWalkThroughPassState() async {
    return await _preferences.remove(isWalkThroughPassed);
  }

  static bool getWalkThroughPassState() {
    return _preferences.getBool(isWalkThroughPassed)!;
  }
}
