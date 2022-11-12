import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/core/functions/screen_informations.dart';

Future<void> myCupertinoActionSheet(
  BuildContext context, {
  Widget? title,
  Widget? message,
  List<dynamic>? elementsList,
  List<Function()>? onPressed,
  bool isDefaultAction = true,
  bool isDestructiveAction = false,
}) async {
  final action = CupertinoActionSheet(
    title: title,
    message: message,
    actions: <Widget>[
      SizedBox(
        height: getScreenHeight(context) / 3,
        child: ListView.separated(
          itemCount: elementsList!.length,
          itemBuilder: (_, index) {
            return CupertinoActionSheetAction(
                child: Text(elementsList[index],
                    style: Theme.of(context).textTheme.headline4),
                isDefaultAction: isDefaultAction,
                isDestructiveAction: isDestructiveAction,
                onPressed: () {
                  if (onPressed != null) {
                    onPressed[index]();
                    return;
                  }
                });
          },
          separatorBuilder: (_, __) {
            return const Divider(
              thickness: 0.2,
            );
          },
        ),
      )
    ],
    cancelButton: CupertinoActionSheetAction(
      child: Text(AppLocalizations.of(context)!.cancel,
          style: Theme.of(context).textTheme.headline4),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
  return await showCupertinoModalPopup(
      context: context, builder: (context) => action);
}
