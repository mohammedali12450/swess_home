import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/models/interior_status.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/models/price_domain.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/presentation/screens/estates_screen.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/row_informations_choices.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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

  // controllers:
  TextEditingController locationController = TextEditingController();

  // others:
  late List<EstateType> estatesTypes;
  late List<PriceDomain> priceDomains;
  late List<OwnershipType> ownershipsTypes;
  late List<InteriorStatus> interiorStatuses;
  bool isSell = false;
  bool isLands = false;
  bool isShops = false;
  bool isHouse = false;
  bool isFarmsAndVacations = false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Fetch lists :
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryColor,
          automaticallyImplyLeading: false,
          toolbarHeight: Res.height(75),
          title: SizedBox(
            width: inf,
            child: ResText(
              isSell ? "عقارات للبيع" : "عقارات للإيجار",
              textStyle: textStyling(S.s20, W.w4, C.wh).copyWith(height: 1.8),
              textAlign: TextAlign.right,
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(
                right: Res.width(8),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              margin: EdgeInsets.only(
                bottom: Res.height(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Res.width(12),
              ),
              child: Center(
                child: TextField(
                  readOnly: locationDetectedCubit.state,
                  onTap: () {
                    locationController.clear();
                    locationDetectedCubit.setState(false);
                    patternCubit.setState(null);

                    if (locationController.text.isEmpty) {
                      patternCubit.setState("");
                      return;
                    }
                  },
                  controller: locationController,
                  textDirection: TextDirection.rtl,
                  style: textStyling(S.s15, W.w4, C.wh),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Res.width(8),
                    ),
                    border: kUnderlinedBorderWhite,
                    focusedBorder: kUnderlinedBorderWhite,
                    enabledBorder: kUnderlinedBorderWhite,
                    hintText: "أدخل مكان العقار. مثل:المالكي, الميدان..",
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: textStyling(S.s14, W.w4, C.whHint),
                  ),
                  onChanged: (value) {
                    patternCubit.setState(value);
                  },
                ),
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: screenHeight,
          child: Stack(children: [
            Container(
              padding: kMediumSymHeight,
              child: BlocBuilder<ChannelCubit, dynamic>(
                bloc: locationDetectedCubit,
                builder: (_, isLocationDetected) {
                  return (isLocationDetected) ? buildSearchWidgets() : buildLocationDetector();
                },
              ),
            ),
            (locationDetectedCubit.state)
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      padding: kSmallSymWidth,
                      width: screenWidth,
                      alignment: Alignment.bottomCenter,
                      height: Res.height(72),
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [lowElevation]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: MyButton(
                              child: ResText(
                                "مسح",
                                textStyle: textStyling(S.s16, W.w6, C.bl),
                              ),
                              borderRadius: 4,
                              color: AppColors.baseColor,
                              onPressed: () {
                                locationController.clear();
                                locationDetectedCubit.setState(false);
                              },
                            ),
                          ),
                          kWi4,
                          Expanded(
                            flex: 3,
                            child: MyButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: AppColors.white,
                                  ),
                                  kWi8,
                                  ResText(
                                    "ابحث",
                                    textStyle: textStyling(S.s18, W.w6, C.wh).copyWith(height: 1.8),
                                  ),
                                ],
                              ),
                              borderRadius: 4,
                              color: AppColors.secondaryColor,
                              onPressed: () {
                                if (locationDetectedCubit.state == false) {
                                  Fluttertoast.showToast(msg: "قم بتحديد مكان العقار أولا!");
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EstatesScreen(
                                      searchData: EstateFetchStarted(
                                        searchData: widget.searchData,
                                        isAdvanced: advancedSearchOpenedCubit.state,
                                        token: userToken,
                                      ),
                                    ),
                                  ),
                                );
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (pattern == null) buildRecentSearchedPlaces(),
                    if (pattern != null)
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
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
                                vertical: Res.height(8),
                              ),
                              padding: kMediumSymWidth,
                              width: inf,
                              child: ResText(
                                locations.elementAt(index).getLocationName(),
                                textAlign: TextAlign.right,
                                textStyle: textStyling(S.s16, W.w5, C.bl),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, index) {
                          return const Divider();
                        },
                        itemCount: locations.length,
                      ),
                  ],
                ),
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

  SingleChildScrollView buildRecentSearchedPlaces() {
    List<LocationViewer> recentPlaces = getStoredRecentSearches() ?? [];

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (recentPlaces.isNotEmpty) ...[
            Row(
              children: [
                kWi12,
                InkWell(
                  onTap: () async {
                    await showWonderfulAlertDialog(
                      context,
                      "تنبيه",
                      "هل تريد حذف عمليات البحث السابقة؟",
                      removeDefaultButton: true,
                      dialogButtons: [
                        MyButton(
                          child: ResText(
                            "إلغاء",
                            textStyle: textStyling(S.s16, W.w5, C.wh),
                          ),
                          color: AppColors.secondaryColor,
                          borderRadius: 8,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        MyButton(
                          child: ResText("تأكيد", textStyle: textStyling(S.s16, W.w5, C.wh)),
                          color: AppColors.secondaryColor,
                          borderRadius: 8,
                          onPressed: () async {
                            await RecentSearchesSharedPreferences.removeRecentSearches();
                            patternCubit.setState(null);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                  child: ResText(
                    "مسح الكل",
                    textStyle: textStyling(S.s15, W.w5, C.bl),
                  ),
                ),
                const Spacer(),
                ResText(
                  "عمليات البحث السابقة",
                  textStyle: textStyling(S.s16, W.w7, C.bl),
                  textAlign: TextAlign.right,
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
                        vertical: Res.height(8),
                      ),
                      padding: kMediumSymWidth,
                      width: inf,
                      child: ResText(
                        recentPlaces.elementAt(index).getLocationName(),
                        textAlign: TextAlign.right,
                        textStyle: textStyling(S.s16, W.w5, C.bl),
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Res.height(150)),
                  width: inf,
                  child: SvgPicture.asset(
                    documentOutlineIconPath,
                    width: Res.width(250),
                    height: Res.width(250),
                    color: AppColors.secondaryColor.withOpacity(0.24),
                  ),
                ),
                kHe24,
                ResText(
                  "لا يوجد عمليات بحث سابقة",
                  textStyle: textStyling(S.s24, W.w7, C.hint),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  Container buildSearchWidgets() {
    List<String> priceDomainsNames = priceDomains.map((e) => e.getTextPriceDomain(true)).toList();
    priceDomainsNames.insert(0, "غير محدد");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Res.width(16)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: inf,
              child: ResText(
                ":نوع العقار",
                textStyle: textStyling(S.s18, W.w5, C.bl),
                textAlign: TextAlign.right,
              ),
            ),
            kHe12,
            MyDropdownList(
              elementsList: estatesTypes.map((e) => e.getName(true).split('|').first).toList(),
              onSelect: (index) {
                // set search data estate type :
                widget.searchData.estateTypeId = estatesTypes.elementAt(index).id;
                // close advanced search section:
                advancedSearchOpenedCubit.setState(false);
              },
            ),
            kHe24,
            SizedBox(
              width: inf,
              child: ResText(
                ":مجال سعر العقار",
                textStyle: textStyling(S.s18, W.w5, C.bl),
                textAlign: TextAlign.right,
              ),
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
                        height: Res.height(56),
                        color: AppColors.secondaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: Res.width(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ResText(
                              "بحث متقدم",
                              textStyle: textStyling(S.s16, W.w5, C.wh),
                            ),
                            kWi8,
                            Icon(
                              (isAdvancedSearchOpened) ? Icons.arrow_drop_down : Icons.arrow_left,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isAdvancedSearchOpened) buildAdvancedSearchWidgets(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Column buildAdvancedSearchWidgets() {
    List<String> choices = ["غير محدد", "نعم", "لا"];
    List<String> ownerShipTypesNames = ownershipsTypes.map((e) => e.getName(true)).toList();
    ownerShipTypesNames.insert(0, "غير محدد");
    List<String> interiorStatusesNames = interiorStatuses.map((e) => e.getName(true)).toList();
    interiorStatusesNames.insert(0, "غير محدد");

    return Column(
      children: [
        if (isSell) ...[
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":نوع الملكية",
              textStyle: textStyling(S.s18, W.w5, C.bl),
              textAlign: TextAlign.right,
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
          ),
        ],
        if (!isLands && !isShops) ...[
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":حالة العقار",
              textStyle: textStyling(S.s18, W.w5, C.bl),
              textAlign: TextAlign.right,
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
          ),
        ],
        if (isHouse) ...[
          kHe24,
          RowInformationChoices(
            content: "هل البيت الذي تبحث عنه مفروش؟",
            choices: choices,
            onSelect: (currentIndex) {
              // set search data furnished status :
              widget.searchData.isFurnished =
                  (currentIndex == 0) ? null : ((currentIndex == 1) ? true : false);
            },
          ),
        ],
        if (isFarmsAndVacations) ...[
          kHe24,
          RowInformationChoices(
            content: "هل العقار يحوي مسبح؟",
            choices: choices,
            onSelect: (currentIndex) {
              // set search data Pool status :
              widget.searchData.hasSwimmingPool =
                  (currentIndex == 0) ? null : ((currentIndex == 1) ? true : false);
            },
          ),
          kHe24,
          RowInformationChoices(
            content: "هل العقار مطل على الشاطئ؟",
            choices: choices,
            onSelect: (currentIndex) {
              // set search data Beach status :
              widget.searchData.isOnBeach =
                  (currentIndex == 0) ? null : ((currentIndex == 1) ? true : false);
            },
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
