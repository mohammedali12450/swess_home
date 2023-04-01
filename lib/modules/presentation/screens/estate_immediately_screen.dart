import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import '../../../constants/design_constants.dart';
import '../../../core/functions/app_theme_information.dart';
import '../../../core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import '../../business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_event.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/period_type.dart';
import '../../data/models/rent_estate.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/rent_estate_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/immediately_card.dart';
import '../widgets/my_dropdown_list.dart';
import '../widgets/res_text.dart';
import '../widgets/shimmers/immediate_shimmer.dart';
import 'create_estate_immediately_screen.dart';
import 'search_region_screen.dart';

class EstateImmediatelyScreen extends StatefulWidget {
  const EstateImmediatelyScreen({Key? key}) : super(key: key);

  @override
  State<EstateImmediatelyScreen> createState() =>
      _EstateImmediatelyScreenState();
}

class _EstateImmediatelyScreenState extends State<EstateImmediatelyScreen> {
  late RentEstateBloc _rentEstateBloc;
  List<RentEstate> rentEstates = [];

  final ScrollController _scrollController = ScrollController();

  ChannelCubit isPressSearchCubit = ChannelCubit(false);
  ChannelCubit isFilterCubit = ChannelCubit(false);
  ChannelCubit locationNameCubit = ChannelCubit("");
  ChannelCubit patternCubit = ChannelCubit(null);

  // late List<EstateType> estatesTypes;
  // List<EstateType> estateTypes = [];

  late List<PeriodType> periodTypes;
  bool isEstatesFinished = false;
  final ChannelCubit _priceSelected = ChannelCubit(false);
  RentEstateFilter rentEstateFilter = RentEstateFilter.init();
  RegionViewer? selectedRegion;

  late bool isDark;

  @override
  void initState() {
    _rentEstateBloc = RentEstateBloc(RentEstateRepository());
    // estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    //
    // for (int i = 0; i < estatesTypes.length; i++) {
    //   if (estatesTypes.elementAt(i).id == 3) {
    //     continue;
    //   }
    //   estateTypes.add(estatesTypes.elementAt(i));
    // }
    periodTypes = BlocProvider.of<PeriodTypesBloc>(context).periodTypes!;
    _onRefresh();
    super.initState();
  }

