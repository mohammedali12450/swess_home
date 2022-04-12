import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateContainer extends StatelessWidget {
  final double rate;
  final Color? borderColors;
  final double? borderRadius;

  const RateContainer({required this.rate, this.borderColors, this.borderRadius, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 40.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_rate,
            color: Colors.yellow,
            size: 24.w,
          ),
          6.horizontalSpace,
          Text(
            rate.toString(),
            style: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.8),
          ),
        ],
      ),
    );
  }
}
