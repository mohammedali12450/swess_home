import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/assets_paths.dart';
import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_event.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/price_domain.dart';
import '../../data/models/search_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/estate_types_repository.dart';
import '../../data/repositories/price_domains_repository.dart';
import '../widgets/choice_container.dart';
import '../widgets/price_picker.dart';
import 'estates_screen.dart';
import 'search_location_screen.dart';
import 'search_region_screen.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({Key? key}) : super(key: key);

  @override
  State<FilterSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<FilterSearchScreen> {
  // Blocs and cubits:
  ChannelCubit patternCubit = ChannelCubit(null);
  ChannelCubit locationIdCubit = ChannelCubit(0);
  ChannelCubit locationNameCubit = ChannelCubit("");
  ChannelCubit startPriceCubit = ChannelCubit(0);
  ChannelCubit endPriceCubit = ChannelCubit(0);
  ChannelCubit isSellCubit = ChannelCubit(true);
  ChannelCubit isAreaSearchCubit = ChannelCubit(true);
  ChannelCubit isPressTypeCubit = ChannelCubit(5);

  PriceDomainsBloc priceDomainsBloc =
      PriceDomainsBloc(PriceDomainsRepository());
  EstateTypesBloc estateTypesBloc = EstateTypesBloc(EstateTypesRepository());

  // others:
  List<EstateType>? estatesTypes;
  PriceDomain? priceDomains;
  SearchData searchData = SearchData();
  String? token;
  LocationViewer? selectedLocation;
  RegionViewer? selectedRegion;

  // initializeEstateBooleanVariables() {
  //   isSell = (widget.searchData.estateOfferTypeId == sellOfferTypeNumber);
  //   isHouse = (widget.searchData.estateTypeId == housePropertyTypeNumber);
  //   isLands = (widget.searchData.estateTypeId == landsPropertyTypeNumber);
  //   isShops = (widget.searchData.estateTypeId == shopsPropertyTypeNumber);
  //   isFarmsAndVacations =
  //   ((widget.searchData.estateTypeId == farmsPropertyTypeNumber) ||
  //       (widget.searchData.estateTypeId == vacationsPropertyTypeNumber));
  // }

  initializeOfferData({bool justInitAdvanced = false}) {
    // if (!justInitAdvanced) widget.searchData.estateTypeId = null;
    // if (!justInitAdvanced) widget.searchData.priceDomainId = null;
    // if (!justInitAdvanced) widget.searchData.locationId = null;
    // widget.searchData.isFurnished = null;
    // widget.searchData.hasSwimmingPool = null;
    // widget.searchData.isOnBeach = null;
    // // widget.searchData.interiorStatusId = null;
    // // widget.searchData.ownershipId = null;
    // initializeEstateBooleanVariables();
    searchData.estateOfferTypeId = 1;
    searchData.priceMin = int.tryParse(priceDomains!.sale.min[0]);
    searchData.priceMax =
        int.tryParse(priceDomains!.sale.max[priceDomains!.sale.max.length - 1]);
  }

  String? userToken;
  late bool isArabic;

  @override
  void initState() {
    super.initState();

    // Fetch lists :
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;

    // Initialize search data :
    initializeOfferData();

    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null) {
      userToken = UserSharedPreferences.getAccessToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xff26282B) : null,
        title: Text(AppLocalizations.of(context)!.search),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ChannelCubit, dynamic>(
          bloc: isAreaSearchCubit,
          builder: (_, isArea) {
            return Column(
              children: [
                Container(
                  padding: kMediumSymHeight,
                  child: buildSearchWidgets(isDark),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.w),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                padding: kSmallSymWidth,
                width: 1.sw,
                alignment: Alignment.bottomCenter,
                height: 72.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [lowElevation]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.search,
                            ),
                            kWi16,
                            Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (searchData.locationId == 0) {
                            searchData.locationId = null;
                          }
                          print("ghina : "
                              "${searchData.estateOfferTypeId}\n"
                              "${isPressTypeCubit.state}\n"
                              "${searchData.locationId}\n"
                              "${searchData.priceMin}\n"
                              "${searchData.priceMax}");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EstatesScreen(
                                searchData: searchData,
                                eventSearch: EstatesFetchStarted(
                                  searchData: SearchData(
                                      locationId: searchData.locationId,
                                      estateTypeId: isPressTypeCubit.state == 5
                                          ? null
                                          : isPressTypeCubit.state,
                                      estateOfferTypeId:
                                          searchData.estateOfferTypeId,
                                      priceMin: searchData.priceMin,
                                      priceMax: searchData.priceMax,
                                      sortType: "desc"),
                                  isAdvanced: false,
                                  token: UserSharedPreferences.getAccessToken(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    kWi4,
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: isDark ? const Color(0xff90B8F8) : null,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(20.w, 60.h),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.clear,
                        ),
                        onPressed: () {
                          locationNameCubit.setState(
                              AppLocalizations.of(context)!
                                  .enter_location_name);
                          isSellCubit.setState(true);
                          isAreaSearchCubit.setState(true);
                          searchData = SearchData.init();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildSearchWidgets(isDark) {
    return Column(
      children: [
        buildChoiceContainer(
            context: context,
            cubit: isSellCubit,
            textLeft: AppLocalizations.of(context)!.sell,
            textRight: AppLocalizations.of(context)!.rent,
            onTapLeft: () {
              searchData.estateOfferTypeId = 1;
            },
            onTapRight: () {
              searchData.estateOfferTypeId = 2;
            }),
        buildLocation(isDark),
        buildEstateType(isDark),
        buildPriceDomain(isDark),
        kHe60,
      ],
    );
  }

  Widget buildEstateType(isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.home_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.estate_type + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: isPressTypeCubit,
          builder: (_, pressState) {
            return Padding(
              padding: kTinyAllPadding,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (pressState < 5 && pressState == 0) {
                          isPressTypeCubit.setState(5);
                        } else {
                          isPressTypeCubit.setState(0);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: kSmallAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 0
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(buildIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            estatesTypes!.elementAt(0).name.split("|")[1],
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 0
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 0
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kWi16,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (pressState < 5 && pressState == 3) {
                          isPressTypeCubit.setState(5);
                        } else {
                          isPressTypeCubit.setState(3);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: kSmallAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 3
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(farmIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            estatesTypes!.elementAt(3).name.split("|")[1],
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 3
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 3
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kWi16,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (pressState < 5 && pressState == 2) {
                          isPressTypeCubit.setState(5);
                        } else {
                          isPressTypeCubit.setState(2);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: kTinyAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 2
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(landIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            estatesTypes!.elementAt(2).name.split("|")[1],
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 2
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 2
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kWi16,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (pressState < 5 && pressState == 1) {
                          isPressTypeCubit.setState(5);
                        } else {
                          isPressTypeCubit.setState(1);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: kTinyAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 1
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(shopIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            estatesTypes!.elementAt(1).name.split("|")[1],
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 1
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 1
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kWi16,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (pressState < 5 && pressState == 4) {
                          isPressTypeCubit.setState(5);
                        } else {
                          isPressTypeCubit.setState(4);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 4
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(villaIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            estatesTypes!.elementAt(4).name.split("|")[1],
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 4
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 4
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        /* BlocBuilder<EstateTypesBloc, EstateTypesState>(
          bloc: estateTypesBloc,
          builder: (_, estateTypesState) {
            if (estateTypesState is EstateTypesFetchError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                    width: 1.sw,
                    height: 1.sh - 75.h,
                    child: FetchResult(
                        content: AppLocalizations.of(context)!
                            .error_happened_when_executing_operation)),
              );
            }
            if (estateTypesState is EstateTypesFetchProgress) {
              return SpinKitWave(
                color: Theme.of(context).colorScheme.background,
                size: 24.w,
              );
            } else if (estateTypesState is EstateTypesFetchComplete) {
              estatesTypes = estateTypesState.estateTypes!;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: MyDropdownList(
                  elementsList: estatesTypes!
                      .map((e) => e.name.split('|').first)
                      .toList(),
                  onSelect: (index) {
                    // set search data estate type :
                    searchData.estateTypeId = estatesTypes!.elementAt(index).id;
                  },
                  validator: (value) => value == null
                      ? AppLocalizations.of(context)!.this_field_is_required
                      : null,
                  selectedItem: AppLocalizations.of(context)!.please_select,
                ),
              ),
            );
          },
        ),*/
        kHe12,
      ],
    );
  }

  Widget buildPriceDomain(isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.price_change_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.price_domain + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
            bloc: isSellCubit,
            builder: (_, priceState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)!.min_price),
                            ],
                          ),
                          Align(
                            alignment: isArabic
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () async {
                                List<dynamic> min = priceState
                                    ? priceDomains!.sale.min
                                    : priceDomains!.rent.min;
                                await openPricePicker(
                                  context,
                                  isDark,
                                  title: AppLocalizations.of(context)!
                                      .title_min_price,
                                  items: min
                                      .map(
                                        (names) => Text(
                                          names,
                                          // textScaleFactor: 1.2,
                                          // textAlign: TextAlign.center,
                                        ),
                                      )
                                      .toList(),
                                  onSubmit: (data) {
                                    startPriceCubit.setState(data);
                                    //print(priceDomains!.sale.min[startPriceCubit.state]);
                                    searchData.priceMin = priceState
                                        ? int.tryParse(priceDomains!
                                            .sale.min[startPriceCubit.state])
                                        : int.tryParse(priceDomains!
                                            .rent.min[startPriceCubit.state]);
                                  },
                                );
                              },
                              child: BlocBuilder<ChannelCubit, dynamic>(
                                bloc: startPriceCubit,
                                builder: (_, state) {
                                  String textMin = priceState
                                      ? priceDomains!.sale.min[state]
                                      : priceDomains!.rent.min[state];
                                  return Container(
                                    alignment: isArabic
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    height: 55.h,
                                    width: 150.w,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(
                                          color: !isDark
                                              ? Colors.black38
                                              : AppColors.yellowDarkColor,
                                          width: 1,
                                        )),
                                    child: Text(textMin),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    kWi24,
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)!.max_price),
                            ],
                          ),
                          Align(
                            alignment: isArabic
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () async {
                                List<dynamic> max = isSellCubit.state
                                    ? priceDomains!.sale.max
                                    : priceDomains!.rent.max;
                                await openPricePicker(
                                  context,
                                  isDark,
                                  title: AppLocalizations.of(context)!
                                      .title_max_price,
                                  items: max
                                      .map(
                                        (names) => Text(
                                          names,
                                          // textScaleFactor: 1.2,
                                          // textAlign: TextAlign.center,
                                        ),
                                      )
                                      .toList(),
                                  onSubmit: (data) {
                                    endPriceCubit.setState(data);
                                    searchData.priceMax = endPriceCubit.state;
                                    searchData.priceMax = priceState
                                        ? int.tryParse(priceDomains!
                                            .sale.max[endPriceCubit.state])
                                        : int.tryParse(priceDomains!
                                            .rent.max[endPriceCubit.state]);
                                  },
                                );
                              },
                              child: BlocBuilder<ChannelCubit, dynamic>(
                                  bloc: endPriceCubit,
                                  builder: (_, state) {
                                    String textMax = isSellCubit.state
                                        ? priceDomains!.sale.max[state]
                                        : priceDomains!.rent.max[state];
                                    return Container(
                                      alignment: isArabic
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      height: 55.h,
                                      width: 150.w,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          border: Border.all(
                                            color: !isDark
                                                ? Colors.black38
                                                : AppColors.yellowDarkColor,
                                            width: 1,
                                          )),
                                      child: Text(textMax),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        kHe24,
      ],
    );
  }

  Column buildLocation(isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.location + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        buildChoiceContainer(
            context: context,
            cubit: isAreaSearchCubit,
            textLeft: AppLocalizations.of(context)!.search_by_area,
            textRight: AppLocalizations.of(context)!.search_neighborhood,
            onTapLeft: () {
              locationNameCubit
                  .setState(AppLocalizations.of(context)!.enter_location_name);
            },
            onTapRight: () {
              locationNameCubit.setState(
                  AppLocalizations.of(context)!.enter_neighborhood_name);
            }),
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: isAreaSearchCubit,
          builder: (_, isArea) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          !isDark ? Colors.black38 : AppColors.yellowDarkColor,
                      width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                margin: EdgeInsets.only(
                  bottom: 8.h,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: InkWell(
                  onTap: () async {
                    if (isArea) {
                      selectedRegion = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchRegionScreen(),
                        ),
                      ) as RegionViewer;
                      FocusScope.of(context).unfocus();
                      if (selectedRegion != null) {
                        searchData.locationId = selectedRegion!.id;
                        locationNameCubit
                            .setState(selectedRegion!.getLocationName());
                      }
                      return;
                    } else {
                      selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchLocationScreen(),
                        ),
                      ) as LocationViewer;
                      // unfocused text field :
                      FocusScope.of(context).unfocus();
                      if (selectedLocation != null) {
                        searchData.locationId = selectedLocation!.id;
                        locationNameCubit
                            .setState(selectedLocation!.getLocationName());
                      }
                      return;
                    }
                  },
                  child: BlocBuilder<ChannelCubit, dynamic>(
                    bloc: locationNameCubit,
                    builder: (_, locationName) {
                      return Center(
                        child: Row(
                          children: [
                            Text(locationName == ""
                                ? AppLocalizations.of(context)!
                                    .enter_location_name
                                : locationName),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
