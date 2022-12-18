import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/core/functions/screen_informations.dart';

import '../../../constants/colors.dart';
import '../screens/create_order_screen.dart';
import '../screens/create_property_screens/create_property_introduction_screen.dart';

void showBlurScreen({context}) {
  showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (BuildContext ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: getScreenHeight(context),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 50,
                          color: AppColors.yellowColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.create_estate_order,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateOrderScreen(),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 50,
                          color: AppColors.yellowColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.estate_offer_creating,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CreatePropertyIntroductionScreen(
                                  officeId: 1),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.call_end_outlined,
                          size: 50,
                          color: AppColors.yellowColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.estate_offer_creating,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CreatePropertyIntroductionScreen(
                                  officeId: 1),
                        ),
                      );
                    },
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        );
      });
}
