import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ThemeProvider(this.themeMode);


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

  bool isDarkMode(BuildContext context) {
    if (themeMode == ThemeMode.dark) {
      return true;
    } else if (themeMode == ThemeMode.light) {
      return false;
    } else {
      var brightness = MediaQuery.of(context).platformBrightness;
      return brightness == Brightness.dark;
    }
  }
}
