import 'package:flutter/material.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/current_step_viewer.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class IntroductionScreen4 extends StatefulWidget {
  static const String id = "IntroductionScreen4";

  const IntroductionScreen4({Key? key}) : super(key: key);

  @override
  _IntroductionScreen4State createState() => _IntroductionScreen4State();
}

class _IntroductionScreen4State extends State<IntroductionScreen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        width: screenWidth,
        height: fullScreenHeight,
        padding: kLargeSymWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(introBackGroundImg4Path),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  color: Colors.transparent,
                  border: Border.all(color: white),
                  borderRadius: 5,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AuthenticationScreen(popAfterFinish: false)),
                        (route) => false);
                  },
                ),
              ),
              Spacer(),
              Container(
                width: Res.width(150),
                height: Res.width(150),
                child: CircleAvatar(
                  backgroundColor: white,
                  child: Icon(
                    Icons.send,
                    color: secondaryColor,
                    size: Res.width(100),
                  ),
                ),
              ),
              SizedBox(
                height: Res.height(64),
              ),
              ResText("أرسل طلبك العقاري إلى المكاتب",
                  textStyle: textStyling(S.s28, W.w6, C.wh)),
              kHe24,
              ResText(introductionBody4,
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
                color: white,
                onPressed: () {
                  // TODO : Process this state.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthenticationScreen(
                        popAfterFinish: false,
                      ),
                    ),
                  );
                },
                borderRadius: 8,
                shadow: [
                  BoxShadow(
                      color: white.withOpacity(0.15),
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      spreadRadius: 3),
                ],
              ),
              Spacer(),
              CurrentStepViewer(stepsCount: 5, currentStepIndex: 4),
              kHe12,
            ],
          ),
        ),
      ),
    );
  }
}
