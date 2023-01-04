import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/screens/region_screen.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../../constants/enums.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_event.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_state.dart';
import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/bloc/location_bloc/locations_state.dart';
import '../../business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_event.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_state.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/interior_status.dart';
import '../../data/models/location.dart';
import '../../data/models/ownership_type.dart';
import '../../data/models/price_domain.dart';
import '../../data/models/search_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/estate_types_repository.dart';
import '../../data/repositories/price_domains_repository.dart';
import '../widgets/choice_container.dart';
import '../widgets/fetch_result.dart';
import '../widgets/my_dropdown_list.dart';
import '../widgets/price_picker.dart';
import 'estates_screen.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({Key? key}) : super(key: key);

  @override
  State<FilterSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<FilterSearchScreen> {
  // Blocs and cubits:
  ChannelCubit patternCubit = ChannelCubit(null);
  ChannelCubit locationDetectedCubit = ChannelCubit(false);
  ChannelCubit startPriceCubit = ChannelCubit(0);
  ChannelCubit endPriceCubit = ChannelCubit(0);
  ChannelCubit isSellCubit = ChannelCubit(true);
  ChannelCubit isAreaSearchCubit = ChannelCubit(true);
  ChannelCubit isPressSearchCubit = ChannelCubit(false);

  PriceDomainsBloc priceDomainsBloc =
      PriceDomainsBloc(PriceDomainsRepository());
  EstateTypesBloc estateTypesBloc = EstateTypesBloc(EstateTypesRepository());
  RegionsBloc regionsBloc = RegionsBloc();

  // controllers:
  TextEditingController locationController = TextEditingController();

  // others:
  late List<dynamic> locations;
  List<EstateType>? estatesTypes;
  PriceDomain? priceDomains;
  late List<OwnershipType> ownershipsTypes;
  late List<InteriorStatus> interiorStatuses;
  List<NewSearchType> searchTypes = [
    NewSearchType.neighborhood,
    NewSearchType.area
  ];

  SearchData searchData = SearchData();

  bool isSell = false;
  bool isLands = false;
  bool isShops = false;
  bool isHouse = false;
  bool isFarmsAndVacations = false;
  RegionViewer? selectedRegion;
  String? token;
  SfRangeValues? values;

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
      print(userToken);
    }
    // priceDomainsBloc.add(PriceDomainsFetchStarted(isSell ? "sale" : "rent"));
    // estateTypesBloc.add(EstateTypesFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    locationController.text = AppLocalizations.of(context)!.enter_location_name;
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xff26282B) : null,
        title: Text(AppLocalizations.of(context)!.search),
      ),
      body: BlocBuilder<ChannelCubit, dynamic>(
        bloc: isAreaSearchCubit,
        builder: (_, isArea) {
          return ListView(
            children: [
              Container(
                padding: kMediumSymHeight,
                child: buildSearchWidgets(isDark),
              ),
            ],
          );
        },
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
                          if (locationDetectedCubit.state == false) {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)!.search);
                          }
                          print("ghina : ${searchData.estateOfferTypeId}"
                              "${searchData.estateTypeId}"
                              "${searchData.locationId}"
                              "${searchData.priceMin}"
                              "${searchData.priceMax}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EstatesScreen(
                                searchData: searchData,
                                eventSearch: EstateFetchStarted(
                                  searchData: SearchData(
                                      locationId: searchData.locationId,
                                      estateTypeId: searchData.estateTypeId,
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
                          locationController.clear();
                          isSellCubit.setState(true);
                          isAreaSearchCubit.setState(true);
                          locationDetectedCubit.setState(false);
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
            textRight: AppLocalizations.of(context)!.sell,
            textLeft: AppLocalizations.of(context)!.rent,
            onTapRight: () {
              searchData.estateOfferTypeId = 1;
            },
            onTapLeft: () {
              searchData.estateOfferTypeId = 2;
            }),
        buildLocation(isDark),
        buildEstateType(),
        buildPriceDomain(isDark),
      ],
    );
  }

  Widget buildEstateType() {
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
        kHe12,
        BlocBuilder<EstateTypesBloc, EstateTypesState>(
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
        ),
        kHe24,
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
                                    searchData.priceMin = startPriceCubit.state;
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
                                          color: AppColors.primaryColor,
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
                                            color: AppColors.primaryColor,
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
            textRight: AppLocalizations.of(context)!.search_by_area,
            textLeft: AppLocalizations.of(context)!.search_neighborhood,
            onTapRight: () {
              locationController.text =
                  AppLocalizations.of(context)!.enter_location_name;
            },
            onTapLeft: () {
              locationController.text =
                  AppLocalizations.of(context)!.enter_neighborhood_name;
            }),
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: isAreaSearchCubit,
          builder: (_, isArea) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                margin: EdgeInsets.only(
                  bottom: 8.h,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RegionScreen(
                                  locationController: locationController,
                                  isPressSearchCubit: isPressSearchCubit,
                                  isArea: isAreaSearchCubit.state,
                                  locationId: searchData.locationId,
                                )));
                    isPressSearchCubit.setState(false);
                  },
                  child: BlocBuilder<ChannelCubit, dynamic>(
                    bloc: isPressSearchCubit,
                    builder: (_, isPress) {
                      return Center(
                        child: Row(
                          children: [
                            Text(locationController.text),
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

  BlocBuilder buildLocationDetector() {
    return BlocBuilder<LocationsBloc, LocationsState>(
      builder: (_, locationsFetchState) {
        if (locationsFetchState is LocationsFetchComplete) {
          return BlocBuilder<ChannelCubit, dynamic>(
            bloc: patternCubit,
            builder: (_, pattern) {
              List<LocationViewer> locations =
                  BlocProvider.of<LocationsBloc>(context)
                      .getLocationsViewers(pattern, context);
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () async {
                      // set location name in location text field:
                      locationController.text =
                          locations.elementAt(index).getLocationName();
                      // initialize search data again :
                      // initializeOfferData();
                      // set search data location id:
                      searchData.locationId = locations.elementAt(index).id;
                      // set location detected state :
                      locationDetectedCubit.setState(true);
                      // unfocused text field :
                      FocusScope.of(context).unfocus();
                      // save location as recent search:
                      // await saveAsRecentSearch(
                      //     locations.elementAt(index).id!);

                      isPressSearchCubit.setState(false);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 8.h,
                      ),
                      padding: kMediumSymWidth,
                      width: inf,
                      child: Text(
                        locations.elementAt(index).getLocationName(),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return const Divider();
                },
                itemCount: locations.length,
              );
            },
          );
        }
        return Container();
      },
    );
  }

  Widget buildRegionsDetector() {
    return BlocBuilder<RegionsBloc, RegionsState>(
      builder: (_, regionsFetchState) {
        if (regionsFetchState is RegionsFetchComplete) {
          return BlocBuilder<ChannelCubit, dynamic>(
            bloc: patternCubit,
            builder: (_, pattern) {
              List<RegionViewer> locations =
                  BlocProvider.of<RegionsBloc>(context)
                      .getRegionsViewers(pattern, context);
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () async {
                      // set location name in location text field:
                      locationController.text =
                          locations.elementAt(index).getLocationName();
                      // print(locations.elementAt(index).locationName);
                      // initialize search data again :
                      //initializeOfferData();
                      // set search data location id:
                      searchData.locationId = locations.elementAt(index).id;
                      // set location detected state :
                      locationDetectedCubit.setState(true);
                      // unfocused text field :
                      FocusScope.of(context).unfocus();
                      // save location as recent search:
                      //TODO : add recent search to data base
                      // await saveAsRecentSearch(
                      //     locations.elementAt(index).id!);

                      isPressSearchCubit.setState(false);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 8.h,
                      ),
                      padding: kMediumSymWidth,
                      width: inf,
                      child: Text(
                        locations.elementAt(index).getLocationName(),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return const Divider();
                },
                itemCount: locations.length,
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
