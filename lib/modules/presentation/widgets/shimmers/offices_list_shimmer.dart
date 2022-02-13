import 'package:flutter/material.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/widgets/shimmer_widget.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
      height: Res.height(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kWi24,
          Expanded(
            flex: 1,
            child: ShimmerWidget.rectangular(
              height: Res.height(80),
              width: Res.width(160),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kHe20 ,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Res.width(16),
                  ),
                  child: ShimmerWidget.rectangular(
                    height: Res.height(30),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Res.width(16),
                  ),
                  child: ShimmerWidget.rectangular(
                    height: Res.height(20),
                    width: Res.width(80),
                  ),
                ),
                kHe20 ,
              ],
            ),
          ),
          kWi24,
        ],
      ),
    );
  }
}
