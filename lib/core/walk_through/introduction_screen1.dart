import 'package:flutter/material.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/walk_through/introduction_screen2.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/current_step_viewer.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';


class IntroductionScreen1 extends StatefulWidget {
  static const String id = "IntroductionScreen1";

  const IntroductionScreen1({Key? key}) : super(key: key);

  @override
  _IntroductionScreen1State createState() => _IntroductionScreen1State();
}

class _IntroductionScreen1State extends State<IntroductionScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        width: screenWidth,
        height: fullScreenHeight,
        padding: kSmallSymWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(introBackGroundImg1Path),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: Res.height(64)),
                padding: EdgeInsets.symmetric(
                  horizontal: Res.width(16),
                ),
                alignment: Alignment.centerRight,
                width: inf,
                child: MyButton(
                  width: Res.width(108),
                  height: Res.height(32),
                  child: ResText(
                    "تخطي المقدمة",
                    textStyle: textStyling(S.s14, W.w4, C.wh),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (_) => AuthenticationScreen(popAfterFinish: false,)), (
                        route) => false);
                  },
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.white),
                  borderRadius: 5,
                ),
              ),
              Spacer(),
              ResText("أهلاً بكم",
                  textStyle: textStyling(S.s36, W.w6, C.wh),
                  maxLines: 10,
                  textAlign: TextAlign.center),
              kHe24,
              Container(
                width: Res.width(150),
                height: Res.width(150),
                child: CircleAvatar(
                  backgroundColor: AppColors.white,
                  backgroundImage: AssetImage(swessHomeIconPath),
                ),
              ),
              SizedBox(
                height: Res.height(64),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResText(
                    "swess home",
                    textStyle:
                    textStyling(S.s28, W.w6, C.wh, fontFamily: F.roboto),
                  ),
                  kWi8,
                  ResText("تطبيق", textStyle: textStyling(S.s28, W.w6, C.wh))
                ],
              ),
              kHe24,
              ResText(introductionBody1,
                  textStyle:
                  textStyling(S.s18, W.w6, C.wh).copyWith(height: 1.6),
                  maxLines: 10,
                  textAlign: TextAlign.center),
              kHe40,
              MyButton(
                child: ResText(
                  "التالي",
                  textStyle: textStyling(S.s20, W.w5, C.c2),
                ),
                width: Res.width(160),
                height: Res.height(64),
                color: AppColors.white,
                onPressed: () {
                  Navigator.pushNamed(context, IntroductionScreen2.id);
                  // TODO : Process this state.
                },
                borderRadius: 8,
                shadow: [
                  BoxShadow(
                      color: AppColors.white.withOpacity(0.15),
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      spreadRadius: 3),
                ],
              ),
              Spacer(),
              CurrentStepViewer(stepsCount: 5, currentStepIndex: 1),
              kHe12,
            ],
          ),
        ),
      ),
    );
  }
}
