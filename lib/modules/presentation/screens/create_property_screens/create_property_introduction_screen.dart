import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_screen1.dart';

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
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 1.sw,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              image: const DecorationImage(
                  image: AssetImage(flatImagePath),
                  fit: BoxFit.cover,
                  opacity: 0.32),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 0.5.sw,
                  child: Stack(
                    children: [
                      Opacity(
                        child: Image.asset(
                          swessHomeIconPath,
                          color: Colors.white,
                        ),
                        opacity: 0.3,
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: Image.asset(swessHomeIconPath),
                        ),
                      )
                    ],
                  ),
                ),
                40.verticalSpace,
                Text(
                  AppLocalizations.of(context)!.estate_offer_creating,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    AppLocalizations.of(context)!.create_estate_introduction,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white),
                  ),
                ),
                40.verticalSpace,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(220.w, 64.h),
                    primary: AppColors.secondaryColor,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.start_now,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CreatePropertyScreen1(officeId: widget.officeId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 42.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: 1.sw,
              alignment:
                  isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                  size: 28.w,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
