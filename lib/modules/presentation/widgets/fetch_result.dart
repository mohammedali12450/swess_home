import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          size: iconSize ?? 0.5.sw,
          color: Theme.of(context).hintColor,
        ),
        kHe24,
        ResText(
          content,
          textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.48),
          ),
        ),
      ],
    );
  }
}
