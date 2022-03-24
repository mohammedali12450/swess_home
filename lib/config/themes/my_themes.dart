import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';

class MyThemes {
  // Light Theme:
  static lightTheme(BuildContext context) {
    // Select application font family based on language:
    bool isArabic = Provider.of<LocaleProvider>(context).getLocale().languageCode == 'ar';
    String fontFamily = isArabic ? "Tajawal" : "Hind";
    return ThemeData(
      colorScheme: ColorScheme(
        primary: AppColors.baseColor,
        onPrimary: AppColors.white,
        secondary: AppColors.thirdColor,
        onSecondary: AppColors.black,
        surface: AppColors.white,
        onSurface: AppColors.black,
        background: AppColors.white,
        onBackground: AppColors.black,
        error: Colors.red,
        onError: AppColors.white,
        brightness: Brightness.light,
        shadow: AppColors.black.withOpacity(0.24),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
        headline2: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
        headline3: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        headline4: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        headline5: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyText1: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        // bodyText2 used for Texts :
        bodyText2: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        // subtitle1 used for textField content and hint, ListTile title :
        subtitle1: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
        subtitle2: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        button: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        // caption used for textField error text:
        caption: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
      ),
      hintColor: AppColors.black.withOpacity(0.32),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          minimumSize: Size(24.w, 32.h),
          maximumSize: Size(1.sw, 64.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          textStyle:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, fontFamily: fontFamily),
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColors.black,
        size: 24.w,
        opacity: 1,
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.baseColor,
        toolbarHeight: 75.h,
        titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: (isArabic) ? 20.sp : 22.sp,
            fontWeight: FontWeight.w500,
            height: (isArabic) ? 1.6 : null),
      ),
      dividerTheme:
          DividerThemeData(color: AppColors.black.withOpacity(0.64), thickness: 0.5, space: 1),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      fontFamily: fontFamily,
    );
  }

  // Dark Theme:
  static darkTheme(BuildContext context) {
    // Select application font family based on language:
    bool isArabic = Provider.of<LocaleProvider>(context).getLocale().languageCode == 'ar';
    String fontFamily = isArabic ? "Tajawal" : "Hind";
    return ThemeData(
      colorScheme: ColorScheme(
        primary: AppColors.baseColor,
        onPrimary: Colors.white,
        secondary: Colors.white24,
        onSecondary: AppColors.black,
        surface: Colors.black54,
        onSurface: Colors.white54,
        background: const Color(0xff423F3E),
        onBackground: Colors.white54,
        error: Colors.redAccent,
        onError: AppColors.white,
        brightness: Brightness.dark,
        shadow: AppColors.black.withOpacity(0.08),

      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
        headline2: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
        headline3: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        headline4: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        headline5: TextStyle(fontSize: 20, fontWeight: FontWeight.w600 , color: Colors.white70),
        headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyText1: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        // bodyText2 used for Texts :
        bodyText2: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        // subtitle1 used for textField content and hint, ListTile title :
        subtitle1: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        subtitle2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        button: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        // caption used for textField error text:
        caption: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      hintColor: AppColors.black.withOpacity(0.32),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          minimumSize: Size(24.w, 32.h),
          maximumSize: Size(1.sw, 64.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          textStyle:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, fontFamily: fontFamily),
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColors.white,
        size: 24.w,
        opacity: 1,
      ),
      appBarTheme: AppBarTheme(
        color: AppColors.baseColor,
        toolbarHeight: 75.h,
        titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: (isArabic) ? 20.sp : 22.sp,
            fontWeight: FontWeight.w500,
            height: (isArabic) ? 1.6 : null),
        iconTheme: IconThemeData(
          color: AppColors.white,
          size: 24.w,
          opacity: 1,
        ),
      ),
      dividerTheme:
          DividerThemeData(color: AppColors.white.withOpacity(0.64), thickness: 0.5, space: 1),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      fontFamily: fontFamily,
    );
  }
}
