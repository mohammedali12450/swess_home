import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/main.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/pages/terms_of_use_page.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/contacts_screen.dart';
import 'package:swesshome/modules/presentation/screens/create_estate_immediately_screen.dart';
import 'package:swesshome/modules/presentation/screens/faq_screen.dart';
import 'package:swesshome/modules/presentation/pages/contact_us_body.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/app_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pages/intellectual_property_rights_page.dart';
import '../pages/terms_condition_page.dart';
import '../screens/navigation_bar_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late UserLoginBloc _userLoginBloc;
  final ChannelCubit isLogoutLoadingCubit = ChannelCubit(false);

  @override
  void initState() {
    super.initState();
    _userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Container(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (UserSharedPreferences.getAccessToken() == null)
              ? buildNullUserDrawer(isDark)
              : buildUserDrawer(isDark),
        ],
      )),
    );
  }

  buildUserDrawer(isDark) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: isDark ? AppColors.secondaryDark : AppColors.primaryColor,
            // color: isDark
            //     ? Theme.of(context).colorScheme.secondary :
            // Theme.of(context).colorScheme.primary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kHe24,
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      swessHomeIconPath,
                      width: 100.w,
                      height: 100.w,
                    ),
                  ),
                  kHe8,
                  // if (UserSharedPreferences.getAccessToken() != null) ...[
                  //   BlocBuilder<UserLoginBloc, UserLoginState>(
                  //       bloc: _userLoginBloc,
                  //       builder: (_, UserLoginState userEditState) {
                  //         return Column(
                  //           children: [
                  //             Text(
                  //               _userLoginBloc.user!.firstName! + " " + _userLoginBloc.user!.lastName!,
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyText2!
                  //                   .copyWith(
                  //                   color: Colors.white,
                  //                   fontWeight: FontWeight.w500),
                  //             ),
                  //             Text(
                  //               _userLoginBloc.user!.authentication!,
                  //               textDirection: TextDirection.ltr,
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyText2!
                  //                   .copyWith(
                  //                   color: Colors.white,
                  //                   fontWeight: FontWeight.w500),
                  //             )
                  //           ],
                  //         );
                  //       })
                  // ],
                  // kHe8,
                  // Text(
                  //   user.userName + " " + user.lastName,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline4!
                  //       .copyWith(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w500),
                  // ),
                  // kHe4,
                  // Text(
                  //   user.authentication,
                  //   textDirection: TextDirection.ltr,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodyText2!
                  //       .copyWith(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w500),
                  // )
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        kHe8,
        // RowInformation(
        //   content: AppLocalizations.of(context)!.rate_us,
        //   iconData: Icons.star_rate_outlined,
        //   onTap: () {
        //     showReview();
        //     // Navigator.pushNamed(context, RatingScreen.id);
        //   },
        // ),

        buildMainDrawer(isDark),
        BlocBuilder<UserLoginBloc, UserLoginState>(
          builder: (context, userLoginState) {
            return RowInformation(
              content: AppLocalizations.of(context)!.log_out,
              iconData: Icons.logout,
              onTap: () async {
                await showWonderfulAlertDialog(
                  context,
                  AppLocalizations.of(context)!.confirmation,
                  AppLocalizations.of(context)!.logout_confirmation,
                  removeDefaultButton: true,
                  width: 450.w,
                  dialogButtons: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(140.w, 56.h),
                          padding: EdgeInsets.zero),
                      child: BlocBuilder<ChannelCubit, dynamic>(
                        bloc: isLogoutLoadingCubit,
                        builder: (_, isLogoutLoading) {
                          return (isLogoutLoading)
                              ? SpinKitWave(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  size: 16.w,
                                )
                              : Text(
                                  AppLocalizations.of(context)!.log_out,
                                );
                        },
                      ),
                      onPressed: () async {
                        isLogoutLoadingCubit.setState(true);
                        await _logout();
                        isLogoutLoadingCubit.setState(false);
                        UserSharedPreferences.clear();
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(140.w, 56.h),
                          padding: EdgeInsets.zero),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  buildNullUserDrawer(isDark) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 12.w),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: isDark ? AppColors.secondaryDark : AppColors.primaryColor,
            // color: isDark
            //     ? Theme.of(context).colorScheme.primary
            //     : Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Image.asset(
                  swessHomeIconPath,
                  width: 100.w,
                  height: 100.w,
                ),
              ),
              kHe8,
              // Text(
              //   AppLocalizations.of(context)!.sign_in,
              //   style: Theme.of(context).textTheme.headline4!.copyWith(
              //         color: AppColors.white,
              //       ),
              // ),
              kHe8,
              Text(
                AppLocalizations.of(context)!.login_drawer_body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: AppColors.white,
                    ),
                maxLines: 5,
              ),
              kHe16,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200.w, 50.h),
                    primary: isDark
                        ? AppColors.primaryDark
                        : Theme.of(context).colorScheme.secondary),
                child: Text(
                  AppLocalizations.of(context)!.sign_in,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: AppColors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AuthenticationScreen(
                        popAfterFinish: true,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        buildMainDrawer(isDark),
      ],
    );
  }

  buildMainDrawer(isDark) {
    return Container(
      child: Column(
        children: [
          kHe8,
          RowInformation(
            content: AppLocalizations.of(context)!.rate_us,
            iconData: Icons.star_rate_outlined,
            onTap: () {
              showReview();
              // Navigator.pushNamed(context, RatingScreen.id);
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.invite_friends,
            iconData: Icons.people_alt_outlined,
            onTap: () {
              Share.share(AppLocalizations.of(context)!.upload_app +
                  '\n${ApplicationSharedPreferences.getDownloadUrl()}');
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.contact_us,
            iconData: Icons.people_outline,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ContacttUsBody()));
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.contacts,
            iconData: Icons.contacts,
            onTap: () {
              Navigator.of(context).pushNamed(ContactsScreen.id);
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.terms_condition,
            iconData: Icons.verified_user_outlined,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TermsAndConditionsPage()));
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.intellectual_property_rights,
            iconData: Icons.lightbulb_outline,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const IntellectualPropertyRightsPage()));
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.terms_of_use,
            iconData: Icons.security_outlined,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TermsOfUsePage()));
            },
          ),
          // RowInformation(
          //   content: AppLocalizations.of(context)!.call_us,
          //   iconData: Icons.call_outlined,
          //   onTap: () {
          //     launch(
          //       "tel://" +
          //           BlocProvider.of<SystemVariablesBloc>(context)
          //               .systemVariables!
          //               .normalCompanyPhoneNumber,
          //     );
          //   },
          // ),
          RowInformation(
            content: AppLocalizations.of(context)!.faq,
            iconData: Icons.error_outline,
            onTap: () {
              Navigator.pushNamed(context, FAQScreen.id);
            },
          ),
        ],
      ),
    );
  }

  Future _logout() async {
    UserAuthenticationRepository userRep = UserAuthenticationRepository();
    if (UserSharedPreferences.getAccessToken() == null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(),
        ),
      );
      return;
    } else if (UserSharedPreferences.getAccessToken() != null) {
      try {
        await userRep.logout(UserSharedPreferences.getAccessToken()!);
      } on ConnectionException {
        Navigator.pop(context);
        showWonderfulAlertDialog(
          context,
          AppLocalizations.of(context)!.error,
          AppLocalizations.of(context)!.check_your_internet_connection,
        );
        return;
      }
    }
    UserSharedPreferences.removeAccessToken();
    _userLoginBloc.user = null;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const NavigationBarScreen()));
    ApplicationSharedPreferences.setLoginPassed(false);
    // Navigator.pushNamedAndRemoveUntil(
    //     context, NavigationBarScreen.id, ModalRoute.withName('/'));
    return;
  }

  Future<void> showReview() async {
    Future.delayed(Duration.zero).then((_) {
      AppDialog.reviewDialog(context: navigatorKey.currentState!.context);
    });
  }
}

class RowInformation extends StatelessWidget {
  final IconData iconData;

  final String content;

  final Function() onTap;

  const RowInformation(
      {Key? key,
      required this.iconData,
      required this.content,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  iconData,
                  size: 25.w,
                ),
                kWi16,
                Text(
                  content,
                ),
                // Divider(
                //   color: Theme.of(context).colorScheme.onBackground,
                // ),
              ],
            ),
          ),
          kHe12,
          // Divider(
          //   color: Theme.of(context).colorScheme.onBackground,
          //   height: 1,
          // ),
        ],
      ),
    );
  }
}
