import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';

class ReviewButton extends StatelessWidget {
  const ReviewButton({
    super.key,
    required this.onPresses,
    required this.text,
  });

  final void Function() onPresses;
  final String text;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return TextButton(
      onPressed: onPresses,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          color: isDark? AppColors.lightblue : AppColors.primaryColor
        ),
      ),
    );
  }
}
