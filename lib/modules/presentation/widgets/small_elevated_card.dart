import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';


class SmallElevatedCard extends StatelessWidget {
  final String content;
  final void Function(String content)? onDelete;
  final bool isRemovable ;

  const SmallElevatedCard(
      {Key? key, required this.content, this.onDelete , this.isRemovable = true })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 2.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.24),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0)
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: SizedBox(
        height: 32.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResText(
              content,
              textStyle: textStyling(S.s14, W.w4, C.wh),
              textAlign: TextAlign.center,
            ),
            if(isRemovable)
              IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if(onDelete != null){
                  onDelete!(content);
                }
              },
              icon:  Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
