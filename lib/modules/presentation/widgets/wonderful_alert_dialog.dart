import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'res_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
}) async {
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      elevation: elevation ?? 2,
      child: Container(
        width: width ?? 250.w,
        height: height,
        padding: dialogPadding ?? kLargeSymHeight,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            ResText(
              title,
              textStyle: titleTextStyle ?? textStyling(S.s18, W.w6, C.bl),
            ),
            kHe24,
            ResText(
              body,
              textStyle: bodyTextStyle ?? Theme.of(context).textTheme.bodyText2,
              maxLines: 50,
              textAlign: TextAlign.center,
            ),
            kHe24,
            Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              spacing: 12.h,
              runSpacing: 12.w,
              children: [
                    (removeDefaultButton)
                        ? Container()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(fixedSize: Size(180.w, 56.h)),
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
                                      .button!
                                      .copyWith(color: Theme.of(context).colorScheme.background),
                            ),
                          ),
                  ] +
                  (dialogButtons ?? []),
            ),
          ],
        ),
      ),
    ),
  );
}
