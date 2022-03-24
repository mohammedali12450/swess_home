import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import '../my_button.dart';
import '../res_text.dart';

class MapPopupMessageTutorial extends StatelessWidget {
  final void Function() onPressed;
  final String title;

  final String content;

  final double bottomRightRadius;

  const MapPopupMessageTutorial({Key? key,
    required this.onPressed,
    required this.title,
    required this.content,
    this.bottomRightRadius = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Res.width(320),
      padding: kMediumSymHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(20),
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomRight: Radius.circular(bottomRightRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ResText(
            title,
            textStyle: textStyling(S.s20, W.w6, C.bl),
            textAlign: TextAlign.center,
          ),
          kHe16,
          ResText(
            content,
            maxLines: 10,
            textAlign: TextAlign.center,
            textStyle: textStyling(S.s16, W.w5, C.bl).copyWith(height: 1.6),
          ),
          kHe16,
          MyButton(
            child: ResText(
              "التالي",
              textStyle: textStyling(S.s14, W.w5, C.wh),
            ),
            height: Res.height(56),
            width: Res.width(100),
            color: AppColors.lastColor,
            shadow: [BoxShadow(
                color: Colors.black.withOpacity(0.24),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0),
            ] ,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
