import 'package:flutter/material.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/walk_through/introduction_screen4.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/current_step_viewer.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class IntroductionScreen3 extends StatefulWidget {
  static const String id = "IntroductionScreen3";

  const IntroductionScreen3({Key? key}) : super(key: key);

  @override
  _IntroductionScreen3State createState() => _IntroductionScreen3State();
}

class _IntroductionScreen3State extends State<IntroductionScreen3> {
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
              image: AssetImage(introBackGroundImg3Path),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.white),
                  borderRadius: 5,
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (_) => AuthenticationScreen(popAfterFinish: false)), (
                        route) => false);
                  },
                ),
              ),
              Spacer(),
              Container(
                width: Res.width(150),
                height: Res.width(150),
                child: CircleAvatar(
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.add_to_queue,
                    color: AppColors.secondaryColor,
                    size: Res.width(100),
                  ),
                ),
              ),
              SizedBox(
                height: Res.height(64),
              ),
              ResText("قم بعرض عقاراتك في التطبيق",
                  textStyle: textStyling(S.s28, W.w6, C.wh) , textAlign: TextAlign.center,),
              kHe24,
              ResText(introductionBody3,
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
                  // TODO : Process this state.
                  Navigator.pushNamed(context, IntroductionScreen4.id);
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
              CurrentStepViewer(stepsCount: 5, currentStepIndex: 3),
              kHe12,
            ],
          ),
        ),
      ),
    );
  }
}
