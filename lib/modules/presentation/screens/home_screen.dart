import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/presentation/screens/rating_screen.dart';
import 'package:swesshome/modules/presentation/widgets/home_estate_card.dart';
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
import '../../business_logic_components/bloc/previous_search_results_bloc/previous_search_results_bloc.dart';
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
import '../widgets/app/global_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/icone_badge.dart';
import '../widgets/wonderful_alert_dialog.dart';
import 'authentication_screen.dart';
import 'estates_screen.dart';
import 'location_search_type.dart';
import 'notifications_screen.dart';
import 'office_search_screen.dart';
import '../../data/models/previous_search_zone.dart';

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
    if (UserSharedPreferences.getAccessToken() != null) {
      BlocProvider.of<PreviousSearchResultsBloc>(context)
        .add(PreviousSearchResultsFetchStarted());
    }
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: GlobalAppbarWidget(
            isDark: isDark, title: AppLocalizations.of(context)!.search),
      ),
      body: Column(
        children: [
          buildLocationContainer(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                            ..addAll(
                                estateFetchState.estateSearch.identicalEstates);
                          await RecentSearchesSharedPreferences
                              .removeSearches();
                          RecentSearchesSharedPreferences.setSearches(
                              allEstates!.take(5).toList());
                          estateSearchCubit.setState(
                              await RecentSearchesSharedPreferences
                                  .getSearches());
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
                                    // UserSharedPreferences.getAccessToken() == null ||
                                    estateSearchState.isEmpty
                                        ? Container(
                                            height: 0.5.sh,
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
          )
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.symmetric(vertical: 5.w),
      //   child: Directionality(
      //     textDirection: ui.TextDirection.ltr,
      //     child: Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 5.w),
      //       child: GestureDetector(
      //         child: Card(
      //           color: AppColors.primaryColor,
      //           elevation: 4,
      //           shape: StadiumBorder(
      //             side: BorderSide(
      //               color: AppColors.yellowColor,
      //               width: 2,
      //             ),
      //           ),
      //           child: Container(
      //             width: 100.w,
      //             alignment: Alignment.center,
      //             height: 72.h,
      //             child: Padding(
      //               padding: EdgeInsets.only(top: 2.h),
      //               child: Text(
      //                 AppLocalizations.of(context)!.search,
      //                 style: TextStyle(color: AppColors.white, fontSize: 20.sp),
      //               ),
      //             ),
      //           ),
      //         ),
      //         onTap: () {
      //           showDialog(
      //             context: context,
      //             builder: (context) => Dialog(
      //               elevation: 2,
      //               child: Container(
      //                 padding: EdgeInsets.symmetric(
      //                     vertical: 16.h, horizontal: 12.w),
      //                 decoration: BoxDecoration(
      //                   color: Theme.of(context).colorScheme.background,
      //                   borderRadius: lowBorderRadius,
      //                 ),
      //                 child: Padding(
      //                   padding: kTinyAllPadding,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       // 15.verticalSpace,
      //                       TextButton(
      //                           onPressed: () {
      //                             Navigator.pop(context);
      //                             Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                 builder: (_) =>
      //                                     const FilterSearchScreen(),
      //                               ),
      //                             );
      //                           },
      //                           child: Row(
      //                             children: [
      //                               const Icon(Icons.home_work_outlined),
      //                               kWi16,
      //                               Text(
      //                                 AppLocalizations.of(context)!
      //                                     .estate_search,
      //                                 style:
      //                                     Theme.of(context).textTheme.headline5,
      //                               ),
      //                             ],
      //                           )),
      //                       // const Divider(
      //                       //   indent: 20,
      //                       //   thickness: 0.1,
      //                       //   endIndent: 20,
      //                       // ),
      //                       // TextButton(
      //                       //     onPressed: () {
      //                       //       Navigator.pop(context);
      //                       //       Navigator.push(
      //                       //         context,
      //                       //         MaterialPageRoute(
      //                       //           builder: (_) =>
      //                       //               const OfficeSearchScreen(),
      //                       //         ),
      //                       //       );
      //                       //     },
      //                       //     child: Row(
      //                       //       children: [
      //                       //         const Icon(Icons.house_outlined),
      //                       //         kWi16,
      //                       //         Text(
      //                       //           AppLocalizations.of(context)!
      //                       //               .search_for_estate_agent,
      //                       //           style:
      //                       //               Theme.of(context).textTheme.headline5,
      //                       //         ),
      //                       //       ],
      //                       //     )),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ),
      // ),
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
          height: 50.h,
          width: 1.sw,
          alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: isDark ? Colors.transparent : AppColors.white,
            border: Border.all(
                color: isDark ? AppColors.lightGrey2Color : AppColors.lightblue,
                width: 1),
            borderRadius: veryLowBorderRadius,
            // boxShadow: [
            //   BoxShadow(
            //     color: Theme.of(context).colorScheme.shadow,
            //     offset: const Offset(0, 2),
            //     blurRadius: 4,
            //   )
            // ],
          ),
          // margin: EdgeInsets.only(
          //   bottom: 8.h,
          // ),
          // padding: EdgeInsets.symmetric(
          //   horizontal: 12.w,
          // ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.search_outlined,
                  color:
                      isDark ? AppColors.lightGrey2Color : AppColors.lightblue,
                  size: 25.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: !isArabic ? 8.w : 0,
                    right: isArabic ? 8.w : 0,
                    top: isArabic ? 0.w : 3),
                child: Text(
                  AppLocalizations.of(context)!.search2,
                  // AppLocalizations.of(context)!.enter_location_name,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightGreyColor),
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
        // kHe36,
        // buildRating(),
      ],
    );
  }

  Widget buildTitle(context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   AppLocalizations.of(context)!.new_homes_for_you,
                //   style: Theme.of(context).textTheme.headline3!.copyWith(
                //       fontWeight: FontWeight.bold,
                //       color: AppColors.primaryColor,
                //       fontSize: isArabic ? 28.sp : 30.sp),
                // ),
                Text(
                  AppLocalizations.of(context)!.previous_search_results,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightGreyColor,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    RecentSearchesSharedPreferences.removeSearches();
                    RecentSearchesSharedPreferences
                        .removeRecentSearchesFilter();
                    getEstateSearch();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.lightGreyColor
                        : AppColors.lightGrey2Color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: isArabic ? 0 : 5),
                      child: Text(
                        AppLocalizations.of(context)!.clear,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
      child: Column(
        children: [
          Card(
            color: isDark ? Colors.transparent : Colors.white,
            child: Column(
              children: [
                // kHe12,
                Container(
                  height: 425,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                    reverse: isArabic ? true : false,
                    itemCount: estateSearchCubit.state.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 8.w, right: 3.w, bottom: 20.h, top: 20.h),
                        child: HomeEstateCard(
                            estate: estateSearchCubit.state.elementAt(index)),
                      );
                    },
                  ),
                ),
                // kHe24,
              ],
            ),
          ),
          kHe8,

          /// new Api
          BlocBuilder<PreviousSearchResultsBloc, PreviousSearchResultsState>(
            builder: (context, state) {
              if(state is PreviousSearchResultsFetchProgress)
                {
                  return Container(
                    margin: EdgeInsets.only(
                      top: 12.h,
                    ),
                    child: SpinKitWave(
                      color: Theme.of(context).colorScheme.primary,
                      size: 40.w,
                    ),
                  );
                }
              if (state is PreviousSearchResultsFetchComplete) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.zones.length,
                    itemBuilder: (context, index) {
                      return PreviousSearchResultWidget(
                        isDark: isDark,
                        zone: state.zones[index],
                      );
                    });
              }
              return Container();
            },
          ),

          /// new Api
        ],
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
            width: 0.2.sw,
            height: 0.2.sw,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.42),
          ),
          25.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              AppLocalizations.of(context)!.have_not_recent_search,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          25.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(220.w, 50.h),
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

