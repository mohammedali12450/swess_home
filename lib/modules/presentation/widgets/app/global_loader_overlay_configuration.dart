import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:swesshome/constants/colors.dart';

class GlobalLoaderOverlayConfiguration extends StatelessWidget {
  final Widget child;

  const GlobalLoaderOverlayConfiguration({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.2,
      overlayColor: Colors.black,
      overlayWidget: Center(
        child: SpinKitWave(
          color: AppColors.primaryColor,
          size: 50.0.sp,
        ),
      ),
      child: child,
    );
  }
}
