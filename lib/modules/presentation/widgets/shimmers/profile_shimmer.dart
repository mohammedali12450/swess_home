import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';

import '../shimmer_widget.dart';

class ProfileShimmer extends StatefulWidget {
  const ProfileShimmer({Key? key}) : super(key: key);

  @override
  State<ProfileShimmer> createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<ProfileShimmer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kHe28,
        const ShimmerWidget.circular(width: 100, height: 100),
        kHe12,
        const ShimmerWidget.rectangular(
          height: 20,
          width: 200,
        ),
        kHe24,
        const ShimmerWidget.rectangular(
          height: 20,
          width: 300,
        ),
        kHe24,
        SizedBox(
          height: 300,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (_, officeIndex) {
              return buildShimmerWidget();
            },
          ),
        )
      ],
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
