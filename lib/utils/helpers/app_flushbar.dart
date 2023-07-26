import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/colors.dart';

import 'package:swesshome/main.dart';

class AppFlushbar {
  static Flushbar? flushbar;
  static bool isShowing = false;

  static Future<void> show({
    required String message,
    //required bool isDark,
    IconData icon = FluentIcons.warning_24_regular,
    bool isTop = true,
  }) async {
    if (isShowing) return;
    isShowing = true;
    BuildContext context = navigatorKey.currentState!.context;
    flushbar = Flushbar(
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 16.sp, color: AppColors.secondaryDark),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 12.h,
      ),
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      flushbarPosition: isTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
      backgroundColor: AppColors.white,
      duration: const Duration(seconds: 4),
      margin: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 12.h,
      ),
      animationDuration: const Duration(milliseconds: 800),
      icon: Icon(
        icon,
        color: AppColors.primaryColor,
        size: 30.sp,
      ),
      borderRadius: BorderRadius.circular(5.r),
    );
    await flushbar!.show(context);
    isShowing = false;
  }

  static Future<void> hide() async {
    if (flushbar == null) return;

    await flushbar!.dismiss();
    isShowing = false;
  }
}
