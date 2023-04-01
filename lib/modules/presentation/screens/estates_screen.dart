import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/search_data.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/report_estate.dart';

class EstatesScreen extends StatefulWidget {
  static const String id = "EstatesScreen";

  final SearchData searchData;
  final EstateEvent eventSearch;
  final String locationName;

  const EstatesScreen(
      {Key? key,
      required this.eventSearch,
      required this.searchData,
      required this.locationName})
      : super(key: key);

  @override
  _EstatesScreenState createState() => _EstatesScreenState();
}

class _EstatesScreenState extends State<EstatesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ChannelCubit _priceSelected = ChannelCubit(false);
  final ChannelCubit _dateSelected = ChannelCubit(true);
  EstateBloc estateBloc = EstateBloc(EstateRepository());

  EstateSearch estateSearch = EstateSearch.init();
  final ScrollController _scrollController = ScrollController();
  bool isIdenticalEstatesFinished = false;
  bool isSimilarEstatesFinished = false;
  String? userToken;
  late bool isDark;

  List<Estate> allEstates = [];

  @override
  void initState() {
    super.initState();
    isIdenticalEstatesFinished = false;
    isSimilarEstatesFinished = false;
    if (UserSharedPreferences.getAccessToken() != null) {
      userToken = UserSharedPreferences.getAccessToken();
    }
  }

  getEstateSearch() async {
    estateSearchCubit
        .setState(await RecentSearchesSharedPreferences.getSearches());
    estateSearchFilterCubit
        .setState(RecentSearchesSharedPreferences.getRecentSearchesFilter());
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.search_results,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            kWi8,
          ],
        ),
        body: BlocProvider<EstateBloc>(
          create: (_) => estateBloc..add(widget.eventSearch),
          child: BlocConsumer<EstateBloc, EstateState>(
            listener: (_, estateFetchState) async {
              if (estateFetchState is EstatesFetchComplete) {
                if (estateFetchState.estateSearch.identicalEstates.isEmpty &&
                    estateSearch.identicalEstates.isNotEmpty) {
                  isIdenticalEstatesFinished = true;
                }
                if (estateFetchState.estateSearch.similarEstates.isEmpty &&
                    estateSearch.similarEstates.isNotEmpty) {
                  isSimilarEstatesFinished = true;
                }
                allEstates =
                    List.from(estateFetchState.estateSearch.similarEstates)
                      ..addAll(estateFetchState.estateSearch.identicalEstates);

                if (!estateBloc.isFetching) {
                  await RecentSearchesSharedPreferences.removeSearches();
                  RecentSearchesSharedPreferences.setSearches(
                      allEstates.take(5).toList());

                  await RecentSearchesSharedPreferences
                      .removeRecentSearchesFilter();
                  RecentSearchesSharedPreferences.setRecentSearchesFilter([
                    widget.locationName,
                    widget.searchData.priceMax.toString(),
                    widget.searchData.priceMin.toString(),
                    widget.searchData.estateTypeId.toString(),
                    widget.searchData.estateOfferTypeId.toString(),
                    widget.searchData.locationId.toString(),
                  ]);
                  getEstateSearch();
                }
              }
              if (estateFetchState is EstateFetchError) {
                var error = estateFetchState.isConnectionError
                    ? AppLocalizations.of(context)!.no_internet_connection
                    : estateFetchState.errorMessage;
                await showWonderfulAlertDialog(
                    context, AppLocalizations.of(context)!.error, error);
              }
            },
            builder: (context, EstateState estatesFetchState) {
              if (estatesFetchState is EstateFetchNone ||
                  (estatesFetchState is EstatesFetchProgress &&
                      (estateSearch.identicalEstates.isEmpty &&
                          estateSearch.similarEstates.isEmpty))) {
                return const PropertyShimmer();
              } else if (estatesFetchState is EstatesFetchComplete) {
                if (estatesFetchState
                    .estateSearch.identicalEstates.isNotEmpty) {
                  estateSearch.identicalEstates
                      .addAll(estatesFetchState.estateSearch.identicalEstates);
                }
                estateBloc.isFetching = false;
                if (estatesFetchState.estateSearch.similarEstates.isNotEmpty) {
                  estateSearch.similarEstates
                      .addAll(estatesFetchState.estateSearch.similarEstates);
                }
                estateBloc.isFetching = false;
              } else if (estatesFetchState is FilterEstateFetchComplete) {
                if (estateBloc.filterPage == 2) {
                  estateSearch.identicalEstates =
                      estatesFetchState.estateSearch.identicalEstates;
                  estateSearch.similarEstates =
                      estatesFetchState.estateSearch.similarEstates;
                  isIdenticalEstatesFinished = false;
                } else {
                  estateSearch.identicalEstates
                      .addAll(estatesFetchState.estateSearch.identicalEstates);
                  estateSearch.similarEstates
                      .addAll(estatesFetchState.estateSearch.similarEstates);
                }
                estateBloc.isFetching = false;
              } else if (estatesFetchState is EstateFetchError &&
                  estateSearch.identicalEstates.isEmpty) {
                estateBloc.isFetching = false;
                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  onRefresh: () async {
                    estateBloc.add(widget.eventSearch);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                        width: 1.sw,
                        height: 1.sh - 75.h,
                        child: FetchResult(
                            content: AppLocalizations.of(context)!
                                .error_happened_when_executing_operation)),
                  ),
                );
              }

              if (estateSearch.identicalEstates.isEmpty &&
                  estateSearch.similarEstates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.24),
                        size: 120.w,
                      ),
                      kHe24,
                      Text(
                        AppLocalizations.of(context)!.no_results_body,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      // kHe12,
                      // Text(
                      //   AppLocalizations.of(context)!.no_results_hint,
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .bodyText2!
                      //       .copyWith(fontWeight: FontWeight.w400),
                      // ),
                      kHe40,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(220.w, 64.h),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.create_estate_order,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                controller: _scrollController
                  ..addListener(
                    () {
                      if (_scrollController.offset ==
                              _scrollController.position.maxScrollExtent &&
                          !estateBloc.isFetching &&
                          !isIdenticalEstatesFinished) {
                        estateBloc
                          ..isFetching = true
                          ..add(widget.eventSearch);
                      }
                    },
                  ),
                child: Column(
                  children: [
                    buildFilter(),
                    if (estateSearch.identicalEstates.isNotEmpty)
                      buildIdenticalEstates(),
                    if (estateSearch.similarEstates.isNotEmpty)
                      buildSimilarEstates(),
                    if (isSimilarEstatesFinished) buildEstatesFinished(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFilter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.w, 8.w, 7.w),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<ChannelCubit, dynamic>(
                bloc: _priceSelected,
                builder: (_, isPriceSelected) {
                  return InkWell(
                    onTap: () {
                      _priceSelected.setState(!isPriceSelected);
                      if (_dateSelected.state) {
                        _dateSelected.setState(false);
                      }
                      print("ghina : ${widget.searchData.estateOfferTypeId}\n"
                          "${widget.searchData.estateTypeId}\n"
                          "${widget.searchData.locationId}\n"
                          "${widget.searchData.priceMin}\n"
                          "${widget.searchData.priceMax}\n"
                          "$isPriceSelected");

                      estateBloc.filterPage = 1;
                      if (widget.searchData.locationId == 0) {
                        widget.searchData.locationId = null;
                      }
                      estateBloc.add(
                        FilterEstateFetchStarted(
                          searchData: SearchData(
                              locationId: widget.searchData.locationId,
                              estateTypeId: widget.searchData.estateTypeId,
                              estateOfferTypeId:
                                  widget.searchData.estateOfferTypeId,
                              priceMin: widget.searchData.priceMin,
                              priceMax: widget.searchData.priceMax,
                              sortType: !isPriceSelected ? "desc" : "asc",
                              sortBy: "price"),
                          isAdvanced: false,
                          token: UserSharedPreferences.getAccessToken(),
                        ),
                      );
                    },
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: isPriceSelected
                            ? AppColors.primaryColor
                            : AppColors.white,
                        borderRadius: smallBorderRadius,
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ResText(
                            AppLocalizations.of(context)!.by_price,
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: isPriceSelected
                                        ? AppColors.white
                                        : AppColors.primaryColor),
                          ),
                          !isPriceSelected
                              ? Icon(
                                  Icons.arrow_upward,
                                  color: AppColors.primaryColor,
                                  size: 16.w,
                                )
                              : Icon(
                                  Icons.arrow_downward,
                                  color: AppColors.white,
                                  size: 16.w,
                                )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          kWi12,
          Expanded(
            child: BlocBuilder<ChannelCubit, dynamic>(
                bloc: _dateSelected,
                builder: (_, isDateSelected) {
                  return InkWell(
                    onTap: () {
                      _dateSelected.setState(!isDateSelected);
                      if (_priceSelected.state) {
                        _priceSelected.setState(false);
                      }
                      estateBloc.filterPage = 1;
                      if (widget.searchData.locationId == 0) {
                        widget.searchData.locationId = null;
                      }
                      estateBloc.add(
                        FilterEstateFetchStarted(
                          searchData: SearchData(
                              locationId: widget.searchData.locationId,
                              estateTypeId: widget.searchData.estateTypeId,
                              estateOfferTypeId:
                                  widget.searchData.estateOfferTypeId,
                              priceMin: widget.searchData.priceMin,
                              priceMax: widget.searchData.priceMax,
                              sortType: !isDateSelected ? "desc" : "asc"),
                          isAdvanced: false,
                          token: UserSharedPreferences.getAccessToken(),
                        ),
                      );
                      print("ghina1 : ${widget.searchData.estateOfferTypeId}\n"
                          "${widget.searchData.estateTypeId}\n"
                          "${widget.searchData.locationId}\n"
                          "${widget.searchData.priceMin}\n"
                          "${widget.searchData.priceMax}\n"
                          "$isDateSelected");
                    },
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: isDateSelected
                            ? AppColors.primaryColor
                            : AppColors.white,
                        borderRadius: smallBorderRadius,
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.by_date,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: isDateSelected
                                        ? AppColors.white
                                        : AppColors.primaryColor),
                          ),
                          !isDateSelected
                              ? Icon(
                                  Icons.arrow_upward,
                                  color: AppColors.primaryColor,
                                  size: 16.w,
                                )
                              : Icon(
                                  Icons.arrow_downward,
                                  color: AppColors.white,
                                  size: 16.w,
                                )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget buildIdenticalEstates() {
    return Column(
      children: [
        Padding(
          padding: kTinyAllPadding,
          child: Container(
            alignment: Alignment.center,
            height: 60.h,
            width: getScreenWidth(context),
            decoration: BoxDecoration(
              borderRadius: lowBorderRadius,
              border: Border.all(color: AppColors.yellowDarkColor),
            ),
            child: ResText(
              AppLocalizations.of(context)!.identical_estates,
              textStyle: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: estateSearch.identicalEstates.length,
          itemBuilder: (_, index) {
            return EstateCard(
              color: Theme.of(context).colorScheme.background,
              estate: estateSearch.identicalEstates.elementAt(index),
              onClosePressed: () {
                showReportModalBottomSheet(context,
                    estateSearch.identicalEstates.elementAt(index).id!);
              },
              removeCloseButton: false,
            );
          },
        ),
        if (estateBloc.isFetching)
          Container(
            margin: EdgeInsets.only(
              top: 12.h,
            ),
            child: SpinKitWave(
              color: Theme.of(context).colorScheme.primary,
              size: 50.w,
            ),
          ),
      ],
    );
  }

  Widget buildSimilarEstates() {
    return Column(
      children: [
        kHe44,
        Padding(
          padding: kTinyAllPadding,
          child: Container(
            alignment: Alignment.center,
            height: 60.h,
            width: getScreenWidth(context),
            decoration: BoxDecoration(
              borderRadius: lowBorderRadius,
              border: Border.all(color: AppColors.yellowDarkColor),
            ),
            child: ResText(
              AppLocalizations.of(context)!.similar_estates,
              textStyle: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: estateSearch.similarEstates.length,
          itemBuilder: (_, index) {
            return EstateCard(
              color: Theme.of(context).colorScheme.background,
              estate: estateSearch.similarEstates.elementAt(index),
              onClosePressed: () {
                showReportModalBottomSheet(
                    context, estateSearch.similarEstates.elementAt(index).id!);
              },
              removeCloseButton: false,
            );
          },
        ),
        if (estateBloc.isFetching)
          Container(
            margin: EdgeInsets.only(
              top: 12.h,
            ),
            child: SpinKitWave(
              color: Theme.of(context).colorScheme.primary,
              size: 50.w,
            ),
          ),
      ],
    );
  }

  Widget buildEstatesFinished() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 50.h,
      ),
      width: 1.sw,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              kWi16,
              Expanded(
                flex: 2,
                child: Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              ),
              Expanded(
                flex: 3,
                child: ResText(
                  AppLocalizations.of(context)!.no_more_results,
                  textAlign: TextAlign.center,
                  textStyle: textStyling(S.s18, W.w5, isDark ? C.c1 : C.bl),
                ),
              ),
              Expanded(
                flex: 2,
                child: Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              ),
              kWi16,
            ],
          ),
          kHe28,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(220.w, 64.h),
            ),
            child: Text(
              AppLocalizations.of(context)!.create_estate_order,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
