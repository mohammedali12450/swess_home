import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import '../shimmer_widget.dart';

class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random rnd = Random();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (_, index) {
        return Container(
          width: inf,
          padding: kMediumSymHeight,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.32)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          margin: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerWidget.circular(
                height: 28.h,
                width: (150 + rnd.nextInt(200)).w,
                shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              kHe24,
              ShimmerWidget.circular(
                height: 20.h,
                width: (350 + rnd.nextInt(50)).w,
                shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                highlightColor: Colors.grey[200],
                baseColor: Colors.grey[300],
              ),
              kHe12 ,
              ShimmerWidget.circular(
                height: 20.h,
                width: (100 + rnd.nextInt(100)).w,
                shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                highlightColor: Colors.grey[200],
                baseColor: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }
}
