import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';

import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_event.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_state.dart';
import '../../data/models/estate.dart';
import '../../data/models/search_data.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/estate_repository.dart';
import 'home_screen.dart';

class LanguagesScreen extends StatefulWidget {
  static const String id = "LanguagesScreen";

  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  late ChannelCubit selectedLanguageCubit;
  ChannelCubit isLanguageChangingCubit = ChannelCubit(false);
  EstateBloc estateBloc = EstateBloc(EstateRepository());
  List<Estate>? allEstates;
  late bool isDark ;

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    selectedLanguageCubit = ChannelCubit(
        Provider.of<LocaleProvider>(context).getLocale().languageCode == "ar"
            ? 0
            : 1);
    return BlocBuilder<ChannelCubit, dynamic>(
        bloc: isLanguageChangingCubit,
        builder: (_, isChanging) {
          // is Changing :
          if (isChanging) {
            return Scaffold(
              body: SizedBox(
                width: 1.sw,
                height: 1.sh,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        color: Theme.of(context).colorScheme.primary,
                        size: 0.2.sw,
                      ),
                      24.verticalSpace,
                      Text(AppLocalizations.of(context)!.changing_language),
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(46.0),
              child: AppBar(
                iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.black),
                backgroundColor: isDark ? const Color(0xff26282B) : AppColors.white,
                centerTitle: true,
                title: Text(AppLocalizations.of(context)!.language_word,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.black),),

              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Column(
                children: [
                  buildLanguage("العربية", 0),
                  buildLanguage("English", 1),
                  BlocListener<EstateBloc, EstateState>(
                    bloc: estateBloc,
                    listenWhen: (context, state) {
                      return state is EstatesFetchComplete;
                    },
                    listener: (_, estateFetchState) async {
                      if (estateFetchState is EstatesFetchComplete) {
                        allEstates = List.from(
                            estateFetchState.estateSearch.similarEstates)
                          ..addAll(
                              estateFetchState.estateSearch.identicalEstates);
                        await RecentSearchesSharedPreferences.removeSearches();
                        RecentSearchesSharedPreferences.setSearches(
                            allEstates!.take(5).toList());
                        estateSearchCubit.setState(
                            await RecentSearchesSharedPreferences
                                .getSearches());
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Column buildLanguage(String content, int index) {
    return Column(
      children: [
        SizedBox(
          width: 1.sw,
          height: 64.h,
          child: ListTile(
            title: Text(
              content,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontFamily: index == 0 ? "Tajawal" : null),
            ),
            trailing: BlocBuilder<ChannelCubit, dynamic>(
              bloc: selectedLanguageCubit,
              builder: (_, selectedLanguageIndex) {
                return (index == selectedLanguageIndex)
                    ? const Icon(Icons.check)
                    : const SizedBox.shrink();
              },
            ),
            onTap: () async {
              if (selectedLanguageCubit.state == index) return;
              // getting selected language code :
              String selectedLanguageCode = (index == 0) ? "ar" : "en";
              // set language changing loading true :
              isLanguageChangingCubit.setState(true);
              await Future.delayed(
                const Duration(seconds: 1),
              );
              // save selected language code :
              await saveSelectedLanguage(selectedLanguageCode);
              // set check for selected language :
              selectedLanguageCubit.setState(index);
              // change language :
              Provider.of<LocaleProvider>(context, listen: false).setLocale(
                Locale(selectedLanguageCode),
              );
              // set language changing loading false :
              isLanguageChangingCubit.setState(false);

              //change recent search list in home page to another language
              if (estateSearchFilterCubit.state != null) {
                getEstateList();
              }
            },
          ),
        ),
        const Divider(),
      ],
    );
  }

  Future saveSelectedLanguage(String languageCode) async {
    await ApplicationSharedPreferences.setLanguageCode(languageCode);
  }

  getEstateList() {
    estateBloc.add(EstatesFetchStarted(
        searchData: SearchData(
            locationId: estateSearchFilterCubit.state.length == 6
                ? int.tryParse(estateSearchFilterCubit.state.elementAt(5))
                : null,
            estateTypeId:
                int.tryParse(estateSearchFilterCubit.state.elementAt(3)),
            estateOfferTypeId:
                int.tryParse(estateSearchFilterCubit.state.elementAt(4)),
            priceMax: int.tryParse(estateSearchFilterCubit.state.elementAt(1)),
            priceMin: int.tryParse(estateSearchFilterCubit.state.elementAt(2)),
            sortType: "desc"),
        token: UserSharedPreferences.getAccessToken(),
        isAdvanced: false));
  }
}
