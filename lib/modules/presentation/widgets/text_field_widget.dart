import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';

class TextFieldWidget extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets? padding;
  final TextEditingController textEditingController;
  final String hintText;
  final String? Function(String? val) onChanged;
  final VoidCallback onTap;
  final int? maxLength;
  final int? maxLines;

  const TextFieldWidget(
      {Key? key,
      required this.width,
      required this.height,
      this.padding,
      required this.textEditingController,
      required this.hintText,
      required this.onChanged,
      required this.onTap,
      this.maxLength,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Container(
      color: isDark ? AppColors.white.withOpacity(0.5) : AppColors.white,
      width: width,
      height: height,
      padding: padding,
      child: TextFormField(
        controller: textEditingController,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14.sp),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          hintText: hintText,
          border: InputBorder.none,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
        ),
        onChanged: onChanged,
        onTap: onTap,
        maxLength: maxLength,
        maxLines: maxLines,
      ),
    );
  }
}
