import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shimmer_widget.dart';


class LocationsShimmer extends StatelessWidget {
  const LocationsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random rnd = Random(); 
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
        itemCount: 30,
        itemBuilder: (_ , index){
        return Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 16.w),
            child: ShimmerWidget.rectangular(height: 16.h,width: (100 + rnd.nextInt(200)).w,));
    });
  }

}
