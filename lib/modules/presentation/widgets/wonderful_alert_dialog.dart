import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'my_button.dart';

Future<void> showWonderfulAlertDialog(
  BuildContext context,
  String title,
  String body, {
  String? defaultButtonContent,
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
        width: width ?? Res.width(250),
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
              textStyle: bodyTextStyle ?? textStyling(S.s16, W.w5, C.bl),
            ),            kHe32,
            Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              spacing: Res.height(12),
              runSpacing: Res.width(12),
              children: [
                    (removeDefaultButton)
                        ? Container()
                        : MyButton(
                            color: secondaryColor,
                            borderRadius: 4,
                            width: Res.width(120),
                            height: Res.height(56),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: ResText(
                              defaultButtonContent ?? "Ok",
                              textStyle: defaultButtonContentStyle ??
                                  textStyling(S.s14, W.w5, C.c1),
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
