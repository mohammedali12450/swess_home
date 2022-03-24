import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swesshome/constants/colors.dart';

enum S {
  s17,
  s6,
  s8,
  s10,
  s12,
  s14,
  s15,
  s16,
  s18,
  s20,
  s22,
  s24,
  s26,
  s28,
  s30,
  s32,
  s34,
  s36,
  s38,
  s40,
  s42,
  s44,
  s46,
  s48,
  s50
}
enum W { w1, w2, w3, w4, w5, w6, w7, w8, w9 }
enum C { c1, c2, c3, c4, bl, wh, hint, whHint }
enum F { roboto, tajawal, cairo, libreFranklin }

TextStyle textStyling(S fontSize, W fontWeight, C fontColor,
    {fontFamily = F.tajawal}) {
  switch (fontFamily) {
    case F.roboto:
      return GoogleFonts.roboto(
          fontSize: double.parse(fontSize.toString().substring(3)),
          color: _getColor(fontColor),
          fontWeight: _getFontWeight(fontWeight));
    case F.tajawal:
      return GoogleFonts.tajawal(
          fontSize: double.parse(fontSize.toString().substring(3)),
          color: _getColor(fontColor),
          fontWeight: _getFontWeight(fontWeight));
    case F.cairo:
      return GoogleFonts.cairo(
          fontSize: double.parse(fontSize.toString().substring(3)),
          color: _getColor(fontColor),
          fontWeight: _getFontWeight(fontWeight));
    case F.libreFranklin:
      return GoogleFonts.libreFranklin(
          fontSize: double.parse(fontSize.toString().substring(3)),
          color: _getColor(fontColor),
          fontWeight: _getFontWeight(fontWeight));
    default:
      return const TextStyle();
  }
}

Color _getColor(C fontColor) {
  switch (fontColor) {
    case C.c1:
      return AppColors.baseColor;
    case C.c2:
      return AppColors.secondaryColor;
    case C.c3:
      return AppColors.thirdColor;
    case C.c4:
      return AppColors.lastColor;
    case C.bl:
      return AppColors.black;
    case C.wh:
      return AppColors.white;
    case C.hint:
      return AppColors.hintColor;
    case C.whHint:
      return AppColors.whiteHintColor;
    default:
      return AppColors.black;
  }
}

FontWeight _getFontWeight(W fontWeight) {
  switch (fontWeight) {
    case W.w1:
      return FontWeight.w100;
    case W.w2:
      return FontWeight.w200;
    case W.w3:
      return FontWeight.w300;
    case W.w4:
      return FontWeight.w400;
    case W.w5:
      return FontWeight.w500;
    case W.w6:
      return FontWeight.w600;
    case W.w7:
      return FontWeight.w700;
    case W.w8:
      return FontWeight.w800;
    case W.w9:
      return FontWeight.w900;
    default:
      return FontWeight.w500;
  }
}
