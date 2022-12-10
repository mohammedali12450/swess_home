import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_state.dart';
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
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/row_informations_choices.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_event.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_state.dart';
import '../../business_logic_components/bloc/price_domains_bloc/price_domains_event.dart';
import '../../data/providers/locale_provider.dart';

import '../../data/repositories/estate_types_repository.dart';
import '../../data/repositories/price_domains_repository.dart';
import '../widgets/fetch_result.dart';
import '../widgets/price_picker.dart';

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
  ChannelCubit startPriceCubit = ChannelCubit(0);
  ChannelCubit endPriceCubit = ChannelCubit(0);
  ChannelCubit searchTypeCubit = ChannelCubit(NewSearchType.neighborhood);

  RegionsBloc regionsBloc = RegionsBloc();
  PriceDomainsBloc priceDomainsBloc =
      PriceDomainsBloc(PriceDomainsRepository());
  EstateTypesBloc estateTypesBloc = EstateTypesBloc(EstateTypesRepository());

  // controllers:
  TextEditingController locationController = TextEditingController();
  TextEditingController textFieldController = TextEditingController();
  TextEditingController startPriceController = TextEditingController();
  TextEditingController endPriceController = TextEditingController();

  // others:
  late List<Location> region;
  List<EstateType>? estatesTypes;
  PriceDomain? priceDomains;
  late List<OwnershipType> ownershipsTypes;
  late List<InteriorStatus> interiorStatuses;
  List<NewSearchType> searchTypes = [
    NewSearchType.neighborhood,
    NewSearchType.area
  ];

  bool isSell = false;
  bool isLands = false;
  bool isShops = false;
  bool isHouse = false;
  bool isFarmsAndVacations = false;
  RegionViewer? selectedRegion;
  String? token;
  final _formKey = GlobalKey<FormState>();
  SfRangeValues? values;

  initializeEstateBooleanVariables() {
    isSell = (widget.searchData.estateOfferTypeId == sellOfferTypeNumber);
    isHouse = (widget.searchData.estateTypeId == housePropertyTypeNumber);
    isLands = (widget.searchData.estateTypeId == landsPropertyTypeNumber);
    isShops = (widget.searchData.estateTypeId == shopsPropertyTypeNumber);
    isFarmsAndVacations =
        ((widget.searchData.estateTypeId == farmsPropertyTypeNumber) ||
            (widget.searchData.estateTypeId == vacationsPropertyTypeNumber));
  }

  initializeOfferData({bool justInitAdvanced = false}) {
    if (!justInitAdvanced) widget.searchData.estateTypeId = null;
    if (!justInitAdvanced) widget.searchData.priceDomainId = null;
    if (!justInitAdvanced) widget.searchData.locationId = null;
    widget.searchData.isFurnished = null;
    widget.searchData.hasSwimmingPool = null;
    widget.searchData.isOnBeach = null;
    // widget.searchData.interiorStatusId = null;
    // widget.searchData.ownershipId = null;
    initializeEstateBooleanVariables();
  }

  String? userToken;
  late bool isArabic;

  @override
  void initState() {
    super.initState();

    // Fetch lists :
    region = BlocProvider.of<RegionsBloc>(context).locations ?? [];
    // estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    ownershipsTypes =
        BlocProvider.of<OwnershipTypeBloc>(context).ownershipTypes!;
    interiorStatuses =
        BlocProvider.of<InteriorStatusesBloc>(context).interiorStatuses!;
    //priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;

    // Initialize search data :
    initializeOfferData();

    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null) {
      userToken = UserSharedPreferences.getAccessToken();
      print(userToken);
    }
    priceDomainsBloc.add(PriceDomainsFetchStarted(isSell ? "sale" : "rent"));
    estateTypesBloc.add(EstateTypesFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: isDark ? const Color(0xff26282B) : null,
          title: Row(children: [
            Text(
              isSell
                  ? AppLocalizations.of(context)!.sell_estates
                  : AppLocalizations.of(context)!.rent_estates,
              style: const TextStyle(fontSize: 17),
            ),
            const Spacer(),
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: searchTypeCubit,
              builder: (_, searchType) {
                return Padding(
                  padding: EdgeInsets.only(left: 18.w, top: 8.w, right: 18.w),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        )),
                    padding:
                        EdgeInsets.only(right: 8.w, bottom: 3.w, left: 8.w),
                    height: 48.h,
                    width: 160.w,
                    child: buildDropDown(isDark),
                  ),
                );
              },
            ),
          ]),
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
                    builder: (_, searchType) {
                      return TextFormField(
                        validator: (value) => value == null
                            ? AppLocalizations.of(context)!
                                .this_field_is_required
                            : null,
                        readOnly: locationDetectedCubit.state,
                        onTap: () {
                          if (searchType == NewSearchType.area) {
                            locationController.clear();
                            locationDetectedCubit.setState(false);
                            patternCubit.setState(null);
                            FocusScope.of(context).unfocus();

                            if (locationController.text.isEmpty) {
                              patternCubit.setState("");
                              return;
                            }
                          } else {
                            locationController.clear();
                            locationDetectedCubit.setState(false);
                            patternCubit.setState(null);
                            FocusScope.of(context).unfocus();

                            if (locationController.text.isEmpty) {
                              patternCubit.setState("");
                              return;
                            }
                          }
                        },
                        controller: locationController,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: AppColors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                          ),
                          border: kUnderlinedBorderWhite,
                          focusedBorder: kUnderlinedBorderWhite,
                          enabledBorder: kUnderlinedBorderWhite,
                          hintText: (searchType == NewSearchType.area)
                              ? AppLocalizations.of(context)!.enter_area_name
                              : AppLocalizations.of(context)!
                                  .enter_neighborhood_name,
                          hintStyle:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.white.withOpacity(0.48),
                                  ),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            regionsBloc.add(SearchRegionCleared());
                            return;
                          } else {
                            patternCubit.setState(value);
                          }
                        },
                      );
                    }),
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
                    if (searchType == NewSearchType.area) {
                      return Container(
                        padding: kMediumSymHeight,
                        child: BlocBuilder<ChannelCubit, dynamic>(
                          bloc: locationDetectedCubit,
                          builder: (_, isLocationDetected) {
                            return (isLocationDetected)
                                ? buildSearchWidgets(isDark)
                                : buildRegionsDetector();
                          },
                        ),
                      );
                    }
                    return Container(
                      padding: kMediumSymHeight,
                      child: BlocBuilder<ChannelCubit, dynamic>(
                        bloc: locationDetectedCubit,
                        builder: (_, isLocationDetected) {
                          return (isLocationDetected)
                              ? buildSearchWidgets(isDark)
                              : buildLocationDetector();
                        },
                      ),
                    );
                  }),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              height: 1.4),
                                    ),
                                    kWi8,
                                    Icon(
                                      Icons.search,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  if (locationDetectedCubit.state == false) {
                                    Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)!
                                            .search);
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    print(widget.searchData.toJson(true));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EstatesScreen(
                                          searchData: EstateFetchStarted(
                                            searchData: widget.searchData,
                                            isAdvanced:
                                                advancedSearchOpenedCubit.state,
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
                                  primary:
                                      isDark ? const Color(0xff90B8F8) : null,
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
                  BlocProvider.of<LocationsBloc>(context)
                      .getLocationsViewers(pattern);
              return (pattern == null)
                  ? buildRecentSearchedPlaces()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () async {
                            // set location name in location text field:
                            locationController.text =
                                locations.elementAt(index).getLocationName();
                            // initialize search data again :
                            initializeOfferData();
                            // set search data location id:
                            widget.searchData.locationId =
                                locations.elementAt(index).id;
                            // set location detected state :
                            locationDetectedCubit.setState(true);
                            // unfocused text field :
                            FocusScope.of(context).unfocus();
                            // save location as recent search:
                            // await saveAsRecentSearch(
                            //     locations.elementAt(index).id!);
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
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
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
                  BlocProvider.of<RegionsBloc>(context)
                      .getRegionsViewers(pattern);
              return (pattern == null)
                  ? buildRecentSearchedPlaces()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () async {
                            // set location name in location text field:
                            locationController.text =
                                locations.elementAt(index).getRegionName();
                            // initialize search data again :
                            initializeOfferData();
                            // set search data location id:
                            widget.searchData.locationId =
                                locations.elementAt(index).id;
                            // set location detected state :
                            locationDetectedCubit.setState(true);
                            // unfocused text field :
                            FocusScope.of(context).unfocus();
                            // save location as recent search:
                            await saveAsRecentSearch(
                                locations.elementAt(index).id!);
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
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
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

// BlocBuilder buildSubRegionsDetector() {
//   return BlocBuilder<RegionsBloc, RegionsState>(
//     builder: (_, regionsFetchState) {
//       if (regionsFetchState is RegionsFetchComplete) {
//         return BlocBuilder<ChannelCubit, dynamic>(
//           bloc: patternCubit,
//           builder: (_, pattern) {
//             List<RegionViewer> locations =
//                 BlocProvider.of<RegionsBloc>(context).getRegionsViewers(pattern);
//             return (pattern == null)
//                 ? buildRecentSearchedPlaces()
//                 : ListView.separated(
//                     shrinkWrap: true,
//                     itemBuilder: (_, index) {
//                       return InkWell(
//                         onTap: () async {
//                           // set location name in location text field:
//                           locationController.text = locations.elementAt(index).getRegionName();
//                           // initialize search data again :
//                           initializeOfferData();
//                           // set search data location id:
//                           widget.searchData.locationId = locations.elementAt(index).id;
//                           // set location detected state :
//                           locationDetectedCubit.setState(true);
//                           // unfocused text field :
//                           FocusScope.of(context).unfocus();
//                           // save location as recent search:
//                           await saveAsRecentSearch(locations.elementAt(index).id);
//                         },
//                         child: Container(
//                           margin: EdgeInsets.symmetric(
//                             vertical: 8.h,
//                           ),
//                           padding: kMediumSymWidth,
//                           width: inf,
//                           child: Text(
//                             locations.elementAt(index).getRegionName(),
//                             textAlign: TextAlign.right,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle1!
//                                 .copyWith(color: Theme.of(context).colorScheme.onBackground),
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (_, index) {
//                       return const Divider();
//                     },
//                     itemCount: locations.length,
//                   );
//           },
//         );
//       }
//       return Container();
//     },
//   );
// }

  DropdownButtonFormField buildDropDown(isDark) {
    return DropdownButtonFormField(
      icon: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.white,
        ),
      ),
      dropdownColor: isDark ? const Color(0xff26282B) : AppColors.primaryColor,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 8.w),
          hintText: AppLocalizations.of(context)!.search_neighborhood,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          )),
      isExpanded: true,
      items: searchTypes.map(
        (NewSearchType element) {
          return DropdownMenuItem(
            value: element,
            child: Container(
              width: 1.sw,
              margin: EdgeInsets.only(
                right:
                    Provider.of<LocaleProvider>(context).isArabic() ? 16.w : 0,
                left:
                    Provider.of<LocaleProvider>(context).isArabic() ? 0 : 16.w,
              ),
              child: Text(
                (element.name == "area")
                    ? AppLocalizations.of(context)!.search_by_area
                    : AppLocalizations.of(context)!.search_neighborhood,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ).toList(),
      onChanged: (value) {
        searchTypeCubit.setState(value);
        textFieldController.clear();
        locationController.clear();
        regionsBloc.add(SearchRegionCleared());
      },
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
                    widget.searchData.locationId =
                        recentPlaces.elementAt(index).id;
                    // change location detect state to detected :
                    locationDetectedCubit.setState(true);
                    // unfocused location textField :
                    FocusScope.of(context).unfocus();
                    // store search :
                    await saveAsRecentSearch(recentPlaces.elementAt(index).id!);
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.24),
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

  SingleChildScrollView buildSearchWidgets(isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.estate_type + " :",
            style: Theme.of(context).textTheme.headline6,
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
                // List<String> estateTypesAdd =
                //     estatesTypes!.map((e) => e.name.split('|').first).toList();
                // estateTypesAdd.insert(
                //   0,
                //   AppLocalizations.of(context)!.undefined,
                // );
                // estateTypesAdd = estateTypesAdd.toSet().toList();
              }
              return MyDropdownList(
                elementsList:
                    estatesTypes!.map((e) => e.name.split('|').first).toList(),
                onSelect: (index) {
                  // set search data estate type :
                  widget.searchData.estateTypeId =
                      estatesTypes!.elementAt(index).id;
                  // close advanced search section:
                  advancedSearchOpenedCubit.setState(false);
                },
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.this_field_is_required
                    : null,
                selectedItem: AppLocalizations.of(context)!.please_select,
              );
            },
          ),
          kHe24,
          Text(
            AppLocalizations.of(context)!.price_domain + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe12,
          BlocBuilder<PriceDomainsBloc, PriceDomainsState>(
            bloc: priceDomainsBloc,
            builder: (_, priceDomainState) {
              if (priceDomainState is PriceDomainsFetchProgress) {
                return SpinKitWave(
                  color: Theme.of(context).colorScheme.background,
                  size: 24.w,
                );
              } else if (priceDomainState is PriceDomainsFetchComplete) {
                priceDomains = priceDomainState.priceDomains;
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                                await openPricePicker(
                                  context,
                                  isDark,
                                  title: AppLocalizations.of(context)!
                                      .title_min_price,
                                  items: priceDomains!.min
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
                                  },
                                );
                              },
                              child: BlocBuilder<ChannelCubit, dynamic>(
                                bloc: startPriceCubit,
                                builder: (_, state) {
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
                                    child: Text(priceDomains!.min[state]),
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
                                await openPricePicker(
                                  context,
                                  isDark,
                                  title: AppLocalizations.of(context)!
                                      .title_max_price,
                                  items: priceDomains!.max
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
                                  },
                                );
                              },
                              child: BlocBuilder<ChannelCubit, dynamic>(
                                  bloc: endPriceCubit,
                                  builder: (_, state) {
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
                                      child: Text(priceDomains!.max[state]),
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
            },
          ),
          kHe24,
          //  BlocBuilder<ChannelCubit, dynamic>(
          //    bloc: advancedSearchOpenedCubit,
          //    builder: (_, isAdvancedSearchOpened) {
          //      // initialize advanced search data every time this section open:
          //      if (isAdvancedSearchOpened) {
          //        initializeOfferData(justInitAdvanced: true);
          //      }
          //      return Column(
          //        children: [
          //          InkWell(
          //            onTap: () {
          //              // change advanced search section open state :
          //              advancedSearchOpenedCubit.setState(!isAdvancedSearchOpened);
          //            },
          //            child: Container(
          //              height: 40.h,
          //              color:
          //                  isDark ? Theme.of(context).colorScheme.primary : AppColors.secondaryColor,
          //              padding: EdgeInsets.symmetric(
          //                horizontal: 8.w,
          //              ),
          //              child: Row(
          //                mainAxisAlignment: MainAxisAlignment.start,
          //                children: [
          //                  Text(
          //                    AppLocalizations.of(context)!.advanced_search,
          //                    style: Theme.of(context)
          //                        .textTheme
          //                        .subtitle1!
          //                        .copyWith(color: AppColors.black),
          //                  ),
          //                  kWi8,
          //                  Icon(
          //                      (isAdvancedSearchOpened)
          //                          ? Icons.arrow_drop_down
          //                          : ((!isArabic) ? Icons.arrow_right : Icons.arrow_left),
          //                      color: AppColors.black),
          //                ],
          //              ),
          //            ),
          //          ),
          //          if (isAdvancedSearchOpened) buildAdvancedSearchWidgets(),
          //        ],
          //      );
          //    },
          //  ),
          // 72.verticalSpace,
        ],
      ),
    );
  }

  Column buildAdvancedSearchWidgets() {
    List<String> choices = [
      AppLocalizations.of(context)!.undefined,
      AppLocalizations.of(context)!.yes,
      AppLocalizations.of(context)!.no
    ];
    List<String> ownerShipTypesNames =
        ownershipsTypes.map((e) => e.name).toList();
    ownerShipTypesNames.insert(
      0,
      AppLocalizations.of(context)!.undefined,
    );
    List<String> interiorStatusesNames =
        interiorStatuses.map((e) => e.name).toList();
    interiorStatusesNames.insert(
      0,
      AppLocalizations.of(context)!.undefined,
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
              widget.searchData.ownershipId = (isNoneSelected)
                  ? null
                  : ownershipsTypes.elementAt(index - 1).id;
            },
            validator: (value) => value == null
                ? AppLocalizations.of(context)!.this_field_is_required
                : null,
            selectedItem: AppLocalizations.of(context)!.please_select,
          ),
        ],
        if (!isLands) ...[
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
              widget.searchData.interiorStatusId = (isNoneSelected)
                  ? null
                  : interiorStatuses.elementAt(index - 1).id;
            },
            validator: (value) => value == null
                ? AppLocalizations.of(context)!.this_field_is_required
                : null,
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
              widget.searchData.isFurnished = (currentIndex == 0)
                  ? null
                  : ((currentIndex == 1) ? true : false);
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
              widget.searchData.hasSwimmingPool = (currentIndex == 0)
                  ? null
                  : ((currentIndex == 1) ? true : false);
            },
            hasSpacerBetween: true,
          ),
          kHe24,
          RowInformationChoices(
            content: AppLocalizations.of(context)!.is_the_estate_furnished,
            choices: choices,
            onSelect: (currentIndex) {
              // set search data furnished status :
              widget.searchData.isFurnished = (currentIndex == 0)
                  ? null
                  : ((currentIndex == 1) ? true : false);
            },
            hasSpacerBetween: true,
          ),
        ],
      ],
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
