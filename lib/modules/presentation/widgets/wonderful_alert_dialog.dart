import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/colors.dart';

Future<void> showWonderfulAlertDialog(
    BuildContext context,
    String title,
    String body, {
      String? defaultButtonContent,
      double? defaultButtonWidth,
      double? defaultButtonHeight,
      Function()? onDefaultButtonPressed,
      TextStyle? titleTextStyle,
      TextStyle? bodyTextStyle,
      TextStyle? defaultButtonContentStyle,
      bool removeDefaultButton = false,
      List<Widget>? dialogButtons,
      double? width,
      double? height,
      EdgeInsets? dialogPadding,
      double? elevation,
      Color? backgroundColor,
      double? borderRadius,
      bool barrierDismissible = true,
    }) async {
  await showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) => Dialog(
      elevation: elevation ?? 2,
      child: Container(
        width: width ?? 250.w,
        height: height,
        padding: dialogPadding ?? EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 8),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: titleTextStyle ?? Theme.of(context).textTheme.bodyText1,
              ),
              24.verticalSpace,
              Text(
                body,
                style: bodyTextStyle ??
                    Theme.of(context).textTheme.bodyText2!.copyWith(
                      height: 1.8,
                    ),
                maxLines: 50,
                textAlign: TextAlign.center,
              ),
              32.verticalSpace,
              Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                spacing: 12.h,
                runSpacing: 12.w,
                children: [
                  (removeDefaultButton)
                      ? Container()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(88.w, 56.h),
                        maximumSize: Size(100.w, 56.h),
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w)),
                    onPressed: () {
                      if (onDefaultButtonPressed != null) {
                        onDefaultButtonPressed();
                        return;
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      defaultButtonContent ?? AppLocalizations.of(context)!.ok,
                      style: defaultButtonContentStyle ??
                          Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: AppColors.white),
                    ),
                  ),
                ] +
                    (dialogButtons ?? []),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
