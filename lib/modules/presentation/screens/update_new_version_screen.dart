import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/walk_through/introduction_screen1.dart';
import 'package:swesshome/modules/presentation/screens/select_language_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/design_constants.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateVersionScreen extends StatefulWidget {
  static const String id = "SelectLanguageScreen";

  const UpdateVersionScreen({Key? key}) : super(key: key);

  @override
  _UpdateVersionScreenState createState() => _UpdateVersionScreenState();
}

class _UpdateVersionScreenState extends State<UpdateVersionScreen> {
  bool isIntroductionScreenPassed = false;

  @override
  void initState() {
    isIntroductionScreenPassed =
        ApplicationSharedPreferences.getWalkThroughPassState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 1.sw,
      height: 1.sh,
      padding: kSmallSymWidth,
      color: Theme.of(context).colorScheme.secondary,
      child: Stack(children: [
        ...kBackgroundDrawings(context),
        Center(
          child: buildDialog(),
        ),
      ]),
    ));
  }

  Widget buildDialog() {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.caution),
      titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
      actionsOverflowButtonSpacing: 20,
      actions: [
        /* ElevatedButton(
          child: const Text("later"
              // AppLocalizations.of(context)!.cancel,
              ),
          onPressed: () {
            // Navigator.pop(context);
            bool isLanguageSelected =
                ApplicationSharedPreferences.getIsLanguageSelected();
            if (!isLanguageSelected) {
              Navigator.pop(context);
              Navigator.pushNamed(context, SelectLanguageScreen.id);
            }
            // Language has selected before:
            if (isIntroductionScreenPassed) {
              //Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            } else {
              Navigator.pop(context);
              Navigator.pushNamed(context, IntroductionScreen1.id);
            }
          },
        ),*/
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.update),
          onPressed: () {
            launch(
              "https://play.google.com/store/apps/details?id=com.real_estate.realestatecustomer",
            );
          },
        ),
      ],
      content: Text(AppLocalizations.of(context)!.has_update),
      contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }
}
