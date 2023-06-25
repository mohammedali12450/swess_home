import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';


class SmallElevatedCard extends StatelessWidget {
  final String content;
  final void Function(String content)? onDelete;
  final bool isRemovable ;

  const SmallElevatedCard(
      {Key? key, required this.content, this.onDelete , this.isRemovable = true })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late bool?  isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
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
            Flexible(
              child: Text(
                content,
                style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.white ,
                ),
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
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
                color: isDark ? AppColors.white :  Theme.of(context).colorScheme.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
