import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/walk_through/introduction_screen2.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/current_step_viewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Container(
        width: 1.sw,
        height: 1.sh,
        padding: kSmallSymWidth,
        color: Theme.of(context).colorScheme.secondary,
        child: Stack(
          children: [
            ...kBackgroundDrawings(context),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 64.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                    ),
                    alignment: Alignment.centerRight,
                    width: inf,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AuthenticationScreen(
                                popAfterFinish: false,
                              ),
                            ),
                                (route) => false);
                      },
                      child: Container(
                        width: 80.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent ,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onBackground ,
                            width: 0.5
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(6)) ,

                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.skip,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),

                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(AppLocalizations.of(context)!.welcome,
                      style: Theme.of(context).textTheme.headline3,
                      maxLines: 10,
                      textAlign: TextAlign.center),
                  kHe24,
                  SizedBox(
                    width: 0.5.sw,
                    child: Stack(
                      children: [
                        Opacity(
                            child: Image.asset(swessHomeIconPath, color: Colors.black),
                            opacity: 0.64),
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: Image.asset(swessHomeIconPath),
                          ),
                        ),
                      ],
                    ),
                  ),
                  64.verticalSpace,
                  Text(
                    AppLocalizations.of(context)!.application_name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  kHe24,
                  Text(
                    AppLocalizations.of(context)!.introductionBody1,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.6),
                    maxLines: 10,
                    textAlign: TextAlign.center,
                  ),
                  kHe40,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(180.w , 64.h)  ,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.next,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, IntroductionScreen2.id);
                      // TODO : Process this state.
                    },
                  ),
                  const Spacer(),
                  const CurrentStepViewer(stepsCount: 5, currentStepIndex: 1),
                  kHe12,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
