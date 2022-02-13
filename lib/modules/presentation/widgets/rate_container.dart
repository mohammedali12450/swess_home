import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'res_text.dart';

class RateContainer extends StatelessWidget {
  final double rate;
  final Color? borderColors;
  final double? borderRadius;

  const RateContainer(
      {required this.rate, this.borderColors, this.borderRadius, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Res.height(40),
      decoration: BoxDecoration(
        border: Border.all(color: borderColors ?? black),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rate,
            color: Colors.yellow,
            size: 24,
          ),
          kWi4,
          ResText(
            rate.toString(),
            textStyle: textStyling(S.s14, W.w5, C.bl, fontFamily: F.roboto),
          ),
        ],
      ),
    );
  }
}
