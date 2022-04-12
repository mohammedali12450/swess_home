import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/widgets/shimmer_widget.dart';


class ClientsOrdersShimmer extends StatelessWidget {

  /// Shimmer clients orders list effect list view
  const ClientsOrdersShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (_, index) {
          return buildShimmerWidget(context);
        });
  }

  Container buildShimmerWidget(BuildContext context) {
    return Container(
      width: 1.sw,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: kMediumSymHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.24)),
        borderRadius: medBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              ShimmerWidget.rectangular(
                height: 24.h,
                width: 110.w,
              ),
              const Spacer(),
              ShimmerWidget.rectangular(
                height: 24.h,
                width: 180.w,
              )

            ],
          ),
          kHe16 ,
          ShimmerWidget.rectangular(
            height: 24.h,
            width: 200.w,
          ),
          kHe16 ,
          ShimmerWidget.rectangular(
            height: 24.h,
            width: 220.w,
          ),
          kHe16 ,
          ShimmerWidget.rectangular(
            height: 24.h,
            width: 200.w,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: ShimmerWidget.circular(
              height: 48.h,
              width: 120.w,
              shapeBorder: const RoundedRectangleBorder(borderRadius: lowBorderRadius),
            ),
          ),
        ],
      ),
    );
  }

}
