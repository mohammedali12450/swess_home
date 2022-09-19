import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';

import '../../../data/providers/theme_provider.dart';

class MapPopupMessageTutorial extends StatelessWidget {
  final void Function() onPressed;
  final String title;

  final String content;

  const MapPopupMessageTutorial({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Container(
      width: 320.w,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDark : AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: !isDark ? AppColors.black : AppColors.white),
          ),
          24.verticalSpace,
          Text(
            content,
            maxLines: 10,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: !isDark ? AppColors.black : AppColors.white,
                fontSize: 17),
          ),
          24.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(180.w, 56.h),
            ),
            child: Text(
              AppLocalizations.of(context)!.next,
            ),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
