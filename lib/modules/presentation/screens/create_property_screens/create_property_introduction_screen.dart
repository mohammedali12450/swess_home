import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'create_property_screen1.dart';

class CreatePropertyIntroductionScreen extends StatefulWidget {
  static const String id = "CreatePropertyIntroductionScreen";
  final int officeId;

  const CreatePropertyIntroductionScreen({Key? key, required this.officeId})
      : super(key: key);

  @override
  _CreatePropertyIntroductionScreenState createState() =>
      _CreatePropertyIntroductionScreenState();
}

class _CreatePropertyIntroductionScreenState
    extends State<CreatePropertyIntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screenWidth,
        decoration: const BoxDecoration(
          color: AppColors.black,
          image: DecorationImage(
              image: AssetImage(flatImagePath),
              fit: BoxFit.cover,
              opacity: 0.32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth / 2,
              child: Stack(
                children: [
                  Opacity(
                      child:
                          Image.asset(swessHomeIconPath, color: Colors.white),
                      opacity: 0.3),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Image.asset(swessHomeIconPath),
                    ),
                  )
                ],
              ),
            ),
            kHe40,
            ResText(
              "إنشاء العروض العقارية",
              textStyle: textStyling(S.s28, W.w7, C.wh),
            ),
            kHe16,
            SizedBox(
              width: screenWidth / 1.2,
              child: ResText(
                offerCreateIntroduction,
                maxLines: 10,
                textStyle: textStyling(S.s20, W.w5, C.wh).copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            kHe40,
            MyButton(
              width: Res.width(280),
              color: AppColors.white,
              child: ResText(
                "إنشاء عرض عقاري",
                textStyle: textStyling(S.s22, W.w6, C.c2),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePropertyScreen1(
                      officeId: widget.officeId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
