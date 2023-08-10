import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_by_location/estate_types_by_location_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_by_location/estate_types_by_location_event.dart';
import 'package:swesshome/modules/data/repositories/estate_types_repository.dart';
import '../../../constants/application_constants.dart';
import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/application_shared_preferences.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_event.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/estate_types_by_location/estate_types_by_location_bloc.dart';
import '../../business_logic_components/bloc/estate_types_by_location/estate_types_by_location_bloc.dart';
import '../../business_logic_components/bloc/estate_types_by_location/estate_types_by_location_bloc.dart';
import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/search_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/choice_container.dart';
import '../widgets/estate_type.dart';
import '../widgets/price_domain.dart';
import '../widgets/res_text.dart';
import '../widgets/wonderful_alert_dialog.dart';
import 'estates_screen.dart';
import 'search_location_screen.dart';
import 'search_region_screen.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({Key? key, this.name, this.id}) : super(key: key);
  final int? id;
  final String? name;

  @override
  State<FilterSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<FilterSearchScreen> {
  // Blocs and cubits:
  ChannelCubit patternCubit = ChannelCubit(null);
  ChannelCubit locationIdCubit = ChannelCubit(0);
  late ChannelCubit locationNameCubit;

  ChannelCubit isRentCubit = ChannelCubit(false);
  ChannelCubit isAreaSearchCubit = ChannelCubit(false);
  ChannelCubit isPressTypeCubit = ChannelCubit(0);
  ChannelCubit startPriceCubit = ChannelCubit(0);
  ChannelCubit endPriceCubit = ChannelCubit(4);
  EstateTypesByLocationBloc estateTypesByLocationBloc =
  EstateTypesByLocationBloc(EstateTypesRepository());

  // others:
  List<EstateType>? estatesTypes;

  SearchData searchData = SearchData(estateTypeId: 1);
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
  }

  String? userToken;
  late bool isArabic;
  late bool isDark;

  @override
  void initState() {
    super.initState();
    // Fetch lists :
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;

    // Initialize search data :
    initializeOfferData();

    for (int i = 0; i < estatesTypes!.length; i++) {
      print(estatesTypes!.elementAt(i).name);
    }

    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null) {
      userToken = UserSharedPreferences.getAccessToken();
    }
    locationNameCubit = ChannelCubit(widget.name ?? "");
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          iconTheme:
          IconThemeData(color: isDark ? Colors.white : AppColors.black),
          backgroundColor: isDark ? const Color(0xff26282B) : AppColors.white,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.search,
            style: TextStyle(color: isDark ? Colors.white : AppColors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ChannelCubit, dynamic>(
          bloc: isAreaSearchCubit,
          builder: (_, isArea) {
            return Column(
              children: [
                Container(
                  padding: kMediumSymHeight,
                  child: buildSearchWidgets(),
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
                      child: BlocBuilder<EstateTypesByLocationBloc,EstateTypesState>(
                        bloc: estateTypesByLocationBloc,
                        builder: (context, estateType) =>ElevatedButton(
                          style: (estateType is EstateTypesFetchComplete && estateTypesByLocationBloc.estateTypes!.isNotEmpty) ? ElevatedButton.styleFrom(
                              primary: isDark ? AppColors.primaryColor : null,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(20.w, 60.h),
                              maximumSize: Size(20.w, 60.h),
                              backgroundColor: isDark
                                  ? AppColors.lightblue
                                  : AppColors.primaryColor)
                              : ElevatedButton.styleFrom(
                              primary: isDark ? AppColors.primaryColor : null,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(20.w, 60.h),
                              maximumSize: Size(20.w, 60.h),
                              backgroundColor: isDark
                                  ? AppColors.lightGreyColor
                                  : AppColors.lightGreyColor),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ResText(
                                AppLocalizations.of(context)!.search,
                                textStyle:
                                const TextStyle(color: AppColors.white),
                              ),
                              kWi16,
                              const Icon(
                                Icons.search,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                          onPressed: () {
                            if(estateTypesByLocationBloc.estateTypes != null && estateTypesByLocationBloc.estateTypes!.isNotEmpty){
                              if (widget.id != null) {
                                searchData.locationId = widget.id;
                              }
                              if (searchData.locationId == 0) {
                                searchData.locationId = null;
                              }
                              if (searchData.priceMin == 0) {
                                searchData.priceMin = 1;
                              }
                              print("ghina : "
                                  "${searchData.estateOfferTypeId}\n"
                                  "${searchData.estateTypeId}\n"
                                  "${searchData.locationId}\n"
                                  "${searchData.priceMin}\n"
                                  "${searchData.priceMax}");

                              searchData.sortType = "desc";
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EstatesScreen(
                                    searchData: searchData,
                                    locationName: locationNameCubit.state,
                                    eventSearch: EstatesFetchStarted(
                                      searchData: searchData,
                                      isAdvanced: false,
                                      token: UserSharedPreferences.getAccessToken(),
                                    ),
                                  ),
                                ),
                              );
                            }
                            else
                              {
                                showWonderfulAlertDialog(
                                  context,
                                  AppLocalizations.of(context)!.error,
                                  ApplicationSharedPreferences.getLanguageCode() == "en"?"Please enter location":"من فضلك أدخل اسم الحي",
                                );
                              }
                          },
                        ),
                      ),
                    ),
                    kWi4,
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: isDark ? AppColors.primaryColor : null,
                            padding: EdgeInsets.zero,
                            minimumSize: Size(20.w, 60.h),
                            maximumSize: Size(20.w, 60.h),
                            backgroundColor: isDark
                                ? AppColors.lightblue
                                : AppColors.primaryColor),
                        child: Text(
                          AppLocalizations.of(context)!.clear,
                          style: const TextStyle(color: AppColors.white),
                        ),
                        onPressed: () {
                          locationNameCubit.setState(
                              AppLocalizations.of(context)!
                                  .enter_neighborhood_name);
                          isRentCubit.setState(false);
                          isAreaSearchCubit.setState(false);
                          //searchData = SearchData.init();
                          startPriceCubit.setState(0);
                          endPriceCubit.setState(4);
                          estateTypesByLocationBloc.add(EstateTypeReset());
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

  Widget buildSearchWidgets() {
    return Padding(
      padding: kMediumSymWidth,
      child: Column(
        children: [
          buildChoiceContainer(
              context: context,
              cubit: isRentCubit,
              textRight: AppLocalizations.of(context)!.sell,
              textLeft: AppLocalizations.of(context)!.rent,
              onTapRight: () {
                searchData.estateOfferTypeId = 1;
              },
              onTapLeft: () {
                searchData.estateOfferTypeId = 2;
              }),
          buildLocation(),
          EstateTypeWidget(
            isForSearch: true,
            searchData: searchData,
            isPressTypeCubit: isPressTypeCubit,
            removeSelect: true,
            estateTypesByLocationBloc: estateTypesByLocationBloc,
          ),
          PriceDomainWidget(
            isRentCubit: isRentCubit,
            searchData: searchData,
            startPriceCubit: startPriceCubit,
            endPriceCubit: endPriceCubit,
          ),
          kHe60,
        ],
      ),
    );
  }

  Column buildLocation() {
    return Column(
      children: [
        Padding(
          padding: kTinyAllPadding,
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              kWi8,
              ResText(
                AppLocalizations.of(context)!.location + " :",
                textStyle: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        buildChoiceContainer(
            context: context,
            cubit: isAreaSearchCubit,
            estateTypesByLocationBloc: estateTypesByLocationBloc,
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
              padding: kSmallAllPadding,
              child: Container(
                height: 55.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: !isDark
                          ? AppColors.lightGrey2Color
                          : AppColors.lightblue,
                      width: 1),
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
                        isPressTypeCubit.setState(0);
                        searchData.estateTypeId=1;
                        estateTypesByLocationBloc.add(
                            EstateTypeFetchByLocation(searchData.locationId!));
                      }
                      return;
                    } else {
                      selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchLocationScreen(),
                        ),
                      );
                      // unfocused text field :
                      FocusScope.of(context).unfocus();
                      if (selectedLocation != null) {
                        searchData.locationId = selectedLocation!.id;
                        locationNameCubit
                            .setState(selectedLocation!.getLocationName());
                        isPressTypeCubit.setState(0);
                        searchData.estateTypeId=1;
                        estateTypesByLocationBloc.add(
                            EstateTypeFetchByLocation(searchData.locationId!));
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
                            ResText(
                              locationName == ""
                                  ? AppLocalizations.of(context)!
                                  .enter_neighborhood_name
                                  : locationName,
                              textStyle: Theme.of(context).textTheme.headline6,
                            ),
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
