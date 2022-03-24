import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/models/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? locale;

  LocaleProvider(this.locale);

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    this.locale = locale;
    notifyListeners();
  }

  Locale getLocale() {
    if (locale != null) return locale!;
    return window.locale;
  }

  bool isArabic(){
    return getLocale().languageCode == "ar" ;
  }

}
