import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';


class SmallElevatedCard extends StatelessWidget {
  final String content;
  final void Function(String content) onDelete;

  const SmallElevatedCard(
      {Key? key, required this.content, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Res.width(8),
        vertical: Res.height(2),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Res.width(12),
        vertical: Res.height(6),
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        boxShadow: [
          BoxShadow(
              color: black.withOpacity(0.24),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0)
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: SizedBox(
        height: Res.height(32),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResText(
              content,
              textStyle: textStyling(S.s14, W.w4, C.wh),
              textAlign: TextAlign.center,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                onDelete(content);
              },
              icon: const Icon(
                Icons.close,
                color: white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
