import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/widgets/shimmer_widget.dart';

class ImmediateShimmer extends StatelessWidget {
  const ImmediateShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (_, index) {
        return buildImmediateShimmer(context);
      },
    );
  }

  Container buildImmediateShimmer(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

    return Container(
      width: 1.sw,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.24)),
      ),
      child: Column(
        children: [
          Container(
            height: 300.h,
            width: 1.sw,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.12),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: ShimmerWidget.rectangular(
                  baseColor: isDark ? Colors.grey[400] : Colors.grey[300],
                  highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
                  height: 100.h,
                ),
              ),
              Expanded(
                flex: 2,
                child: ShimmerWidget.rectangular(
                  height: 100.h,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Container(
            width: 1.sw,
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            padding: EdgeInsets.only(
              right: isArabic ? 12.w : 0,
              left: !isArabic ? 12.w : 0,
            ),
            child: ShimmerWidget.rectangular(
              height: 20.h,
              width: 220.w,
            ),
          ),
          8.verticalSpace,
        ],
      ),
    );
  }
}
