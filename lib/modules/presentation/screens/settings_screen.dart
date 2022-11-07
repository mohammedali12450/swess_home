import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import 'languages_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = "SettingsScreen";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ChannelCubit isDarkModeSelectedCubit;
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
    final locale = Localizations.localeOf(context);
    bool isEnglish = locale.languageCode == "en";
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildLanguageSetting(),
                6.verticalSpace,
                const Divider(),
                6.verticalSpace,
                buildThemeModeSetting(),
                6.verticalSpace,
                _userLoginBloc.user != null
                    ? SizedBox(
                        width: 1.sw,
                        height: 64.h,
                        child: ListTile(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: isDark
                                        ? AppColors.secondaryDark
                                        : AppColors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    //this right here
                                    child: SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .are_you_sure,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 32,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    isLogoutLoadingCubit
                                                        .setState(true);
                                                    await _logout();
                                                    isLogoutLoadingCubit
                                                        .setState(false);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 50.h,
                                                    width: 110.w,
                                                    decoration: BoxDecoration(
                                                        color: isDark
                                                            ? Colors.grey
                                                            : AppColors
                                                                .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16)),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .yes,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 50.h,
                                                    width: 110.w,
                                                    decoration: BoxDecoration(
                                                        color: isDark
                                                            ? Colors.grey
                                                            : AppColors
                                                                .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16)),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          title: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.delete_my_account,
                              ),
                              const Spacer(),
                            ],
                          ),
                          trailing: Icon((isEnglish)
                              ? Icons.keyboard_arrow_right
                              : Icons.keyboard_arrow_left),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildLanguageSetting() {
    final locale = Localizations.localeOf(context);
    bool isEnglish = locale.languageCode == "en";
    return SizedBox(
      width: 1.sw,
      height: 64.h,
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, LanguagesScreen.id);
        },
        title: Row(
          children: [
            Text(AppLocalizations.of(context)!.language_word),
            const Spacer(),
            Text(AppLocalizations.of(context)!.language),
          ],
        ),
        trailing: Icon((isEnglish)
            ? Icons.keyboard_arrow_right
            : Icons.keyboard_arrow_left),
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
        title: Text(AppLocalizations.of(context)!.dark_mode_text),
        trailing: BlocBuilder(
          bloc: selectedThemeCubit,
          builder: (_, selectedTheme) {
            return SizedBox(
              width: 200.w,
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

  Future _logout() async {
    UserAuthenticationRepository userRep = UserAuthenticationRepository();
    if (_userLoginBloc.user != null && _userLoginBloc.user!.token != null) {
      try {
        await userRep.deleteUser(_userLoginBloc.user!.token!);
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
}
