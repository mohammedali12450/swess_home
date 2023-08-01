import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';

class RowInformation2 extends StatelessWidget {
  final Function() onTap;

  final String title;
  final bool isDark;
  final String? content;

  final Widget? widgetContent;

  final bool withBottomDivider;

  const RowInformation2({
    Key? key,
    required this.onTap,
    required this.title,
    this.widgetContent,
    this.withBottomDivider = true,
    this.content, required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResText(
                    title,
                    textStyle: getTitleTextStyle(isDark),
                  ),
                  5.horizontalSpace,
                  (widgetContent != null)
                      ? widgetContent!
                      : Expanded(
                    child: ResText(
                      content ?? "",
                      textStyle: getSubtitleTextStyle(isDark),
                      textAlign: TextAlign.start,
                      maxLines: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
TextStyle getTitleTextStyle(bool isDark) { return GoogleFonts.cairo(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color:isDark?Colors.white:Colors.black
);}

TextStyle getSubtitleTextStyle(bool isDark){return GoogleFonts.cairo(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color:isDark?Colors.white:Colors.black

);}