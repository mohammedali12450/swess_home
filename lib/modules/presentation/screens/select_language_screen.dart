import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/walk_through/introduction_screen1.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';

class SelectLanguageScreen extends StatefulWidget {
  static const String id = "SelectLanguageScreen";

  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  ChannelCubit selectedLanguageCubit = ChannelCubit(Language.none);
  ChannelCubit isLanguageSelectingCubit = ChannelCubit(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        color: Theme.of(context).colorScheme.secondary,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ...kBackgroundDrawings(context),
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: isLanguageSelectingCubit,
              builder: (_, isLanguageSelecting) {
                if (isLanguageSelecting) {
                  return Center(
                    child: SpinKitWave(
                      color: Theme.of(context).colorScheme.primary,
                      size: 0.2.sw,
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    64.verticalSpace,
                    Text(
                      AppLocalizations.of(context)!.select_language,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    48.verticalSpace,
                    BlocBuilder<ChannelCubit, dynamic>(
                      bloc: selectedLanguageCubit,
                      builder: (_, selectedLanguage) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            buildLanguageCard(selectedLanguage == Language.arabic, 'العربية', true),
                            buildLanguageCard(
                                selectedLanguage == Language.english, 'English', false),
                          ],
                        );
                      },
                    ),
                    120.verticalSpace,
                    ElevatedButton(
                      key: UniqueKey(),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(220.w, 64.h),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.ok,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () async {
                        if (selectedLanguageCubit.state == Language.none) {
                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!.select_language);
                          return;
                        }
                        isLanguageSelectingCubit.setState(true);
                        await ApplicationSharedPreferences.setIsLanguageSelected(true);
                        bool isArabic = selectedLanguageCubit.state == Language.arabic;
                        await ApplicationSharedPreferences.setLanguageCode(isArabic ? "ar" : "en");
                        Provider.of<LocaleProvider>(context, listen: false).setLocale(
                          Locale(isArabic ? "ar" : "en"),
                        );
                        await Future.delayed(
                          const Duration(seconds: 1),
                        );
                        Navigator.pushReplacementNamed(context, IntroductionScreen1.id);
                      },
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  InkWell buildLanguageCard(bool isSelected, String content, bool isArabic) {
    return InkWell(
      onTap: () async {
        selectedLanguageCubit.setState(isArabic ? Language.arabic : Language.english);
      },
      child: Container(
        width: 175.w,
        height: 160.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(color: Theme.of(context).colorScheme.onBackground),
        ),
        child: Center(
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontFamily: isArabic ? "Tajawal" : "Hind",
                color: isSelected
                    ? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.onBackground),
          ),
        ),
      ),
    );
  }
}
