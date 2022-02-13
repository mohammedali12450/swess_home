import 'dart:math';
import 'package:flutter/material.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
            padding: EdgeInsets.symmetric(vertical: Res.height(16)),
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: Res.width(16)),
            child: ShimmerWidget.rectangular(height: Res.height(16),width: Res.width(100 + rnd.nextInt(200)),));
    });
  }

}
