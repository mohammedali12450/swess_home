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
import 'package:swesshome/modules/presentation/screens/recent_estates_orders_screen.dart';
import 'package:swesshome/modules/presentation/screens/saved_estates_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import '../../../constants/assets_paths.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_bloc.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_event.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_bloc.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_event.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_state.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import '../../business_logic_components/cubits/notifications_cubit.dart';
import '../../data/models/governorates.dart';
import '../../data/models/user.dart';
import '../widgets/app_drawer.dart';
import '../widgets/fetch_result.dart';
import '../widgets/icone_badge.dart';
import '../widgets/shimmers/profile_shimmer.dart';
import 'created_estates_screen.dart';
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

  @override
  void initState() {
    super.initState();
    if (UserSharedPreferences.getAccessToken() != null) {
      _userDataBloc = UserDataBloc(UserAuthenticationRepository());
    }
    _onRefresh();
    governoratesBloc = BlocProvider.of<GovernoratesBloc>(context);
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
    bool isEnglish = ApplicationSharedPreferences.getLanguageCode() == "en";
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settings,
        ),
        leading: Builder(
          builder: (context) {
            return Container(
              margin: EdgeInsets.only(
                right: !isEnglish ? 8.w : 0,
                left: isEnglish ? 8.w : 0,
              ),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          _onRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (UserSharedPreferences.getAccessToken() == null) ...[
                // buildLanguageSetting,
                buildListTile(
                  isEnglish,
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.language_outlined),
                  ),
                  title: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.language_word),
                      const Spacer(),
                      Text(AppLocalizations.of(context)!.language),
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
                6.verticalSpace,
                buildThemeModeSetting(),
              ],
              if (UserSharedPreferences.getAccessToken() != null) ...[
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
                        return buildUserProfile(isDark, isEnglish);
                      }
                      return Container();
                    })
              ],
              //Spacer(),
              kHe16,
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "version ${ApplicationSharedPreferences.getVersionAppState()}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey),
                ),
              ),
              kHe20,
              kHe36,
            ],
          ),
        ),
      ),
      drawer: const Drawer(
        child: MyDrawer(),
      ),
    );
  }

  Widget buildUserProfile(isDark, isEnglish) {
    return Column(
      children: [
        buildProfileImage(isDark),

        // buildNotification
        buildListTile(
          isEnglish,
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
          title: Text(AppLocalizations.of(context)!.notifications),
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
          isEnglish,
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.language_outlined),
          ),
          title: Row(
            children: [
              Text(AppLocalizations.of(context)!.language_word),
              const Spacer(),
              Text(AppLocalizations.of(context)!.language),
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

        6.verticalSpace,
        const Divider(thickness: 0.2),
        6.verticalSpace,
        buildListTile(
          isEnglish,
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.bookmark_border_outlined),
          ),
          title: Text(AppLocalizations.of(context)!.saved_estates),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SavedEstatesScreen()));
          },
        ),
        buildListTile(
          isEnglish,
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.history),
          ),
          title: Text(AppLocalizations.of(context)!.recent_created_orders),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => RecentEstateOrdersScreen()));
          },
        ),
        buildListTile(
          isEnglish,
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.article_outlined),
          ),
          title: Text(AppLocalizations.of(context)!.recent_created_estates),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => CreatedEstatesScreen()));
          },
        ),

        //buildChangePassword,
        // buildListTile(
        //   isEnglish,
        //   icon: const Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 10.0),
        //     child: Icon(Icons.key_outlined),
        //   ),
        //   title: Text(AppLocalizations.of(context)!.change_password),
        //   onTap: () {},
        // ),

        buildDeleteMyAccount(isDark, isEnglish),
        buildLogout(isEnglish),
      ],
    );
  }

  SizedBox buildProfileImage(isDark) {
    return SizedBox(
      height: 320.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 190.h,
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
                        icon: Icon(
                          Icons.edit_outlined,
                          color: !isDark
                              ? AppColors.primaryColor
                              : AppColors.white,
                        ),
                        onPressed: () async {
                          final bool value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                      user: user!,
                                      governorates: governorates,
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
                    radius: 60.w,
                    backgroundColor: Colors.grey,
                    backgroundImage: const AssetImage(swessHomeIconPath),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 115.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user!.firstName! + " " + user!.lastName!,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: !isDark ? AppColors.black : AppColors.white),
                ),
                Text(
                  user?.email ?? "",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: !isDark
                          ? AppColors.hintColor
                          : AppColors.white.withOpacity(0.48)),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        user!.authentication!,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: !isDark
                                ? AppColors.primaryColor
                                : AppColors.primaryDark),
                      ),
                      Text(
                        "${user!.country ?? ""} "
                        "${user?.governorate == null ? " , ${user!.governorate}" : ""}",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: !isDark
                                ? AppColors.primaryColor
                                : AppColors.primaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  SizedBox buildThemeModeSetting() {
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

    return SizedBox(
      child: ListTile(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(Icons.invert_colors),
        ),
        title: Text(AppLocalizations.of(context)!.dark_mode_text),
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
                          right: Provider.of<LocaleProvider>(context).isArabic()
                              ? 16.w
                              : 0,
                          left: Provider.of<LocaleProvider>(context).isArabic()
                              ? 0
                              : 16.w,
                        ),
                        child: Text(
                          element.toString(),
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
    );
  }

  SizedBox buildDeleteMyAccount(isDark, isEnglish) {
    return SizedBox(
      width: 1.sw,
      height: 64.h,
      child: ListTile(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(Icons.account_circle_outlined),
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
            Text(
              AppLocalizations.of(context)!.delete_my_account,
            ),
            const Spacer(),
          ],
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
    MySnackBar.show(context, "User deleted");
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

  Widget buildLogout(isEnglish) {
    return BlocBuilder<UserLoginBloc, UserLoginState>(
      builder: (context, userLoginState) {
        if (UserSharedPreferences.getAccessToken() != null) {
          return SizedBox(
              width: 1.sw,
              height: 64.h,
              child: ListTile(
                leading: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.login),
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
                    Text(AppLocalizations.of(context)!.log_out),
                  ],
                ),
              ));
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
    //_userLoginBloc.user = null;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const NavigationBarScreen()));
    //Navigator.pushNamedAndRemoveUntil(context, AuthenticationScreen.id, (route) => false);
    return;
  }

  SizedBox buildListTile(isEnglish, {icon, onTap, title, trailing}) {
    return SizedBox(
      width: 1.sw,
      height: 64.h,
      child: ListTile(
        leading: icon,
        onTap: onTap,
        title: title,
        trailing: trailing,
      ),
    );
  }
}
