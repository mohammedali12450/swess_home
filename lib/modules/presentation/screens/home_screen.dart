import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/main.dart';
import 'package:swesshome/modules/presentation/screens/rating_screen.dart';
import 'package:swesshome/modules/presentation/widgets/home_estate_card.dart';
import 'package:swesshome/utils/helpers/app_dialog.dart';
import 'package:swesshome/utils/helpers/automatic_show_review.dart';

import '../../../constants/assets_paths.dart';
import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../core/functions/screen_informations.dart';
import '../../../core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_event.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_state.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/bloc/rating_bloc/rating_bloc.dart';
import '../../business_logic_components/bloc/rating_bloc/rating_event.dart';
import '../../business_logic_components/bloc/rating_bloc/rating_state.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../business_logic_components/cubits/notifications_cubit.dart';
import '../../data/models/estate.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/search_data.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/estate_repository.dart';
import '../../data/repositories/rating_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/icone_badge.dart';
import '../widgets/wonderful_alert_dialog.dart';
import 'authentication_screen.dart';
import 'estates_screen.dart';
import 'filter_search_screen.dart';
import 'location_search_type.dart';
import 'notifications_screen.dart';
import 'office_search_screen.dart';

List<Estate> estateSearchList = [];
ChannelCubit estateSearchCubit = ChannelCubit(estateSearchList);
List<String>? estateSearchFilter = [];
ChannelCubit estateSearchFilterCubit = ChannelCubit(estateSearchFilter);

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //late LastVisitedEstatesBloc lastVisitedEstatesBloc;

  late bool isArabic;
  late bool isDark;
  LocationViewer? selectedLocation;
  RegionViewer? selectedRegion;
  late List<EstateType> estatesTypes;
  String estateTypeName = "";
  String priceMaxMin = "";
  String estateOfferName = "";
  int? date;
  ChannelCubit locationNameCubit = ChannelCubit("");
  ChannelCubit isAreaSearchCubit = ChannelCubit(false);
  ChannelCubit selectedRatingCubit = ChannelCubit(-1);
  EstateBloc estateBloc = EstateBloc(EstateRepository());
  List<Estate>? allEstates;
  final RatingBloc _ratingBloc = RatingBloc(RatingRepository());

  @override
  void initState() {
    super.initState();
    automaticShowReview();
    getEstateSearch();
    RecentSearchesSharedPreferences.setDateRefreshRecent(
        int.parse(DateFormat("dd").format(DateTime.now())));
    date = RecentSearchesSharedPreferences.getDateRefreshRecent();
    // for (int i = 0; i < estateSearchFilterCubit.state.length; i++) {
    //   print(estateSearchFilterCubit.state.elementAt(i));
    // }
    bool isUpdateList = RecentSearchesSharedPreferences.getIsUpdateRecent();
    if (estateSearchFilterCubit.state != null &&
        estateSearchFilterCubit.state.isNotEmpty &&
        !isUpdateList &&
        (date == 7 || date == 16 || date == 21 || date == 28)) {
      getEstateList();
      RecentSearchesSharedPreferences.setIsUpdateRecent(true);
    } else if (date != 7 || date != 16 || date != 21 || date != 28) {
      RecentSearchesSharedPreferences.setIsUpdateRecent(false);
    }
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

  getEstateSearchFilterCubitAtt() {
    String max =
        estateSearchFilterCubit.state.elementAt(1) == "999999999999999999"
            ? AppLocalizations.of(context)!.max_price
            : estateSearchFilterCubit.state.elementAt(1);
    String min = estateSearchFilterCubit.state.elementAt(2) == "1"
        ? AppLocalizations.of(context)!.min_price
        : estateSearchFilterCubit.state.elementAt(2);
    priceMaxMin = " ( $max , $min ) ";

    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    for (int i = 0; i < estatesTypes.length; i++) {
      if (estateSearchFilterCubit.state.elementAt(3) ==
          estatesTypes.elementAt(i).id.toString()) {
        if (estatesTypes.elementAt(i).name.toString().split("|").first ==
                "House" ||
            estatesTypes.elementAt(i).name.toString().split("|").first ==
                "بيت") {
          estateTypeName = AppLocalizations.of(context)!.house;
        } else if (estatesTypes.elementAt(i).name.toString().split("|").first ==
                "Shop" ||
            estatesTypes.elementAt(i).name.toString().split("|").first ==
                "محل") {
          estateTypeName = AppLocalizations.of(context)!.shop;
        } else if (estatesTypes.elementAt(i).name.toString().split("|").first ==
                "Farm" ||
            estatesTypes.elementAt(i).name.toString().split("|").first ==
                "مزرعة") {
          estateTypeName = AppLocalizations.of(context)!.farm;
        } else if (estatesTypes.elementAt(i).name.toString().split("|").first ==
                "Land" ||
            estatesTypes.elementAt(i).name.toString().split("|").first ==
                "أرض") {
          estateTypeName = AppLocalizations.of(context)!.land;
        } else {
          estateTypeName = AppLocalizations.of(context)!.villa;
        }
      }
    }

    estateOfferName = estateSearchFilterCubit.state.elementAt(4) == "1"
        ? AppLocalizations.of(context)!.sell
        : AppLocalizations.of(context)!.rent;
  }

  getEstateSearch() async {
    estateSearchCubit
        .setState(await RecentSearchesSharedPreferences.getSearches());
    estateSearchFilterCubit
        .setState(RecentSearchesSharedPreferences.getRecentSearchesFilter());
  }

  @override
  Widget build(BuildContext context) {
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        actions: [
          InkWell(
            child: BlocBuilder<NotificationsCubit, int>(
              builder: (_, notificationsCount) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: isArabic ? 12.w : 0, right: isArabic ? 0 : 12.w),
                  child: IconBadge(
                    icon: const Icon(
                      Icons.notifications_outlined,
                    ),
                    itemCount: notificationsCount,
                    right: 0,
                    top: 5.h,
                    hideZero: true,
                  ),
                );
              },
            ),
            onTap: () async {
              if (UserSharedPreferences.getAccessToken() == null) {
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildLocationContainer(context),
            if (date == 7 || date == 16 || date == 21)
              BlocListener<EstateBloc, EstateState>(
                bloc: estateBloc,
                listenWhen: (context, state) {
                  return state is EstatesFetchComplete;
                },
                listener: (_, estateFetchState) async {
                  if (estateFetchState is EstatesFetchComplete) {
                    allEstates = List.from(
                        estateFetchState.estateSearch.similarEstates)
                      ..addAll(estateFetchState.estateSearch.identicalEstates);
                    await RecentSearchesSharedPreferences.removeSearches();
                    RecentSearchesSharedPreferences.setSearches(
                        allEstates!.take(5).toList());
                    estateSearchCubit.setState(
                        await RecentSearchesSharedPreferences.getSearches());
                  }
                },
                child: const SizedBox.shrink(),
              ),
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: estateSearchFilterCubit,
              builder: (_, estateSearchFilterState) {
                if (estateSearchFilterState == null) {
                  return Container(
                    alignment: Alignment.center,
                    child: buildEmptyScreen(context),
                  );
                }
                if (estateSearchFilterState.isNotEmpty) {
                  getEstateSearchFilterCubitAtt();
                }
                return BlocBuilder<ChannelCubit, dynamic>(
                    bloc: estateSearchCubit,
                    builder: (_, estateSearchState) {
                      return Center(
                          child:
                              UserSharedPreferences.getAccessToken() == null ||
                                      estateSearchState.isEmpty
                                  ? Container(
                                      height: 0.9.sh,
                                      alignment: Alignment.center,
                                      child: buildEmptyScreen(context),
                                    )
                                  : buildEstateList(context));
                    });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.w),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: GestureDetector(
              child: Card(
                color: AppColors.primaryColor,
                elevation: 4,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: AppColors.yellowColor,
                    width: 2,
                  ),
                ),
                child: Container(
                  width: 100.w,
                  alignment: Alignment.center,
                  height: 72.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      AppLocalizations.of(context)!.search,
                      style: TextStyle(color: AppColors.white, fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: lowBorderRadius,
                      ),
                      child: Padding(
                        padding: kTinyAllPadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 15.verticalSpace,
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const FilterSearchScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.home_work_outlined),
                                    kWi16,
                                    Text(
                                      AppLocalizations.of(context)!
                                          .estate_search,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                )),
                            // const Divider(
                            //   indent: 20,
                            //   thickness: 0.1,
                            //   endIndent: 20,
                            // ),
                            // TextButton(
                            //     onPressed: () {
                            //       Navigator.pop(context);
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (_) =>
                            //               const OfficeSearchScreen(),
                            //         ),
                            //       );
                            //     },
                            //     child: Row(
                            //       children: [
                            //         const Icon(Icons.house_outlined),
                            //         kWi16,
                            //         Text(
                            //           AppLocalizations.of(context)!
                            //               .search_for_estate_agent,
                            //           style:
                            //               Theme.of(context).textTheme.headline5,
                            //         ),
                            //       ],
                            //     )),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      drawer: SizedBox(
        width: getScreenWidth(context) * (75 / 100),
        child: const Drawer(
          child: MyDrawer(),
        ),
      ),
    );
  }

  Widget buildLocationContainer(context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LocationSearchType()));
      },
      child: Padding(
        padding: kLargeSymHeight,
        child: Container(
          height: 60.h,
          width: 1.sw,
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
                color: !isDark ? Colors.black38 : AppColors.yellowDarkColor,
                width: 1),
            borderRadius: lowBorderRadius,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                offset: const Offset(0, 2),
                blurRadius: 4,
              )
            ],
          ),
          margin: EdgeInsets.only(
            bottom: 8.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Icon(
                  Icons.search_outlined,
                  color: AppColors.primaryColor,
                  size: 25.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: !isArabic ? 8.w : 0, right: isArabic ? 8.w : 0),
                child: Text(
                  AppLocalizations.of(context)!.enter_location_name,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEstateList(context) {
    return Column(
      children: [
        buildTitle(context),
        buildEstatesCard(context),
        kHe36,
        // buildRating(),
      ],
    );
  }

  Widget buildTitle(context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.new_homes_for_you,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: isArabic ? 28.sp : 30.sp),
                ),
                Text(
                  AppLocalizations.of(context)!.based_on_your_recent_searches,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      fontSize: isArabic ? 22.sp : 24.sp),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.7)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.clear,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: AppColors.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    RecentSearchesSharedPreferences.removeSearches();
                    RecentSearchesSharedPreferences
                        .removeRecentSearchesFilter();
                    getEstateSearch();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEstatesCard(context) {
    SearchData searchData = SearchData(
        locationId: estateSearchFilterCubit.state.length == 6
            ? int.tryParse(estateSearchFilterCubit.state.elementAt(5))
            : null,
        estateTypeId: int.tryParse(estateSearchFilterCubit.state.elementAt(3)),
        estateOfferTypeId:
            int.tryParse(estateSearchFilterCubit.state.elementAt(4)),
        priceMax: int.tryParse(estateSearchFilterCubit.state.elementAt(1)),
        priceMin: int.tryParse(estateSearchFilterCubit.state.elementAt(2)),
        sortType: "desc");
    return Padding(
      padding: kMediumLarHeight,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EstatesScreen(
                      searchData: searchData,
                      locationName: estateSearchFilterCubit.state.elementAt(0),
                      eventSearch: EstatesFetchStarted(
                        searchData: searchData,
                        isAdvanced: false,
                        token: UserSharedPreferences.getAccessToken(),
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: kLargeSymHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            estateSearchFilterCubit.state.elementAt(0),
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                    fontSize: 23.sp),
                          ),
                          Text(
                            estateTypeName +
                                " ${isArabic ? "لل" : ""}" +
                                estateOfferName +
                                priceMaxMin,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondaryDark,
                                    fontSize: 15.sp),
                          ),
                        ]),
                    Column(
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 27.w,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            kHe12,
            SizedBox(
              height: !isDark ? 475.h : 485.h,
              child: ListView.builder(
                reverse: isArabic ? true : false,
                itemCount: estateSearchCubit.state.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(left: 8.w, right: 3.w, bottom: 20.h),
                    child: HomeEstateCard(
                        estate: estateSearchCubit.state.elementAt(index)),
                  );
                },
              ),
            ),
            kHe24,
          ],
        ),
      ),
    );
  }

  Widget buildEmptyScreen(context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            documentOutlineIconPath,
            width: 0.5.sw,
            height: 0.4.sw,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.42),
          ),
          48.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              AppLocalizations.of(context)!.have_not_recent_search,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          48.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(220.w, 64.h),
            ),
            child: Text(
              AppLocalizations.of(context)!.new_search,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LocationSearchType()));
            },
          )
        ],
      ),
    );
  }

  Widget buildRating() {
    return Padding(
      padding: kLargeAllPadding,
      child: Container(
        padding: kMediumSymWidth,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: AppColors.yellowDarkColor, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          children: [
            kHe32,
            Text(
              AppLocalizations.of(context)!.what_do_you_think_of_the_app,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            kHe32,
            BlocBuilder(
                bloc: selectedRatingCubit,
                builder: (_, selectedRating) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RatingChoiceWidget(
                        assetPath: sadFacePath,
                        ratingName: AppLocalizations.of(context)!.bad,
                        onTap: () {
                          selectedRatingCubit.setState(1);
                        },
                        isPressed: (selectedRating == 1),
                      ),
                      kWi16,
                      RatingChoiceWidget(
                        assetPath: normalFacePath,
                        ratingName: AppLocalizations.of(context)!.normal,
                        onTap: () {
                          selectedRatingCubit.setState(2);
                        },
                        isPressed: (selectedRating == 2),
                      ),
                      kWi16,
                      RatingChoiceWidget(
                        assetPath: happyFacePath,
                        ratingName: AppLocalizations.of(context)!.good,
                        onTap: () {
                          selectedRatingCubit.setState(3);
                        },
                        isPressed: (selectedRating == 3),
                      ),
                    ],
                  );
                }),
            kHe50,
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(220.w, 64.h)),
              child: BlocConsumer<RatingBloc, RatingState>(
                bloc: _ratingBloc,
                listener: (_, ratingState) async {
                  if (ratingState is RatingComplete) {
                    selectedRatingCubit.setState(-1);
                  }

                  if (ratingState is RatingError) {
                    var error = ratingState.isConnectionError
                        ? AppLocalizations.of(context)!.no_internet_connection
                        : ratingState.error;
                    await showWonderfulAlertDialog(
                        context, AppLocalizations.of(context)!.error, error);
                  }
                  if (ratingState is RatingComplete) {
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.after_rate_message,
                        toastLength: Toast.LENGTH_LONG);
                  }
                },
                builder: (_, ratingState) {
                  if (ratingState is RatingProgress) {
                    return SpinKitWave(
                      size: 24.w,
                      color: Theme.of(context).colorScheme.background,
                    );
                  }
                  return Text(
                    AppLocalizations.of(context)!.send_rate,
                  );
                },
              ),
              onPressed: () {
                if (_ratingBloc.state is RatingProgress ||
                    _ratingBloc.state is RatingComplete) {
                  return;
                }
                if (selectedRatingCubit.state == -1) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!
                          .you_must_select_rate_first);
                  return;
                }

                String? token;
                if (UserSharedPreferences.getAccessToken() != null) {
                  token = UserSharedPreferences.getAccessToken();
                }
                _ratingBloc.add(
                  RatingStarted(
                      token: token, rate: selectedRatingCubit.state.toString()),
                );
              },
            ),
            kHe40,
          ],
        ),
      ),
    );
  }
}
