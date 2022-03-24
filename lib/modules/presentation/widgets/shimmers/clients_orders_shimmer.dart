import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/widgets/shimmer_widget.dart';
import 'package:swesshome/utils/helpers/responsive.dart';


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
          return buildShimmerWidget();
        });
  }

  Container buildShimmerWidget() {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(vertical: Res.height(4)),
      padding: kMediumSymHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.black.withOpacity(0.24)),
        borderRadius: medBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              ShimmerWidget.rectangular(
                height: Res.height(24),
                width: Res.width(110),
              ),
              const Spacer(),
              ShimmerWidget.rectangular(
                height: Res.height(24),
                width: Res.width(180),
              )

            ],
          ),
          kHe16 ,
          ShimmerWidget.rectangular(
            height: Res.height(24),
            width: Res.width(200),
          ),
          kHe16 ,
          ShimmerWidget.rectangular(
            height: Res.height(24),
            width: Res.width(220),
          ),
          kHe16 ,
          ShimmerWidget.rectangular(
            height: Res.height(24),
            width: Res.width(200),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: ShimmerWidget.circular(
              height: Res.height(48),
              width: Res.width(120),
              shapeBorder: const RoundedRectangleBorder(borderRadius: lowBorderRadius),
            ),
          ),
        ],
      ),
    );
  }

}
