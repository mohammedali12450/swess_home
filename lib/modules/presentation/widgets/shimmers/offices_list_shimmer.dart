import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/widgets/shimmer_widget.dart';

class OfficesListShimmer extends StatefulWidget {
  const OfficesListShimmer({Key? key}) : super(key: key);

  @override
  _OfficesListShimmerState createState() => _OfficesListShimmerState();
}

class _OfficesListShimmerState extends State<OfficesListShimmer> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (_, officeIndex) {
        return buildShimmerWidget();
      },
    );
  }

  SizedBox buildShimmerWidget() {
    return SizedBox(
      width: inf,
      height: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kWi24,
          Expanded(
            flex: 1,
            child: ShimmerWidget.rectangular(
              height: 80.h,
              width: 160.w,
            ),
          ),
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
