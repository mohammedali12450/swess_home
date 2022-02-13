import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import '../shimmer_widget.dart';

class EstatesShimmer extends StatelessWidget {
  const EstatesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (_, index) {
        return buildPropertyShimmer();
      },
    );
  }

  Container buildPropertyShimmer() {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(
          vertical: Res.height(8), horizontal: Res.width(16)),
      decoration: BoxDecoration(
        borderRadius: medBorderRadius,
        border: Border.all(color: black.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Container(
            height: Res.height(200),
            width: inf,
            decoration: BoxDecoration(
              color: black.withOpacity(0.12),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ShimmerWidget.rectangular(
                  height: Res.height(80),
                ),
              ),
              Expanded(
                flex: 6,
                child: ShimmerWidget.rectangular(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  height: Res.height(80),
                ),
              ),
            ],
          ),
          kHe16,
          SizedBox(
            height: Res.height(80),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                kWi12,
                Expanded(
                  flex: 1,
                  child: ShimmerWidget.rectangular(
                    height: Res.height(75),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: inf,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: Res.width(12)),
                        child: ShimmerWidget.rectangular(
                          height: Res.height(20),
                          width: Res.width(220),
                        ),
                      ),
                      kHe12,
                      Container(
                        width: inf,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: Res.width(12)),
                        child: ShimmerWidget.rectangular(
                          height: Res.height(16),
                          width: Res.width(180),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          kHe24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShimmerWidget.circular(
                height: Res.height(48),
                width: Res.width(60),
                shapeBorder:
                    const RoundedRectangleBorder(borderRadius: lowBorderRadius),
              ),
              ShimmerWidget.circular(
                height: Res.height(48),
                width: Res.width(60),
                shapeBorder:
                    const RoundedRectangleBorder(borderRadius: lowBorderRadius),
              ),
              ShimmerWidget.circular(
                height: Res.height(48),
                width: Res.width(60),
                shapeBorder:
                    const RoundedRectangleBorder(borderRadius: lowBorderRadius),
              ),
            ],
          ),
          kHe8,
        ],
      ),
    );
  }
}
