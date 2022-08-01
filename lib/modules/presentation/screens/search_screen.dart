import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/models/interior_status.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/models/price_domain.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/screens/estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_location_screen.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/row_informations_choices.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/providers/locale_provider.dart';

class SearchScreen extends StatefulWidget {
  static const String id = "SearchScreen1";

  final SearchData searchData;

  const SearchScreen({Key? key, required this.searchData}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Blocs and cubits:
  ChannelCubit patternCubit = ChannelCubit(null);
  ChannelCubit locationDetectedCubit = ChannelCubit(false);
  ChannelCubit advancedSearchOpenedCubit = ChannelCubit(false);
  ChannelCubit searchTypeCubit = ChannelCubit(NewSearchType.area);
  RegionsBloc regionsBloc = RegionsBloc();

  // controllers:
  TextEditingController locationController = TextEditingController();
  TextEditingController textFieldController = TextEditingController();

  // others:
  late List<Location> region;
  late List<EstateType> estatesTypes;
  late List<PriceDomain> priceDomains;
  late List<OwnershipType> ownershipsTypes;
  late List<InteriorStatus> interiorStatuses;
  bool isSell = false;
  bool isLands = false;
  bool isShops = false;
  bool isHouse = false;
  bool isFarmsAndVacations = false;
  RegionViewer? selectedRegion;
  String? token;
  final _formKey = GlobalKey<FormState>();

  initializeEstateBooleanVariables() {
    isSell = (widget.searchData.estateOfferTypeId == sellOfferTypeNumber);
    isHouse = (widget.searchData.estateTypeId == housePropertyTypeNumber);
    isLands = (widget.searchData.estateTypeId == landsPropertyTypeNumber);
    isShops = (widget.searchData.estateTypeId == shopsPropertyTypeNumber);
    isFarmsAndVacations = ((widget.searchData.estateTypeId == farmsPropertyTypeNumber) ||
        (widget.searchData.estateTypeId == vacationsPropertyTypeNumber));
  }

  initializeOfferData({bool justInitAdvanced = false}) {
    if (!justInitAdvanced) {
      widget.searchData.estateTypeId = estatesTypes.first.id;
    }
    if (!justInitAdvanced) widget.searchData.priceDomainId = null;
    if (!justInitAdvanced) widget.searchData.locationId = null;
    widget.searchData.isFurnished = null;
    widget.searchData.hasSwimmingPool = null;
    widget.searchData.isOnBeach = null;
    widget.searchData.interiorStatusId = null;
    widget.searchData.ownershipId = null;
    initializeEstateBooleanVariables();
  }

  String? userToken;
  late bool isArabic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Fetch lists :
    region = BlocProvider
        .of<RegionsBloc>(context)
        .locations ?? [];
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;
    ownershipsTypes = BlocProvider.of<OwnershipTypeBloc>(context).ownershipTypes!;
    interiorStatuses = BlocProvider.of<InteriorStatusesBloc>(context).interiorStatuses!;

    // Initialize search data :
    initializeOfferData();

    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null && user.token != null) {
      userToken = user.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: isDarkMode ? const Color(0xff26282B) : null,
          title: Row(
            children: [
              Text(
                isSell
                    ? AppLocalizations.of(context)!.sell_estates
                    : AppLocalizations.of(context)!.rent_estates,
                style: TextStyle(fontSize: 17),
              ),
              const Spacer(),
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: searchTypeCubit,
                builder: (_, searchType) {
                  return InkWell(
                    onTap: () {
                      textFieldController.clear();
                      locationController.clear();
                      regionsBloc.add(SearchRegionCleared());
                      searchTypeCubit.setState((searchType == NewSearchType.area)
                          ? NewSearchType.neighborhood
                          : NewSearchType.area);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8,left: 8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(color: AppColors.white),
                        ),
                        child: Text(
                          (searchType == NewSearchType.area)
                              ? AppLocalizations.of(context)!.search_neighborhood
                              : AppLocalizations.of(context)!.search_by_area,
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: AppColors.white, fontSize: 15.sp),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(64.h),
            child: Container(
              margin: EdgeInsets.only(
                bottom: 8.h,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              child: Center(
                child: BlocBuilder<ChannelCubit, dynamic>(
                  bloc: searchTypeCubit,
                  builder: (_, searchType){
                    return TextField(
                      readOnly: locationDetectedCubit.state,
                      onTap: () {
                        if(searchType == NewSearchType.area){
                          locationController.clear();
                          locationDetectedCubit.setState(false);
                          patternCubit.setState(null);

                          if (locationController.text.isEmpty) {
                            patternCubit.setState("");
                            return;
                          }
                        }else{
                          locationController.clear();
                          locationDetectedCubit.setState(false);
                          patternCubit.setState(null);

                          if (locationController.text.isEmpty) {
                            patternCubit.setState("");
                            return;
                          }
                        }
                      },
                      controller: locationController,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: AppColors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                        ),
                        border: kUnderlinedBorderWhite,
                        focusedBorder: kUnderlinedBorderWhite,
                        enabledBorder: kUnderlinedBorderWhite,
                        hintText: (searchType == NewSearchType.area)
                            ? AppLocalizations.of(context)!.enter_area_name
                            : AppLocalizations.of(context)!.enter_neighborhood_name ,
                        hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.white.withOpacity(0.48),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          regionsBloc.add(SearchRegionCleared());
                          return;
                        }else{
                          patternCubit.setState(value);
                        }
                      },
                    );
                  }
                ),
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SizedBox(
            height: 1.sh,
            child: Stack(children: [
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: searchTypeCubit,
                  builder: (_, searchType) {
                  if(searchType == NewSearchType.area){
                   return Container(
                      padding: kMediumSymHeight,
                      child: BlocBuilder<ChannelCubit, dynamic>(
                        bloc: locationDetectedCubit,
                        builder: (_, isLocationDetected) {
                          return (isLocationDetected) ? buildSearchWidgets() : buildRegionsDetector();
                        },
                      ),
                    );
                  }
                  return  Container(
                    padding: kMediumSymHeight,
                    child: BlocBuilder<ChannelCubit, dynamic>(
                      bloc: locationDetectedCubit,
                      builder: (_, isLocationDetected) {
                        return (isLocationDetected) ? buildSearchWidgets() : buildLocationDetector();
                      },
                    ),
                  );
                  }
              ),
              (locationDetectedCubit.state)
                  ? Positioned(
                      bottom: 0,
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
                                      style: Theme.of(context).textTheme.headline5!.copyWith(
                                          color: Theme.of(context).colorScheme.background,
                                          height: 1.4),
                                    ),
                                    kWi8,
                                    Icon(
                                      Icons.search,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  if (locationDetectedCubit.state == false) {
                                    Fluttertoast.showToast(msg: AppLocalizations.of(context)!.search);
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EstatesScreen(
                                              searchData: EstateFetchStarted(
                                                searchData: widget.searchData,
                                                isAdvanced: advancedSearchOpenedCubit
                                                    .state,
                                                token: userToken,
                                              ),
                                            ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            kWi4,
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: isDarkMode ? const Color(0xff90B8F8) : null,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(20.w, 60.h),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.clear,
                                ),
                                onPressed: () {
                                  locationController.clear();
                                  locationDetectedCubit.setState(false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ]),
          ),
        ),
      ),
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
                  BlocProvider.of<LocationsBloc>(context).getLocationsViewers(pattern);
              return (pattern == null)
                  ? buildRecentSearchedPlaces()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () async {
                            // set location name in location text field:
                            locationController.text = locations.elementAt(index).getLocationName();
                            // initialize search data again :
                            initializeOfferData();
                            // set search data location id:
                            widget.searchData.locationId = locations.elementAt(index).id;
                            // set location detected state :
                            locationDetectedCubit.setState(true);
                            // unfocused text field :
                            FocusScope.of(context).unfocus();
                            // save location as recent search:
                            await saveAsRecentSearch(locations.elementAt(index).id);
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
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

  BlocBuilder buildRegionsDetector() {
    return BlocBuilder<RegionsBloc, RegionsState>(
      builder: (_, regionsFetchState) {
        if (regionsFetchState is RegionsFetchComplete) {
          return BlocBuilder<ChannelCubit, dynamic>(
            bloc: patternCubit,
            builder: (_, pattern) {
              List<RegionViewer> locations =
                  BlocProvider.of<RegionsBloc>(context).getRegionsViewers(pattern);
              return (pattern == null)
                  ? buildRecentSearchedPlaces()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () async {
                            // set location name in location text field:
                            locationController.text = locations.elementAt(index).getRegionName();
                            // initialize search data again :
                            initializeOfferData();
                            // set search data location id:
                            widget.searchData.locationId = locations.elementAt(index).id;
                            // set location detected state :
                            locationDetectedCubit.setState(true);
                            // unfocused text field :
                            FocusScope.of(context).unfocus();
                            // save location as recent search:
                            await saveAsRecentSearch(locations.elementAt(index).id);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 8.h,
                            ),
                            padding: kMediumSymWidth,
                            width: inf,
                            child: Text(
                              locations.elementAt(index).getRegionName(),
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
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

  BlocBuilder buildSubRegionsDetector() {
    return BlocBuilder<RegionsBloc, RegionsState>(
      builder: (_, regionsFetchState) {
        if (regionsFetchState is RegionsFetchComplete) {
          return BlocBuilder<ChannelCubit, dynamic>(
            bloc: patternCubit,
            builder: (_, pattern) {
              List<RegionViewer> locations =
                  BlocProvider.of<RegionsBloc>(context).getRegionsViewers(pattern);
              return (pattern == null)
                  ? buildRecentSearchedPlaces()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () async {
                            // set location name in location text field:
                            locationController.text = locations.elementAt(index).getRegionName();
                            // initialize search data again :
                            initializeOfferData();
                            // set search data location id:
                            widget.searchData.locationId = locations.elementAt(index).id;
                            // set location detected state :
                            locationDetectedCubit.setState(true);
                            // unfocused text field :
                            FocusScope.of(context).unfocus();
                            // save location as recent search:
                            await saveAsRecentSearch(locations.elementAt(index).id);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 8.h,
                            ),
                            padding: kMediumSymWidth,
                            width: inf,
                            child: Text(
                              locations.elementAt(index).getRegionName(),
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
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

  List<LocationViewer>? getStoredRecentSearches() {
    // TODO: get data from shared preferences :
    List<String>? storedRecentSearches = RecentSearchesSharedPreferences.getRecentSearches();
    storedRecentSearches ??= [];
    List<LocationViewer> locationsViewers = [];
    List<Location>? locations = BlocProvider.of<LocationsBloc>(context).locations;
    for (var locationId in storedRecentSearches) {
      for (Location parentLocation in locations!) {
        for (Location childLocation in parentLocation.locations!) {
          if (childLocation.id == int.parse(locationId)) {
            locationsViewers.add(
              LocationViewer(childLocation.name, parentLocation.name, childLocation.id),
            );
          }
        }
      }
    }
    return locationsViewers;
  }

  Column buildRecentSearchedPlaces() {
    List<LocationViewer> recentPlaces = getStoredRecentSearches() ?? [];

    return Column(
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
                        style: ElevatedButton.styleFrom(fixedSize: Size(120.w, 56.h)),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(fixedSize: Size(120.w, 56.h)),
                        child: Text(
                          AppLocalizations.of(context)!.yes,
                        ),
                        onPressed: () async {
                          await RecentSearchesSharedPreferences.removeRecentSearches();
                          patternCubit.setState(null);
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
                    locationController.text = recentPlaces.elementAt(index).getLocationName();
                    // set search data location id :
                    widget.searchData.locationId = recentPlaces.elementAt(index).id;
                    // change location detect state to detected :
                    locationDetectedCubit.setState(true);
                    // unfocused location textField :
                    FocusScope.of(context).unfocus();
                    // store search :
                    await saveAsRecentSearch(recentPlaces.elementAt(index).id);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    documentOutlineIconPath,
                    width: 250.w,
                    height: 250.w,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.24),
                  ),
                  kHe24,
                  Text(
                    AppLocalizations.of(context)!.no_recent_searches,
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ]
      ],
    );
  }

  SingleChildScrollView buildSearchWidgets() {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

    List<String> priceDomainsNames =
        priceDomains.map((e) => e.getTextPriceDomain(isArabic)).toList();
    priceDomainsNames.insert(0, AppLocalizations.of(context)!.unselected);
    priceDomainsNames = priceDomainsNames.toSet().toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.estate_type + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe12,
          MyDropdownList(
            elementsList: estatesTypes.map((e) => e.getName(isArabic).split('|').first).toList(),
            onSelect: (index) {
              // set search data estate type :
              widget.searchData.estateTypeId = estatesTypes.elementAt(index).id;
              // close advanced search section:
              advancedSearchOpenedCubit.setState(false);
            },
            validator: (value) =>
            value == null ? AppLocalizations.of(context)!.this_field_is_required: null,
            selectedItem: AppLocalizations.of(context)!.please_select,
          ),
          kHe24,
          Text(
            AppLocalizations.of(context)!.price_domain + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe12,
          MyDropdownList(
            elementsList: priceDomainsNames,
            onSelect: (index) {
              // set search data price domain:
              bool isNoneSelected = (index == 0);
              widget.searchData.priceDomainId =
                  (isNoneSelected) ? null : priceDomains.elementAt(index - 1).id;
            },
            validator: (value) =>
            value == null ? AppLocalizations.of(context)!.this_field_is_required: null,
            selectedItem: AppLocalizations.of(context)!.please_select,
          ),
          kHe24,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: advancedSearchOpenedCubit,
            builder: (_, isAdvancedSearchOpened) {
              // initialize advanced search data every time this section open:
              if (isAdvancedSearchOpened) {
                initializeOfferData(justInitAdvanced: true);
              }
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      // change advanced search section open state :
                      advancedSearchOpenedCubit.setState(!isAdvancedSearchOpened);
                    },
                    child: Container(
                      height: 40.h,
                      color:
                          isDark ? Theme.of(context).colorScheme.primary : AppColors.secondaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.advanced_search,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: AppColors.black),
                          ),
                          kWi8,
                          Icon(
                              (isAdvancedSearchOpened)
                                  ? Icons.arrow_drop_down
                                  : ((!isArabic) ? Icons.arrow_right : Icons.arrow_left),
                              color: AppColors.black),
                        ],
                      ),
                    ),
                  ),
                  if (isAdvancedSearchOpened) buildAdvancedSearchWidgets(),
                ],
              );
            },
          ),
          72.verticalSpace,
        ],
      ),
    );
  }

  Column buildAdvancedSearchWidgets() {
    List<String> choices = [
      AppLocalizations.of(context)!.unselected,
      AppLocalizations.of(context)!.yes,
      AppLocalizations.of(context)!.no
    ];
    List<String> ownerShipTypesNames = ownershipsTypes.map((e) => e.getName(isArabic)).toList();
    ownerShipTypesNames.insert(
      0,
      AppLocalizations.of(context)!.unselected,
    );
    List<String> interiorStatusesNames = interiorStatuses.map((e) => e.getName(isArabic)).toList();
    interiorStatusesNames.insert(
      0,
      AppLocalizations.of(context)!.unselected,
    );

    return Column(
      children: [
        if (isSell) ...[
          kHe24,
          SizedBox(
            width: inf,
            child: Text(
              AppLocalizations.of(context)!.ownership_type + " :",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          kHe12,
          MyDropdownList(
            elementsList: ownerShipTypesNames,
            onSelect: (index) {
              // set search data ownership type :
              bool isNoneSelected = index == 0;
              widget.searchData.ownershipId =
                  (isNoneSelected) ? null : ownershipsTypes.elementAt(index - 1).id;
            },
            validator: (value) =>
            value == null ? AppLocalizations.of(context)!.this_field_is_required: null,
            selectedItem: AppLocalizations.of(context)!.please_select,
          ),
        ],
        if (!isLands && !isShops) ...[
          kHe24,
          SizedBox(
            width: inf,
            child: Text(
              AppLocalizations.of(context)!.interior_status + " :",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          kHe12,
          MyDropdownList(
            elementsList: interiorStatusesNames,
            onSelect: (index) {
              // set search data interior status :
              bool isNoneSelected = index == 0;
              widget.searchData.interiorStatusId =
                  (isNoneSelected) ? null : interiorStatuses.elementAt(index - 1).id;
            },
            validator: (value) =>
            value == null ? AppLocalizations.of(context)!.this_field_is_required: null,
            selectedItem: AppLocalizations.of(context)!.please_select,
          ),
        ],
        if (isHouse) ...[
          kHe24,
          RowInformationChoices(
            content: AppLocalizations.of(context)!.is_the_estate_furnished,
            choices: choices,
            onSelect: (currentIndex) {
              // set search data furnished status :
              widget.searchData.isFurnished =
                  (currentIndex == 0) ? null : ((currentIndex == 1) ? true : false);
            },
            hasSpacerBetween: true,
          ),
        ],
        if (isFarmsAndVacations) ...[
          kHe24,
          RowInformationChoices(
            content: AppLocalizations.of(context)!.has_swimming_pool,
            choices: choices,
            onSelect: (currentIndex) {
              // set search data Pool status :
              widget.searchData.hasSwimmingPool =
                  (currentIndex == 0) ? null : ((currentIndex == 1) ? true : false);
            },
            hasSpacerBetween: true,
          ),
          kHe24,
          RowInformationChoices(
            content: AppLocalizations.of(context)!.is_the_estate_on_beach,
            choices: choices,
            onSelect: (currentIndex) {
              // set search data Beach status :
              widget.searchData.isOnBeach =
                  (currentIndex == 0) ? null : ((currentIndex == 1) ? true : false);
            },
            hasSpacerBetween: true,
          ),
        ],
      ],
    );
  }

  Future<void> saveAsRecentSearch(int locationId) async {
    List<String>? recentSearches = RecentSearchesSharedPreferences.getRecentSearches();
    recentSearches ??= [];
    if (recentSearches.contains(locationId.toString())) {
      recentSearches.remove(locationId.toString());
    }
    recentSearches.insert(0, locationId.toString());
    await RecentSearchesSharedPreferences.setRecentSearches(recentSearches);
  }
}
