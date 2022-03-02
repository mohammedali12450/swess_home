




import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class NotificationCard extends StatelessWidget {
  final String title;

  final String body;

  final String date;

  final bool isNew;

  const NotificationCard(
      {Key? key, required this.title, required this.body, required this.date, required this.isNew})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            width: inf,
            padding: kMediumSymHeight,
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: thirdColor.withOpacity(0.18),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ResText(
                  title,
                  textAlign: TextAlign.right,
                  textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(
                      shadows: [BoxShadow(color: black.withOpacity(0.24), blurRadius: 4)]),
                ),
                kHe16,
                Padding(
                  padding: EdgeInsets.only(
                    left: Res.width(12),
                  ),
                  child: ResText(
                    body,
                    textAlign: TextAlign.right,
                    textStyle: textStyling(S.s15, W.w5, C.bl).copyWith(height: 1.8),
                    maxLines: 10,
                  ),
                ),
                kHe8,
                ResText(
                  date,
                  textStyle: textStyling(S.s14, W.w4, C.bl, fontFamily: F.roboto).copyWith(
                    color: black.withOpacity(0.48),
                  ),
                  textAlign: TextAlign.left,
                ),
                kHe12,
              ],
            ),
          ),
          if (isNew)
            Positioned(
              left: Res.width(16),
              top: Res.height(12),
              child: Container(
                height: Res.height(32),
                padding: EdgeInsets.symmetric(
                  horizontal: Res.width(8),
                ),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: black.withOpacity(0.24), offset: const Offset(0, 2), blurRadius: 4)
                    ]),
                child: Center(
                  child: ResText(
                    "إشعار جديد",
                    textStyle: textStyling(S.s12, W.w4, C.wh).copyWith(height: 1.8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