class PreviousSearchResultWidget extends StatelessWidget {
  const PreviousSearchResultWidget({
    super.key,
    required this.isDark,
    required this.zone,
  });

  final bool isDark;
  final Zone zone;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDark ? Colors.transparent : Colors.white,
      child: Padding(
        padding: kLargeSymHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                zone.locationFullName,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.lightGrey2Color : AppColors.black,
                    fontSize: 16.sp),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  AppLocalizations.of(context)!.result_matching_search_page,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightGreyColor,
                      fontSize: 12.sp),
                ),
              ),
            ]),
            IconButton(
              onPressed: () {
                SearchData searchData = SearchData(
                    locationId: zone.locationId,
                    estateTypeId: zone.estateTypeId,
                    estateOfferTypeId: zone.estateOfferTypeId,
                    priceMax: int.tryParse(zone.priceMax!),
                    priceMin: int.tryParse(zone.priceMin!));
                searchData.sortType = "desc";
                searchData.sortBy="price";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EstatesScreen(
                      searchData: searchData,
                      locationName: zone.locationFullName,
                      eventSearch: EstatesFetchStarted(
                        searchData: searchData,
                        isAdvanced: false,
                        token: UserSharedPreferences.getAccessToken(),
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_forward,
                size: 27.w,
                color: isDark ? AppColors.lightblue : AppColors.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
