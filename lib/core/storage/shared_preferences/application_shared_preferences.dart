import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSharedPreferences {
  static late SharedPreferences _preferences;

  static const String isWalkThroughPassed = "walk_through_passed";
  static const String isMapTutorialPassed = "map_tutorial_passed";
  static const String loginPassed = "login_passed";
  static const String isDarkMode = "is_dark_mode";
  static const String languageCode = "language_code";
  static const String isLanguageSelected = "is_language_selected";
  static const String versionKey = "version_Key";
  static const String downloadKey = "Download_Key";
  static const String visitNumKey = "visit_num_Key";
  static const definitionTourFirstLunch = "definition-tour";

  static init() async {
    _preferences = await SharedPreferences.getInstance();
    // Initializing:
    if (_preferences.getBool(isWalkThroughPassed) == null) {
      await _preferences.setBool(isWalkThroughPassed, false);
    }
    if (_preferences.getInt(visitNumKey) == null) {
      await _preferences.setInt(versionKey, 1);
    }
    if (_preferences.getBool(loginPassed) == null) {
      await _preferences.setBool(loginPassed, false);
    }

    if (_preferences.getBool(isMapTutorialPassed) == null) {
      await _preferences.setBool(isMapTutorialPassed, false);
    }
  }

  static Future clear() async {
    bool success = false;
    success = await removeWalkThroughPassState();
    success = success & await removeMapTutorialPassState();
    success = success & await removeIsDarkMode();
    success &= await removeLanguageCode();
    success &= await removeIsLanguageSelected();

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

  static setDownloadUrl(String url) async {
    await _preferences.setString(downloadKey, url);
  }

  static String getDownloadUrl() {
    return _preferences.getString(downloadKey)!;
  }

  static setLoginPassed(bool pass) async {
    await _preferences.setBool(loginPassed, pass);
  }

  static bool getLoginPassed() {
    return _preferences.getBool(loginPassed)!;
  }

  static setVisitNumber(int num) async {
    await _preferences.setInt(visitNumKey, num);
  }

  static int getVisitNumber() {
    return _preferences.getInt(visitNumKey) ?? 1;
  }

  static setVersionAppState(String isPassed) async {
    await _preferences.setString(versionKey, isPassed);
  }

  static String getVersionAppState() {
    return _preferences.getInt(versionKey)!.toString();
  }

  static setWalkThroughPassState(bool isPassed) {
    _preferences.setBool(isWalkThroughPassed, isPassed);
  }

  static Future<bool> removeWalkThroughPassState() async {
    return await _preferences.remove(isWalkThroughPassed);
  }

  static bool getWalkThroughPassState() {
    return _preferences.getBool(isWalkThroughPassed) ?? false;
  }

  static setIsDarkMode(bool? isDarkModeSelected) async {
    if (isDarkModeSelected == null) {
      removeIsDarkMode();
      return;
    }
    await _preferences.setBool(isDarkMode, isDarkModeSelected);
  }

  // when isDarkMode is null then will set dynamic mode.
  static getIsDarkMode() {
    return _preferences.getBool(isDarkMode);
  }

  static Future<bool> removeIsDarkMode() async {
    return await _preferences.remove(isDarkMode);
  }

  static setLanguageCode(String selectedCode) async {
    await _preferences.setString(languageCode, selectedCode);
  }

  static String? getLanguageCode() {
    return _preferences.getString(languageCode);
  }

  static Future<bool> removeLanguageCode() async {
    return await _preferences.remove(languageCode);
  }

  static setIsLanguageSelected(bool isSelected) async {
    await _preferences.setBool(isLanguageSelected, isSelected);
  }

  static bool getIsLanguageSelected() {
    return _preferences.getBool(isLanguageSelected) ?? false;
  }

  static Future<bool> removeIsLanguageSelected() async {
    return await _preferences.remove(isLanguageSelected);
  }

  static Future<bool> isFirstLaunchForDefinitionTour() async {
    bool isFirstLaunch = _preferences.getBool(definitionTourFirstLunch) ?? true;
    if (isFirstLaunch) {
      _preferences.setBool(definitionTourFirstLunch, false);
    }
    return isFirstLaunch;
  }
}
