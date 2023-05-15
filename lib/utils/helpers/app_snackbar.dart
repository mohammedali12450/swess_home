import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:swesshome/main.dart';

class AppSnackBar {
  static void showSnackBar({
    required String message,
    IconData icon = FluentIcons.warning_24_regular,
    double? offsetY,
  }) async =>
      ScaffoldMessenger.of(navigatorKey.currentState!.context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: Theme.of(
              navigatorKey.currentState!.context,
            ).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
            elevation: 0,
            content: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white.withOpacity(.85),
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        );
}
