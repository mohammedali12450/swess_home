import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentStepViewer extends StatelessWidget {
  final int stepsCount;
  final int currentStepIndex;
  final Color? activeCircleColor;

  final Color? unActiveCircleColor;

  const CurrentStepViewer(
      {Key? key,
      required this.stepsCount,
      required this.currentStepIndex,
      this.activeCircleColor,
      this.unActiveCircleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: stepsCount,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
                color: (index+1 == currentStepIndex)
                    ? (activeCircleColor??Theme.of(context).colorScheme.primary)
                    : (unActiveCircleColor??Theme.of(context).colorScheme.onBackground.withOpacity(0.32)),
                shape: BoxShape.circle),
          );
        },
      ),
    );
  }
}
