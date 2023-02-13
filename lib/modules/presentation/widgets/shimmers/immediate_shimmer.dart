import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/widgets/shimmer_widget.dart';

import '../../../../constants/design_constants.dart';

class ImmediateShimmer extends StatelessWidget {
  const ImmediateShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return SliverToBoxAdapter(
      child:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ShimmerWidget.rectangular(
              baseColor: isDark ? Colors.grey[400] : Colors.grey[300],
              highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
              height: 300.h,
            ),
            ShimmerWidget.rectangular(
              height: 75.h,
            ),
            kHe36,
            ShimmerWidget.rectangular(
              baseColor: isDark ? Colors.grey[400] : Colors.grey[300],
              highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
              height: 300.h,
            ),
            ShimmerWidget.rectangular(
              height: 75.h,
            ),
          ],
        ),
      ),
    );
  }
}
