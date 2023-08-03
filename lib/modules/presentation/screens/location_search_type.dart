import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/presentation/screens/filter_search_screen.dart';
import 'package:swesshome/modules/presentation/screens/select_current_location.dart';
import 'package:swesshome/modules/presentation/screens/select_location_by_hand.dart';

import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/location.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/wonderful_alert_dialog.dart';

class LocationSearchType extends StatefulWidget {
  const LocationSearchType({Key? key}) : super(key: key);

  @override
  State<LocationSearchType> createState() => _LocationSearchTypeState();
}

class _LocationSearchTypeState extends State<LocationSearchType> {
  ChannelCubit patternCubit = ChannelCubit(null);
  ChannelCubit locationDetectedCubit = ChannelCubit(false);

  TextEditingController locationController = TextEditingController();

  late bool isDark;
  late bool isArabic;

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          backgroundColor:
          isDark ? const Color(0xff26282B) : AppColors.white,
          iconTheme:
          IconThemeData(color: isDark ? Colors.white : AppColors.black),
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.search,
            style:
            TextStyle(color: isDark ? Colors.white : AppColors.black),),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              searchForEstate(),
              buildGPSLocation(),
              buildListLocation(),
              buildRecentSearchedPlaces()
            ],
          ),
        ),
      ),
    );
  }

  Widget searchForEstate() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FilterSearchScreen()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 10),
        child: Container(
          height: 50.h,
          // width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? AppColors.lightGrey2Color : AppColors.lightblue,
                width: 1),
            borderRadius: lowBorderRadius,
          ),
          child: Text(AppLocalizations.of(context)!.estate_search),
        ),
      ),
    );
  }

  Widget buildGPSLocation() {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectCurrentLocation()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h,horizontal: 10),
        child: Container(
          height: 50.h,
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? AppColors.lightGrey2Color : AppColors.lightblue,
                width: 1),
            borderRadius: lowBorderRadius,
          ),
          child: Text(AppLocalizations.of(context)!.select_current_location),
        ),
      ),
    );
  }

  Widget buildListLocation() {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectLocationByHand()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 10),
        child: Container(
          height: 50.h,
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? AppColors.lightGrey2Color : AppColors.lightblue,
                width: 1),
            borderRadius: lowBorderRadius,
          ),
          child: Text(AppLocalizations.of(context)!.select_location_manual),
        ),
      ),
    );
  }

  List<LocationViewer>? getStoredRecentSearches() {
    // TODO: get data from shared preferences :
    List<String>? storedRecentSearches =
        RecentSearchesSharedPreferences.getRecentSearches();
    storedRecentSearches ??= [];
    List<LocationViewer> locationsViewers = [];
    List<Location>? locations =
        BlocProvider.of<LocationsBloc>(context).locations;
    for (var locationId in storedRecentSearches) {
      for (Location parentLocation in locations!) {
        for (Location childLocation in parentLocation.locations!) {
          if (childLocation.id == int.parse(locationId)) {
            locationsViewers.add(
              LocationViewer(
                  childLocation.name, parentLocation.name, childLocation.id),
            );
          }
        }
      }
    }
    return locationsViewers;
  }

  Widget buildRecentSearchedPlaces() {
    List<LocationViewer> recentPlaces = getStoredRecentSearches() ?? [];

    return SizedBox(
      height: 0.5.sh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (recentPlaces.isNotEmpty) ...[
            Row(
              children: [
                kWi12,
                Text(
                  AppLocalizations.of(context)!.recent_searches,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    await showWonderfulAlertDialog(
                      context,
                      AppLocalizations.of(context)!.confirmation,
                      AppLocalizations.of(context)!.clear_notifications_confirm,
                      removeDefaultButton: true,
                      dialogButtons: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(120.w, 56.h)),
                          child: Text(
                            AppLocalizations.of(context)!.yes,
                          ),
                          onPressed: () async {
                            await RecentSearchesSharedPreferences
                                .removeRecentSearches();
                            patternCubit.setState(null);
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(120.w, 56.h)),
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
                  child: Text(
                    AppLocalizations.of(context)!.clear_all,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                kWi12,
              ],
            ),
            kHe16,
            ListView.separated(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () async {
                      // set location name in location text field :
                      locationController.text =
                          recentPlaces.elementAt(index).getLocationName();
                      // set search data location id :
                      // widget.searchData.locationId =
                      //     recentPlaces.elementAt(index).id;
                      // change location detect state to detected :
                      locationDetectedCubit.setState(true);
                      // unfocused location textField :
                      FocusScope.of(context).unfocus();
                      // store search :
                      await saveAsRecentSearch(
                          recentPlaces.elementAt(index).id!);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20.h,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      width: inf,
                      child: Text(
                        recentPlaces.elementAt(index).getLocationName(),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return const Divider();
                },
                itemCount: recentPlaces.length)
          ],
          if (recentPlaces.isEmpty) ...[
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.no_recent_searches,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Future<void> saveAsRecentSearch(int locationId) async {
    List<String>? recentSearches =
        RecentSearchesSharedPreferences.getRecentSearches();
    recentSearches ??= [];
    if (recentSearches.contains(locationId.toString())) {
      recentSearches.remove(locationId.toString());
    }
    recentSearches.insert(0, locationId.toString());
    await RecentSearchesSharedPreferences.setRecentSearches(recentSearches);
  }
}
