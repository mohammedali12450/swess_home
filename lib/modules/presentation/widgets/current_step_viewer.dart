import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
      height: Res.height(50),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: stepsCount,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: Res.width(5),
            ),
            width: Res.width(12),
            height: Res.height(12),
            decoration: BoxDecoration(
                color: (index+1 == currentStepIndex)
                    ? (activeCircleColor??lastColor)
                    : (unActiveCircleColor??white),
                shape: BoxShape.circle),
          );
        },
      ),
    );
  }
}
