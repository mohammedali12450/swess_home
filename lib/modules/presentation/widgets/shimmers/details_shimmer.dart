import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import '../shimmer_widget.dart';

class DetailsShimmer extends StatelessWidget {
  const DetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 400,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, officeIndex) {
          return buildShimmerWidget();
        },
      ),
    );
  }

  SizedBox buildShimmerWidget() {
    return SizedBox(
      width: inf,
      height: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kHe20,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: ShimmerWidget.rectangular(
                    height: 30.h,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: ShimmerWidget.rectangular(
                    height: 20.h,
                    width: 80.w,
                  ),
                ),
                kHe20,
              ],
            ),
          ),
          kWi24,
        ],
      ),
    );
  }
}
