import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/widgets/current_step_viewer.dart';
import '../../modules/presentation/screens/authentication_screen.dart';
import 'introduction_screen1.dart';
import 'introduction_screen3.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroductionScreen2 extends StatefulWidget {
  static const String id = "IntroductionScreen2";

  const IntroductionScreen2({Key? key}) : super(key: key);

  @override
  _IntroductionScreen2State createState() => _IntroductionScreen2State();
}

class _IntroductionScreen2State extends State<IntroductionScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      horizontal: 16.w,
                    ),
                    alignment: Alignment.centerRight,
                    width: inf,
                    child: InkWell(
                      onTap: () {
                        //Navigator.pushNamed(context, IntroductionScreen1.id);
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
                          color: Colors.transparent,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onBackground,
                            width: 0.5,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
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
                  SizedBox(
                    height: 50.h,
                  ),
                  Icon(
                    Icons.maps_home_work_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 140.w,
                  ),
                  40.verticalSpace,
                  Text(
                    AppLocalizations.of(context)!.introductionTitle2,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  kHe24,
                  Text(
                    AppLocalizations.of(context)!.introductionBody2,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.6),
                    maxLines: 10,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(180.w, 64.h),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.next,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, IntroductionScreen3.id);
                    },
                  ),
                  const Spacer(),
                  const CurrentStepViewer(stepsCount: 5, currentStepIndex: 2),
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
