import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';



class DialogAction {
  final String content;

  final void Function(BuildContext context) onPressed;

  DialogAction({required this.content, required this.onPressed});
}

Future showMyAlertDialog(String title, String content, BuildContext context,
    {required List<DialogAction> actions}) async {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        List<CupertinoDialogAction> cupertinoActions = [];
        for (DialogAction dialogAction in actions) {
          cupertinoActions.add(
            CupertinoDialogAction(
              child: ResText(dialogAction.content),
              onPressed: () {
                dialogAction.onPressed(context);
              },
            ),
          );
        }
        return CupertinoAlertDialog(
          content: SizedBox(
            width: inf,
            child: ResText(
              content,
              textStyle: textStyling(S.s16, W.w5, C.bl),
              textAlign: TextAlign.center,
            ),
          ),
          title: SizedBox(
            width: inf,
            child: ResText(
              title,
              textStyle: textStyling(S.s16, W.w5, C.bl),
              textAlign: TextAlign.center,
            ),
          ),
          actions: cupertinoActions,
        );
      },
    );
  } else if (Platform.isAndroid) {
    showDialog<void>(
      context: context,
      builder: (context) {
        List<Widget> androidActions = [];
        for (DialogAction dialogAction in actions) {
          androidActions.add(
            TextButton(
              child: Text(dialogAction.content),
              onPressed: () {
                dialogAction.onPressed(context);
              },
            ),
          );
        }
        return AlertDialog(
            content: Text(
              content,
              textAlign: TextAlign.right,
            ),
            title: Text(
              title,
              textAlign: TextAlign.right,
            ),
            actions: androidActions);
      },
    );
  }
}
