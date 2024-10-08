import 'package:flutter/material.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';

showMySnackBar(BuildContext context , String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: ResText(content , textStyle: textStyling(S.s16, W.w6, C.bl),),
    ),
  );
}