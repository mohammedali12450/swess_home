import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';

class MyThemes {
  // Light Theme:
  static lightTheme(BuildContext context) {
    // Select application font family based on language:
    bool isArabic =
        Provider.of<LocaleProvider>(context).getLocale().languageCode == 'ar';
    String fontFamily = isArabic ? "Tajawal" : "Hind";
    return ThemeData(
        colorScheme: ColorScheme(
          primary: AppColors.primaryColor,
          onPrimary: AppColors.white,
          secondary: AppColors.secondaryColor,
          onSecondary: AppColors.black,
          surface: AppColors.white,
          onSurface: AppColors.black,
          background: AppColors.white,
          onBackground: AppColors.black,
          error: Colors.red,
          onError: AppColors.white,
          brightness: Brightness.light,
          shadow: AppColors.black.withOpacity(0.36),
        ),
        scaffoldBackgroundColor: AppColors.white,
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
              height: isArabic ? 1.8 : 1),
          headline2: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.black),
          headline3: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black),
          headline4: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black),
          headline5: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              height: isArabic ? 1.8 : 1),
          headline6: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              height: isArabic ? 1.8 : 1),
          bodyText1: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              height: isArabic ? 1.8 : null),
          // bodyText2 used for Texts :
          bodyText2: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              height: isArabic ? 1.8 : null),
          // subtitle1 used for textField content and hint, ListTile title :
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          subtitle2: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400),
          button: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
          // caption used for textField error text:
          caption: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
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
            padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
            textStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: fontFamily),
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.black,
          size: 24.w,
          opacity: 1,
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.primaryColor,
          toolbarHeight: 75.h,
          titleTextStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: (isArabic) ? 20.sp : 22.sp,
              fontWeight: FontWeight.w500,
              height: (isArabic) ? 1.6 : null,
              color: Colors.white),
          iconTheme: IconThemeData(
            color: AppColors.white,
            size: 24.w,
            opacity: 1,
          ),
        ),
        dividerTheme: DividerThemeData(
            color: AppColors.black.withOpacity(0.64), thickness: 0.5, space: 1),
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
        ),
        fontFamily: fontFamily,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          unselectedIconTheme: IconThemeData(color: Colors.black45, size: 20),
          unselectedItemColor: Colors.black45,
          unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.lastColor),
          selectedIconTheme:
              IconThemeData(color: AppColors.lastColor, size: 25),
          selectedItemColor: AppColors.lastColor,
          selectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.lastColor),
          elevation: 20.0,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
          checkColor: MaterialStateProperty.all<Color>(AppColors.white),
        ),
        dialogTheme: const DialogTheme(
            contentTextStyle: TextStyle(fontSize: 18, color: Colors.red)));
  }

  // Dark Theme:
  static darkTheme(BuildContext context) {
    // Select application font family based on language:
    bool isArabic =
        Provider.of<LocaleProvider>(context).getLocale().languageCode == 'ar';
    String fontFamily = isArabic ? "Tajawal" : "Hind";
    return ThemeData(
      colorScheme: ColorScheme(
        primary: AppColors.primaryDark,
        onPrimary: Colors.black,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.white,
        surface: Colors.black54,
        onSurface: Colors.white54,
        background: AppColors.secondaryDark,
        onBackground: Colors.white,
        error: Colors.redAccent,
        onError: AppColors.white,
        brightness: Brightness.dark,
        shadow: AppColors.white.withOpacity(0.08),
      ),
      scaffoldBackgroundColor: AppColors.secondaryDark,
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w800),
        headline2: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w800),
        headline3: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.w600),
        headline4: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
        headline5: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        headline6: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        bodyText1: TextStyle(
            color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),
        // bodyText2 used for Texts :
        bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            height: isArabic ? 1.8 : null),
        // subtitle1 used for textField content and hint, ListTile title :
        subtitle1: TextStyle(
            color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
        subtitle2: TextStyle(
            color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w400),
        button: TextStyle(
            color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
        // caption used for textField error text:
        caption: TextStyle(
            color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
      ),
      hintColor: AppColors.white.withOpacity(0.48),
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
          textStyle: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              fontFamily: fontFamily),
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColors.white,
        size: 24.w,
        opacity: 1,
      ),
      appBarTheme: AppBarTheme(
        color: const Color(0xff26282B),
        toolbarHeight: 75.h,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: (isArabic) ? 20.sp : 22.sp,
          fontWeight: FontWeight.w500,
          height: (isArabic) ? 1.6 : null,
          color: AppColors.white,
        ),
        iconTheme: IconThemeData(
          color: AppColors.white,
          size: 24.w,
          opacity: 1,
        ),
      ),
      dividerTheme: DividerThemeData(
          color: AppColors.white.withOpacity(0.64), thickness: 0.5, space: 1),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      fontFamily: fontFamily,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.secondaryDark,
        unselectedIconTheme: const IconThemeData(color: Colors.white, size: 20),
        unselectedItemColor: Colors.white,
        unselectedLabelStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.white),
        selectedIconTheme: const IconThemeData(color: AppColors.lastColor, size: 25),
        selectedItemColor: AppColors.lastColor,
        selectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.lastColor),
        elevation: 20.0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(AppColors.primaryDark),
        checkColor: MaterialStateProperty.all<Color>(AppColors.black),
      ),
    );
  }
}
