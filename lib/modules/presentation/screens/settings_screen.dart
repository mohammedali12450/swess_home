import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'languages_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = "SettingsScreen";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ChannelCubit isDarkModeSelectedCubit;

  @override
  Widget build(BuildContext context) {
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
        trailing: Icon((isEnglish) ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left),
      ),
    );
  }

  SizedBox buildThemeModeSetting() {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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
        title: Text(AppLocalizations.of(context)!.dark_mode),
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
                          right: Provider.of<LocaleProvider>(context).isArabic() ? 16.w : 0,
                          left: Provider.of<LocaleProvider>(context).isArabic() ? 0 : 16.w,
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
                  ThemeMode themeMode = themeProvider.getThemeModeViaIndex(index);
                  bool? isDarkMode ;
                  if(themeMode == ThemeMode.light)isDarkMode = false ;
                  if(themeMode == ThemeMode.dark)isDarkMode = true ;
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
}
