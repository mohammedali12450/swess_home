import 'package:flutter/material.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';

class MySnackBar {
  static show(BuildContext context,String content, {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ResText(content , textStyle: textStyling(S.s16, W.w5, C.wh) , textAlign: TextAlign.center,),
        duration: duration?? const Duration(seconds: 2),
      ),
    );
  }
}