  _onRefresh() {
    _rentEstateBloc.page = 1;
    rentEstates.clear();
    _rentEstateBloc.add(GetRentEstatesFetchStarted(
        rentEstateFilter: RentEstateFilter(price: "desc")));
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Scaffold(
      drawer: SizedBox(
        width: getScreenWidth(context) * (75/100),
        child: const Drawer(
          child: MyDrawer(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _onRefresh();
        },
        child: CustomScrollView(
          controller: _scrollController
            ..addListener(
              () {
                if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent &&
                    !_rentEstateBloc.isFetching &&
                    !isEstatesFinished) {
                  _rentEstateBloc.isFilter = false;
                  _rentEstateBloc
                    ..isFetching = true
                    ..add(
                      !isFilterCubit.state
                          ? GetRentEstatesFetchStarted(
                              rentEstateFilter: RentEstateFilter(
                                  locationId: null,
                                  periodTypeId: null,
                                  //estateTypeId: null,
                                  price: "desc"),
                            )
                          : FilterRentEstatesFetchStarted(
                              rentEstateFilter: rentEstateFilter),
                    );
                  print("ghina : ${rentEstateFilter.price}\n"
                      "${rentEstateFilter.locationId}\n");
                }
              },
            ),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!.estate_immediately),
              bottom: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 65.h,
                title: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: kSmallSymWidth,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.yellowDarkColor,
                                ),
                                borderRadius: circularBorderRadius),
                            child: IconButton(
                              padding: kTinyAllPadding,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          elevation: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              borderRadius: lowBorderRadius,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Text(
                                                //   AppLocalizations.of(context)!
                                                //       .filter,
                                                //   style: const TextStyle(
                                                //       fontWeight: FontWeight.bold,
                                                //       color: Colors.red,
                                                //       fontSize: 20),
                                                // ),
                                                24.verticalSpace,
                                                buildDialogBody()
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              icon: const Icon(Icons.filter_alt_outlined),
                            ),
                          ),
                        )),
                    kWi20,
                    Expanded(
                      flex: 4,
                      child: buildLocation(),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<RentEstateBloc, RentEstateState>(
              bloc: _rentEstateBloc,
              builder: (_, getRentState) {
                if (getRentState is GetRentEstateFetchProgress &&
                    rentEstates.isEmpty) {
                  return const ImmediateShimmer();
                }
                if (getRentState is GetRentEstateFetchComplete) {
                  rentEstates.addAll(getRentState.rentEstates);
                  _rentEstateBloc.isFetching = false;
                  if (getRentState.rentEstates.isEmpty &&
                      rentEstates.isNotEmpty) {
                    isEstatesFinished = true;
                  }
                }
                if (getRentState is FilterRentEstateFetchComplete) {
                  if (_rentEstateBloc.filterPage == 2) {
                    rentEstates = getRentState.rentEstates;
                    isEstatesFinished = false;
                  } else {
                    rentEstates.addAll(getRentState.rentEstates);
                  }
                  _rentEstateBloc.isFetching = false;
                  if (getRentState.rentEstates.isEmpty &&
                      rentEstates.isNotEmpty) {
                    isEstatesFinished = true;
                  }
                }
                if (rentEstates.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: getScreenHeight(context) / 1.2,
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
                          ResText(
                            AppLocalizations.of(context)!.no_results_hint,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverFixedExtentList(
                  itemExtent: 350.h,
                  delegate: SliverChildBuilderDelegate((builder, index) {
                    return ImmediatelyCard(
                      rentEstate: rentEstates.elementAt(index),
                      isForCommunicate: true,
                      isForDelete: false,
                    );
                  }, childCount: rentEstates.length),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: UserSharedPreferences.getAccessToken() != null
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w),
              child: Directionality(
                textDirection: TextDirection.ltr,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: AppColors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: ResText(
                                AppLocalizations.of(context)!.create,
                                textStyle: TextStyle(
                                    color: AppColors.white, fontSize: 16.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateEstateImmediatelyScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          : Container(),
    );
  }

  Widget buildLocation() {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.yellowDarkColor, width: 1),
          borderRadius: lowBorderRadius,
        ),
        margin: EdgeInsets.only(
          bottom: 8.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ),
        child: InkWell(
          onTap: () async {
            selectedRegion = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SearchRegionScreen(),
              ),
            ) as RegionViewer;
            FocusScope.of(context).unfocus();
            if (selectedRegion != null) {
              rentEstateFilter.locationId = selectedRegion!.id;
              locationNameCubit.setState(selectedRegion!.getLocationName());
              isPressSearchCubit.setState(true);
            }
            return;
          },
          child: BlocBuilder<ChannelCubit, dynamic>(
            bloc: isPressSearchCubit,
            builder: (_, isPress) {
              if (isPress) {
                _rentEstateBloc.isFilter = true;
                isFilterCubit.setState(true);
                _rentEstateBloc.filterPage = 1;
                rentEstates.clear();
                _rentEstateBloc.add(FilterRentEstatesFetchStarted(
                    rentEstateFilter: rentEstateFilter));
                print("ghina1 : ${rentEstateFilter.price}\n"
                    "${rentEstateFilter.locationId}\n");
                isPressSearchCubit.setState(false);
              }
              return BlocBuilder<ChannelCubit, dynamic>(
                  bloc: locationNameCubit,
                  builder: (_, locationName) {
                    return Center(
                      child: Row(
                        children: [
                          ResText(
                            locationName == ""
                                ? AppLocalizations.of(context)!
                                    .enter_location_name
                                : locationName,
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: AppColors.black, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget buildType(String label, String text) {
    return Row(
      children: [
        ResText(
          label + " : ",
          textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 17.sp,
              color: isDark ? AppColors.primaryDark : AppColors.primaryColor),
        ),
        ResText(
          " " + text,
          textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 17.sp,
              color: isDark ? AppColors.white : AppColors.black),
        ),
      ],
    );
  }

  Widget buildDialogBody() {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      spacing: 12.h,
      //runSpacing: 12.w,
      children: [
        Container(
          width: inf,
          padding: kSmallSymWidth,
          height: 250.h,
          child: Column(
            children: [
              buildPriceFilter(),
              kHe24,
              // buildEstateType(),
              // kHe24,
              buildPeriodTypes()
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 18.h),
          child: ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.ok,
            ),
            onPressed: () async {
              _rentEstateBloc.filterPage = 1;
              // print(rentEstateFilter.estateTypeId);
              // print(rentEstateFilter.periodTypeId);
              // print(rentEstateFilter.locationId);
              // print(rentEstateFilter.price);
              _rentEstateBloc.isFilter = true;
              isFilterCubit.setState(true);
              rentEstates.clear();
              _rentEstateBloc.add(FilterRentEstatesFetchStarted(
                  rentEstateFilter: rentEstateFilter));

              print("ghina2 : ${rentEstateFilter.price}\n"
                  "${rentEstateFilter.locationId}\n"
                  "${rentEstateFilter.periodTypeId}");
              //_rentEstateBloc.isFilter = false;
              Navigator.pop(context);
            },
          ),
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
    );
  }

  Widget buildPriceFilter() {
    return BlocBuilder<ChannelCubit, dynamic>(
        bloc: _priceSelected,
        builder: (_, isPriceSelected) {
          return InkWell(
            onTap: () {
              _priceSelected.setState(!isPriceSelected);
              rentEstateFilter.price = !_priceSelected.state ? "desc" : "asc";
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                            Icons.arrow_downward,
                            color: AppColors.primaryColor,
                            size: 16.w,
                          )
                        : Icon(
                            Icons.arrow_upward,
                            color: AppColors.white,
                            size: 16.w,
                          )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildPeriodTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: ResText(
            AppLocalizations.of(context)!.estate_rent_period + " :",
            textStyle: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: kSmallAllPadding,
          child: Container(
            padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: lowBorderRadius,
            ),
            child: MyDropdownList(
              elementsList:
                  periodTypes.map((e) => e.name.split("|").first).toList(),
              onSelect: (index) {
                rentEstateFilter.periodTypeId = periodTypes.elementAt(index).id;
              },
              validator: (value) => value == null
                  ? AppLocalizations.of(context)!.this_field_is_required
                  : null,
              selectedItem: AppLocalizations.of(context)!.please_select_here,
            ),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }

  /*Widget buildEstateType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            AppLocalizations.of(context)!.estate_type + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 13.w),
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: MyDropdownList(
              elementsList:
                  estateTypes.map((e) => e.name.split('|')[1]).toList(),
              onSelect: (index) {
                rentEstateFilter.estateTypeId = estateTypes.elementAt(index).id;
              },
              validator: (value) => value == null
                  ? AppLocalizations.of(context)!.this_field_is_required
                  : null,
              selectedItem: AppLocalizations.of(context)!.please_select,
            ),
          ),
        ),
      ],
    );
  }*/

  Widget buildEstatesFinished() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 50.h,
      ),
      width: 1.sw,
      child: Row(
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
              textStyle: textStyling(S.s18, W.w5, C.bl),
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
    );
  }
}
