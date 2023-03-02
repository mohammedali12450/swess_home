import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import '../../../../core/functions/screen_informations.dart';
import '../../../data/providers/theme_provider.dart';
import '../shimmer_widget.dart';

class HomeCardShimmer extends StatelessWidget {
  const HomeCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Row(
      children: [
        Column(
          children: [
            ShimmerWidget.rectangular(
              height: 320.h,
              width: getScreenWidth(context) * (60 / 100),
              baseColor: isDark ? Colors.grey[500] : Colors.grey[400],
              highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
            ),
            // kHe24,
            ShimmerWidget.rectangular(
              height: 160.h,
              width: getScreenWidth(context) * (60 / 100),
              baseColor: isDark ? Colors.grey[400] : Colors.grey[300],
              highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
            ),
          ],
        ),
        kWi12,
        Column(
          children: [
            ShimmerWidget.rectangular(
              height: 320.h,
              width: getScreenWidth(context) * (33 / 100),
              baseColor: isDark ? Colors.grey[500] : Colors.grey[400],
              highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
            ),
            // kHe24,
            ShimmerWidget.rectangular(
              height: 160.h,
              width: getScreenWidth(context) * (33 / 100),
              baseColor: isDark ? Colors.grey[400] : Colors.grey[300],
              highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
            ),
          ],
        ),
      ],
    );
  }
}
