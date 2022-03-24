import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ThemeProvider(this.themeMode);

  /// null if themeMode is [system],
  ///  false if themeMode is [light],
  ///  true if themeMode is [dark],
  bool? isDarkMode() {
    switch (themeMode) {
      case ThemeMode.system:
        return null;
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
    }
  }

  setTheme(ThemeMode themeMode) {
    this.themeMode = themeMode;
    notifyListeners();
  }

  int getModeIndex() {
    int initialModeSelected = 0;
    switch (themeMode) {
      case ThemeMode.system:
        initialModeSelected = 0;
        break;
      case ThemeMode.dark:
        initialModeSelected = 1;
        break;
      case ThemeMode.light:
        initialModeSelected = 2;
        break;
    }
    return initialModeSelected;
  }

  ThemeMode getThemeModeViaIndex(int index) {
    switch (index) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.dark;
      case 2:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
