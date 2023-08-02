import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/governorates_bloc/governorates_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import '../../../constants/assets_paths.dart';
import '../../../core/functions/screen_informations.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_bloc.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_event.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_bloc.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_event.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_state.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import '../../business_logic_components/cubits/notifications_cubit.dart';
import '../../data/models/governorates.dart';
import '../../data/models/user.dart';
import '../widgets/app/global_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/fetch_result.dart';
import '../widgets/icone_badge.dart';
import '../widgets/res_text.dart';
import '../widgets/shimmers/profile_shimmer.dart';
import '../widgets/will-pop-scope.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'languages_screen.dart';
import 'navigation_bar_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "SettingsScreen";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ChannelCubit isDarkModeSelectedCubit;

  //late UserLoginBloc _userLoginBloc;
  late GovernoratesBloc governoratesBloc;
  UserDataBloc? _userDataBloc;
  final ChannelCubit isLogoutLoadingCubit = ChannelCubit(false);
  List<Governorate>? governorates;
  User? user;
  late bool isEnglish, isDark;

  @override
  void initState() {
    super.initState();
    if (UserSharedPreferences.getAccessToken() != null) {
      _userDataBloc = UserDataBloc(UserAuthenticationRepository());
    }
    _onRefresh();
    governoratesBloc = BlocProvider.of<GovernoratesBloc>(context);
    BlocProvider.of<GovernoratesBloc>(context).add(GovernoratesFetchStarted());
  }

  _onRefresh() {
    if (UserSharedPreferences.getAccessToken() != null) {
      _userDataBloc!.add(
        UserDataStarted(token: UserSharedPreferences.getAccessToken()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    isEnglish = ApplicationSharedPreferences.getLanguageCode() == "en";
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return BackHomeScreen(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: GlobalAppbarWidget(
            isDark: isDark, title: AppLocalizations.of(context)!.settings),
      ),
      drawer: SizedBox(
        width: getScreenWidth(context) * (75 / 100),
        child: const Drawer(
          child: MyDrawer(),
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          _onRefresh();
        },
        child: UserSharedPreferences.getAccessToken() != null
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // buildLanguageSetting,
                    //MySnackBar.show(context, "تم التعديل بنجاح");

                    BlocBuilder<UserDataBloc, UserDataState>(
                        bloc: _userDataBloc,
                        builder: (_, UserDataState userEditState) {
                          if (userEditState is UserDataError) {
                            return SizedBox(
                                width: 1.sw,
                                height: 1.sh - 75.h,
                                child: FetchResult(
                                    content: AppLocalizations.of(context)!
                                        .error_happened_when_executing_operation));
                          }
                          if (userEditState is UserDataProgress) {
                            return const ProfileShimmer();
                          }
                          if (userEditState is UserDataComplete) {
                            user = userEditState.user;
                            if (user!.country != null &&
                                user!.country == "Syrian Arab Republic") {
                              governoratesBloc.add(GovernoratesFetchStarted());
                            }
                            return buildUserProfile();
                          }
                          return Container();
                        }),

                    //Spacer(),

                    kHe4,

                    const VersionWidget(),
                    // kHe20,
                    kHe36,
                  ],
                ),
              )
            : Column(
                children: [
                  kHe8,
                  buildListTile(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: const Icon(Icons.language_outlined),
                    ),
                    title: Row(
                      children: [
                        ResText(
                          AppLocalizations.of(context)!.language_word,
                          textAlign: TextAlign.start,
                          textStyle: Theme.of(context).textTheme.headline6,
                        ),
                        const Spacer(),
                        ResText(
                          AppLocalizations.of(context)!.language,
                          textAlign: TextAlign.start,
                          textStyle: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, LanguagesScreen.id);
                    },
                    trailing: Icon((isEnglish)
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_left),
                  ),
                  6.verticalSpace,
                  const Divider(),
                  10.verticalSpace,
                  buildThemeModeSetting(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(double.infinity, 50.h),
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
                      ),
                    ),
                  ),
                  kHe16,
                  const VersionWidget(),
                  kHe16,
                ],
              ),
      ),
    ));
  }

  Widget buildUserProfile() {
    return Column(
      children: [
        buildProfileImage(),
        const Divider(thickness: 0.2),
        // buildNotification
        buildListTile(
          icon: BlocBuilder<NotificationsCubit, int>(
              builder: (_, notificationsCount) {
            return IconBadge(
              icon: const Icon(
                Icons.notifications_outlined,
              ),
              itemCount: notificationsCount,
              right: 0,
              top: 5.h,
              hideZero: true,
            );
          }),
          title: ResText(
            AppLocalizations.of(context)!.notifications,
            textAlign: TextAlign.start,
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          onTap: () async {
            if (BlocProvider.of<UserLoginBloc>(context).user == null) {
              await showWonderfulAlertDialog(
                  context,
                  AppLocalizations.of(context)!.confirmation,
                  AppLocalizations.of(context)!.this_features_require_login,
                  removeDefaultButton: true,
                  dialogButtons: [
                    ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.sign_in,
                      ),
                      onPressed: () async {
                        await Navigator.pushNamed(
                            context, AuthenticationScreen.id);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  width: 400.w);
              return;
            }
            Navigator.pushNamed(context, NotificationScreen.id);
          },
          trailing: Icon((isEnglish)
              ? Icons.keyboard_arrow_right
              : Icons.keyboard_arrow_left),
        ),
        // buildLanguageSetting,
        buildListTile(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Icon(Icons.language_outlined),
          ),
          title: Row(
            children: [
              ResText(
                AppLocalizations.of(context)!.language_word,
                textAlign: TextAlign.start,
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
              ResText(
                AppLocalizations.of(context)!.language,
                textAlign: TextAlign.start,
                textStyle: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, LanguagesScreen.id);
          },
          trailing: Icon((isEnglish)
              ? Icons.keyboard_arrow_right
              : Icons.keyboard_arrow_left),
        ),

        buildThemeModeSetting(),

        // buildChangePassword,
        buildListTile(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Icon(Icons.password_outlined),
          ),
          title: Row(
            children: [
              ResText(
                AppLocalizations.of(context)!.change_password,
                textAlign: TextAlign.start,
                textStyle: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen()));
          },
          trailing: Icon((isEnglish)
              ? Icons.keyboard_arrow_right
              : Icons.keyboard_arrow_left),
        ),

        6.verticalSpace,
        const Divider(thickness: 0.2),
        6.verticalSpace,
        /*       buildListTile(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Icon(Icons.bookmark_border_outlined),
          ),
          title: ResText(
            AppLocalizations.of(context)!.saved_estates,
            textAlign: TextAlign.start,
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SavedEstatesScreen()));
          },
        ),
        buildListTile(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Icon(Icons.history),
          ),
          title: ResText(
            AppLocalizations.of(context)!.recent_created_orders,
            textAlign: TextAlign.start,
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RecentEstateOrdersScreen()));
          },
        ),
        buildListTile(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Icon(Icons.article_outlined),
          ),
          title: ResText(
            AppLocalizations.of(context)!.recent_created_estates,
            textAlign: TextAlign.start,
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CreatedEstatesScreen()));
          },
        ),
*/
        /// logging history
        // buildListTile(
        //   icon: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 10.w),
        //     child: const Icon(Icons.history_edu),
        //   ),
        //   title: ResText(
        //     AppLocalizations.of(context)!.logging_history,
        //     textAlign: TextAlign.start,
        //     textStyle: Theme.of(context).textTheme.headline6,
        //   ),
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (_) => const LoggingHistoryScreen()));
        //   },
        // ),

        //buildImmediatelyRent,
        // buildListTile(
        //   icon: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 10.w),
        //     child: const Icon(Icons.house_outlined),
        //   ),
        //   title: ResText(
        //     AppLocalizations.of(context)!.my_estate_immediately,
        //     textAlign: TextAlign.start,
        //     textStyle: Theme.of(context).textTheme.headline6,
        //   ),
        //   onTap: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (_) => const MyImmediatelyRentScreen()));
        //   },
        // ),

        buildDeleteMyAccount(),
        buildLogout(),
      ],
    );
  }

  Container buildProfileImage() {
    return Container(
      color: isDark ? AppColors.secondaryDark : AppColors.primaryColor,
      height: 220.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 130.h,
            //width: getScreenWidth(context),
            child: Stack(
              children: [
                BlocBuilder<GovernoratesBloc, GovernoratesState>(
                  bloc: governoratesBloc,
                  builder: (_, governoratesState) {
                    if (governoratesState is GovernoratesFetchComplete) {
                      governorates = governoratesState.governorates;
                    }
                    return Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.white,
                        ),
                        onPressed: () async {
                          final bool value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                      user: user!,
                                      governorates:
                                          governoratesBloc.governorates,
                                    )),
                          );
                          if (value) {
                            await _onRefresh();
                          }
                        },
                      ),
                    );
                  },
                ),
                Center(
                  child: CircleAvatar(
                    radius: 50.w,
                    backgroundColor: AppColors.white,
                    backgroundImage: const AssetImage(swessHomeIconPath),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ResText(
                  "${user!.firstName!} ${user!.lastName!}",
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: AppColors.white, fontSize: 20),
                ),
                // ResText(
                //   user?.email ?? "",
                //   textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                //       color: !isDark
                //           ? AppColors.hintColor
                //           : AppColors.white.withOpacity(0.48)),
                // ),
                kHe16,
                Directionality(
                  textDirection: TextDirection.ltr,

                  child: ResText(
                    user!.authentication!,
                    textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: isDark ? AppColors.white : AppColors.white),
                  ),
                  //ResText(
                  // "${user!.country ?? ""} "
                  // "${user?.governorate == null ? " , ${user!.governorate}" : ""}",
                  // textStyle: Theme.of(context)
                  //    .textTheme
                  //   .headline6!
                  //   .copyWith(
                  //     color: isDark ? AppColors.white : AppColors.white,
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildThemeModeSetting() {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    List<String> themes = [
      AppLocalizations.of(context)!.automatic,
      AppLocalizations.of(context)!.dark_mode,
      AppLocalizations.of(context)!.light_mode,
    ];

    ChannelCubit selectedThemeCubit = ChannelCubit(
      themes.elementAt(
        themeProvider.getModeIndex(),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: SizedBox(
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Icon(Icons.invert_colors),
          ),
          title: ResText(
            AppLocalizations.of(context)!.dark_mode_text,
            textAlign: TextAlign.start,
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          trailing: BlocBuilder(
            bloc: selectedThemeCubit,
            builder: (_, selectedTheme) {
              return SizedBox(
                width: 100.w,
                height: 64.h,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedTheme as String,
                  items: themes.map(
                    (String element) {
                      return DropdownMenuItem<String>(
                        value: element,
                        child: Container(
                          width: 1.sw,
                          margin: EdgeInsets.only(
                            right:
                                Provider.of<LocaleProvider>(context).isArabic()
                                    ? 16.w
                                    : 0,
                            left:
                                Provider.of<LocaleProvider>(context).isArabic()
                                    ? 0
                                    : 16.w,
                          ),
                          child: ResText(
                            element.toString(),
                            textAlign: TextAlign.start,
                            textStyle: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (selectedElement) async {
                    int index = themes.indexOf(selectedElement!);
                    ThemeMode themeMode =
                        themeProvider.getThemeModeViaIndex(index);
                    bool? isDarkMode;
                    if (themeMode == ThemeMode.light) isDarkMode = false;
                    if (themeMode == ThemeMode.dark) isDarkMode = true;
                    await ApplicationSharedPreferences.setIsDarkMode(
                      isDarkMode,
                    );
                    themeProvider.setTheme(themeMode);
                    selectedThemeCubit.setState(
                      themes.elementAt(
                        themeProvider.getModeIndex(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildDeleteMyAccount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: SizedBox(
        width: 1.sw,
        // height: 64.h,
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Icon(Icons.account_circle_outlined),
          ),
          onTap: () async {
            await showWonderfulAlertDialog(
                context,
                AppLocalizations.of(context)!.caution,
                AppLocalizations.of(context)!.are_you_sure,
                // bodyTextStyle: TextStyle(
                //     fontSize: 18, color: isDark ? Colors.white : Colors.black),
                removeDefaultButton: true,
                dialogButtons: [
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                    ),
                    onPressed: () async {
                      isLogoutLoadingCubit.setState(true);
                      await _logoutAfterDelete();
                      isLogoutLoadingCubit.setState(false);
                      //UserSharedPreferences.clear();
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]);
          },
          title: Row(
            children: [
              ResText(
                AppLocalizations.of(context)!.delete_my_account,
                textAlign: TextAlign.start,
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future _logoutAfterDelete() async {
    UserAuthenticationRepository userRep = UserAuthenticationRepository();
    if (UserSharedPreferences.getAccessToken() != null) {
      try {
        await userRep.deleteUser(UserSharedPreferences.getAccessToken()!);
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
    //_userLoginBloc.user = null;
    MySnackBar.show(context, "تم حذف الحساب بنجاح");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(
            popAfterFinish: false,
          ),
        ),
        (route) => false);
    return;
  }

  Widget buildLogout() {
    return BlocBuilder<UserLoginBloc, UserLoginState>(
      //bloc: ,
      builder: (context, userLoginState) {
        if (UserSharedPreferences.getAccessToken() != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
                width: 1.sw,
                height: 64.h,
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: const Icon(Icons.login),
                  ),
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
                            //UserSharedPreferences.clear();
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
                  title: Row(
                    children: [
                      ResText(
                        AppLocalizations.of(context)!.log_out,
                        textAlign: TextAlign.start,
                        textStyle: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                )),
          );
        }
        return Container();
      },
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
    ApplicationSharedPreferences.setLoginPassed(false);
    MySnackBar.show(context, " تم تسجيل الخروج بنجاح");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => NavigationBarScreen()));
    //_userLoginBloc.user = null;
    //Navigator.pushNamedAndRemoveUntil(context, AuthenticationScreen.id, (route) => false);
    return;
  }

  Widget buildListTile({icon, onTap, title, trailing}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: SizedBox(
        width: 1.sw,
        height: 45.h,
        child: ListTile(
          leading: icon,
          onTap: onTap,
          title: title,
          trailing: trailing,
        ),
      ),
    );
  }
}

class VersionWidget extends StatelessWidget {
  const VersionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ResText(
        "version 2.0 (Demo)",
        // "version ${ApplicationSharedPreferences.getVersionAppState()}",
        textAlign: TextAlign.center,
        textStyle:
            Theme.of(context).textTheme.headline6!.copyWith(color: Colors.grey),
      ),
    );
  }
}
