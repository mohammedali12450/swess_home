import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/presentation/screens/estate_immediately_screen.dart';

import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../screens/create_order_screen.dart';

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
              height: getScreenHeight(context) / 1.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (UserSharedPreferences.getAccessToken() != null)
                    InkWell(
                      child: Column(
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 50,
                            color: AppColors.yellowColor,
                          ),
                          kHe12,
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
                  // if (UserSharedPreferences.getAccessToken() != null)
                  //   InkWell(
                  //     child: Column(
                  //       children: [
                  //         Icon(
                  //           Icons.local_offer_outlined,
                  //           size: 50,
                  //           color: AppColors.yellowColor,
                  //         ),
                  //         kHe12,
                  //         Text(
                  //           AppLocalizations.of(context)!.estate_offer_creating,
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .headline5!
                  //               .copyWith(color: AppColors.white),
                  //         ),
                  //       ],
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) =>
                  //               const CreatePropertyIntroductionScreen(
                  //                   officeId: 50288),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.house_outlined,
                          size: 50,
                          color: AppColors.yellowColor,
                        ),
                        kHe12,
                        Text(
                          AppLocalizations.of(context)!.estate_immediately,
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
                          builder: (_) => const EstateImmediatelyScreen(),
                        ),
                      );
                    },
                  ),
                  if (UserSharedPreferences.getAccessToken() == null)
                    SizedBox(
                      width: 150,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.login_new_features,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      });
}
