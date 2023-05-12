import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return TextButton(
      onPressed: onPresses,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
