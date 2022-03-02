import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'res_text.dart';

class FetchResult extends StatelessWidget {
  final String content;
  final double topPadding;

  final IconData? iconData;
  final double? iconSize;

  const FetchResult(
      {Key? key, required this.content, this.iconData, this.topPadding = 0, this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: topPadding,
        ),
        Icon(
          iconData ?? Icons.error_outline,
          size: iconSize ?? screenWidth / 2,
          color: hintColor,
        ),
        kHe24,
        ResText(
          content,
          textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(
            color: black.withOpacity(0.48),
          ),
        ),
      ],
    );
  }
}
