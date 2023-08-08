import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/widgets/shimmer_widget.dart';

class CreatedEstatesShimmer extends StatelessWidget {
  const CreatedEstatesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (_, index) {
        return const BuildSavedEstatesShimmer();
      },
    );
  }
}

class BuildSavedEstatesShimmer extends StatelessWidget {
  const BuildSavedEstatesShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Stack(
              children: [
                Card(
                  elevation: 8,
                  color: Theme.of(context).colorScheme.background,
                  shape: const RoundedRectangleBorder(
                    borderRadius: lowBorderRadius,
                  ),
                  child: SizedBox(
                    // height: 150.h,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: ClipRRect(
                              borderRadius: lowBorderRadius,
                              child: Container(
                                width: 1.sw * (65 / 100),
                                height: 150.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: isDark
                                        ? AppColors.secondaryDark
                                        : AppColors.white,
                                  ),
                                  color: Theme.of(context).colorScheme.background,
                                ),
                                child: ShimmerWidget.rectangular(
                                  baseColor: isDark ? Colors.grey[400] : Colors.grey[300],
                                  highlightColor: isDark ? Colors.grey[300] : Colors.grey[200],
                                  height: 150.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: isArabic ? 0 : 5.w, right: !isArabic ? 0 : 5.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(4, (index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                    child: ShimmerWidget.rectangular(
                                      height: 12.h,
                                    ),
                                  ),
                                )),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ShimmerWidget.rectangular(
                      height: 16.h,
                      width: 16.w,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width:
                    MediaQuery.of(context).size.width * 0.4,
                    child: ShimmerWidget.rectangular(
                      height: 12.h,
                    ),
                  ),
                  const Text(" | "),
                  SizedBox(
                    width:
                    MediaQuery.of(context).size.width * 0.4,
                    child: ShimmerWidget.rectangular(
                      height: 12.h,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
