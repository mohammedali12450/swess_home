import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/created_estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/faq_screen.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/screens/rating_screen.dart';
import 'package:swesshome/modules/presentation/screens/recent_estates_orders_screen.dart';
import 'package:swesshome/modules/presentation/screens/saved_estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/settings_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    // TODO: implement initState
    super.initState();
    _userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<UserLoginBloc, UserLoginState>(
            builder: (context, userLoginState) {
              User? user = BlocProvider.of<UserLoginBloc>(context).user;
              return Container(
                padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 12.w),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: !isDark
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
                child: (user == null)
                    ? Column(
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
                          kHe12,
                          Text(
                            AppLocalizations.of(context)!.sign_in,
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: AppColors.white,
                                    ),
                          ),
                          kHe8,
                          Text(
                            AppLocalizations.of(context)!.login_drawer_body,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: AppColors.white,
                                    ),
                            maxLines: 5,
                          ),
                          kHe16,
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(200.w, 56.h),
                                primary: isDark
                                    ? AppColors.primaryDark
                                    : AppColors.secondaryColor),
                            child: Text(
                              AppLocalizations.of(context)!.sign_in,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: AppColors.black),
                            ),
                            onPressed: () {
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
                      )
                    : Column(
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
                          kHe24,
                          Text(
                            user.userName + " " + user.lastName,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                          kHe4,
                          Text(
                            user.authentication,
                            textDirection: TextDirection.ltr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
              );
            },
          ),
          user != null
              ? RowInformation(
                  content: AppLocalizations.of(context)!.saved_estates,
                  iconData: Icons.bookmark_border_outlined,
                  onTap: () {
                    Navigator.pushNamed(context, SavedEstatesScreen.id);
                  },
                )
              : Container(),
          user != null
              ? RowInformation(
                  content: AppLocalizations.of(context)!.recent_created_estates,
                  iconData: Icons.article_outlined,
                  onTap: () {
                    Navigator.pushNamed(context, CreatedEstatesScreen.id);
                  },
                )
              : Container(),
          user != null
              ? RowInformation(
                  content: AppLocalizations.of(context)!.recent_created_orders,
                  iconData: Icons.history,
                  onTap: () {
                    Navigator.pushNamed(context, RecentEstateOrdersScreen.id);
                  },
                )
              : Container(),
          RowInformation(
            content: AppLocalizations.of(context)!.call_us,
            iconData: Icons.call_outlined,
            onTap: () {
              launch(
                "tel://" +
                    BlocProvider.of<SystemVariablesBloc>(context)
                        .systemVariables!
                        .normalCompanyPhoneNumber,
              );
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.rate_us,
            iconData: Icons.star_rate_outlined,
            onTap: () {
              Navigator.pushNamed(context, RatingScreen.id);
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.settings,
            iconData: Icons.settings_outlined,
            onTap: () {
              Navigator.pushNamed(context, SettingsScreen.id);
            },
          ),
          RowInformation(
            content: AppLocalizations.of(context)!.help,
            iconData: Icons.error_outline,
            onTap: () {
              Navigator.pushNamed(context, FAQScreen.id);
            },
          ),
          BlocBuilder<UserLoginBloc, UserLoginState>(
            builder: (context, userLoginState) {
              User? user = BlocProvider.of<UserLoginBloc>(context).user;
              if (user != null) {
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
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
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Future _logout() async {
    UserAuthenticationRepository userRep = UserAuthenticationRepository();
    if (UserSharedPreferences.getAccessToken() != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(),
        ),
      );
      return;
    }
    if (_userLoginBloc.user != null && _userLoginBloc.user!.token != null) {
      try {
        await userRep.logout(_userLoginBloc.user!.token!);
      } on ConnectionException catch (e) {
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
    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
    return;
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            margin: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  iconData,
                  size: 32.w,
                ),
                kWi8,
                Text(
                  content,
                ),
                Divider(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ],
            ),
          ),
          kHe12,
          Divider(
            color: Theme.of(context).colorScheme.onBackground,
            height: 1,
          ),
        ],
      ),
    );
  }
}
