import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';

class ResText extends StatelessWidget {
  final String text;

  final TextStyle? textStyle;

  final int maxLines;

  final double minFontSize;

  final double maxFontSize;

  final TextAlign textAlign;

  final double letterSpacing;

  const ResText(
    this.text, {Key? key,
    this.textStyle,
    this.maxLines = 1,
    this.minFontSize = 6,
    this.maxFontSize = 34,
    this.textAlign = TextAlign.center,
    this.letterSpacing = 0.4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: textStyle ?? textStyling(S.s14, W.w5, C.c2, fontFamily: F.roboto),
      textScaleFactor: 1,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      maxLines: maxLines,
      textAlign: textAlign,

    );
  }
}
