import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRating extends StatelessWidget {
  const AddRating({
    super.key,
    required this.initialRating,
    required this.onRatingUpdate,
  });

  final double initialRating;
  final void Function(double) onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      glow: false,
      itemCount: 5,
      allowHalfRating: true,
      itemPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
      unratedColor: const Color(0xFF979797).withOpacity(0.3),
      itemSize: 35.sp,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}
