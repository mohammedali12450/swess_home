import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/search_office_results_bloc/search_offices_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/search_office_results_bloc/search_offices_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/search_office_results_bloc/search_offices_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/repositories/estate_offices_repository.dart';
import 'package:swesshome/modules/presentation/screens/estate_office_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_location_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_region_screen.dart';
import 'package:swesshome/modules/presentation/widgets/estate_office_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/offices_list_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';

class OfficeSearchScreen extends StatefulWidget {
  static const String id = 'OfficeSearchScreen';

  const OfficeSearchScreen({Key? key}) : super(key: key);

  @override
  _OfficeSearchScreenState createState() => _OfficeSearchScreenState();
}

class _OfficeSearchScreenState extends State<OfficeSearchScreen> {
  // Blocs and Cubits :
  ChannelCubit searchTypeCubit = ChannelCubit(OfficeSearchType.name);
  SearchOfficesBloc searchOfficesBloc = SearchOfficesBloc(
    EstateOfficesRepository(),
  );

  // Controllers :
  TextEditingController textFieldController = TextEditingController();

  // Others :

  late List<Location> locations;
  List<OfficeSearchType> searchTypes = [
    OfficeSearchType.name,
    OfficeSearchType.area,
    OfficeSearchType.neighborhood,
  ];
  LocationViewer? selectedLocation;
  RegionViewer? selectedRegion;
  String? token;

  @override
  void initState() {
    super.initState();
    locations = BlocProvider.of<LocationsBloc>(context).locations ?? [];

    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      token = BlocProvider.of<UserLoginBloc>(context).user!.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.search_for_estate_agent,
                style: const TextStyle(fontSize: 15),
              ),
              const Spacer(),
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: searchTypeCubit,
                builder: (_, searchType) {
                  bool isDark =
                      Provider.of<ThemeProvider>(context).isDarkMode(context);
                  return Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 8.w, right: 10.w),
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
            ],
          ),
          bottom: PreferredSize(
            child: Container(
              margin: EdgeInsets.only(
                bottom: 16.h,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: BlocBuilder<ChannelCubit, dynamic>(
                bloc: searchTypeCubit,
                builder: (_, searchType) {
                  return TextField(
                    readOnly: (searchType == OfficeSearchType.area),
                    controller: textFieldController,
                    onTap: () async {
                      if (searchType == OfficeSearchType.neighborhood) {
                        selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchLocationScreen(),
                          ),
                        ) as LocationViewer;
                        // unfocused text field :
                        FocusScope.of(context).unfocus();
                        if (selectedLocation != null) {
                          searchOfficesBloc.add(
                            SearchOfficesByLocationStarted(
                                locationId: selectedLocation!.id!),
                          );
                          textFieldController.text =
                              selectedLocation!.getLocationName();
                        }
                        return;
                      } else if (searchType == OfficeSearchType.area) {
                        selectedRegion = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchRegionScreen(),
                          ),
                        ) as RegionViewer;
                        // unfocused text field :
                        FocusScope.of(context).unfocus();
                        if (selectedRegion != null) {
                          searchOfficesBloc.add(
                            SearchOfficesByLocationStarted(
                                locationId: selectedRegion!.id!),
                          );
                          textFieldController.text =
                              selectedRegion!.getRegionName();
                        }
                        return;
                      } else if (searchType == OfficeSearchType.name) {
                        searchOfficesBloc.add(
                          SearchOfficesByNameStarted(name: null, token: token),
                        );
                      }
                    },
                    onChanged: (newValue) {
                      if (newValue.isEmpty) {
                        searchOfficesBloc.add(SearchOfficesCleared());
                        return;
                      }
                      if (searchType == OfficeSearchType.name) {
                        searchOfficesBloc.add(
                          SearchOfficesByNameStarted(
                              name: newValue, token: token),
                        );
                      }
                    },
                    cursorColor: AppColors.white,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.white,
                        ),
                    decoration: InputDecoration(
                      hintText: (searchType == OfficeSearchType.area)
                          ? AppLocalizations.of(context)!.enter_area_name
                          : (searchType == OfficeSearchType.neighborhood)
                              ? AppLocalizations.of(context)!
                                  .enter_neighborhood_name
                              : AppLocalizations.of(context)!.enter_office_name,
                      hintStyle:
                          Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: AppColors.white.withOpacity(0.64),
                              ),
                      border: kUnderlinedBorderWhite,
                      focusedBorder: kUnderlinedBorderWhite,
                      enabledBorder: kUnderlinedBorderWhite,
                    ),
                  );
                },
              ),
            ),
            preferredSize: Size.fromHeight(
              80.h,
            ),
          ),
        ),
        body: Container(
          padding: kMediumSymHeight,
          child: BlocBuilder<ChannelCubit, dynamic>(
            bloc: searchTypeCubit,
            builder: (_, searchType) {
              if (searchType == OfficeSearchType.area &&
                  searchType == OfficeSearchType.neighborhood &&
                  selectedLocation == null) {
                return Container();
              }

              return buildResultsList();
            },
          ),
        ),
      ),
    );
  }

  BlocConsumer buildResultsList() {
    return BlocConsumer<SearchOfficesBloc, SearchOfficesStates>(
      bloc: searchOfficesBloc,
      listener: (_, searchResultsState) {
        if (searchResultsState is SearchOfficesFetchError) {
          var error = searchResultsState.isConnectionError
              ? AppLocalizations.of(context)!.no_internet_connection
              : searchResultsState.errorMessage;
          showWonderfulAlertDialog(
            context,
            AppLocalizations.of(context)!.error,
            error,
            onDefaultButtonPressed: () {
              int count = 0;
              Navigator.popUntil(context, (route) => count++ == 2);
            },
          );
        }
      },
      builder: (_, searchResultsState) {
        if (searchResultsState is SearchOfficesFetchProgress) {
          return const OfficesListShimmer();
        }
        if (searchResultsState is SearchOfficesFetchNone) {
          return Container();
        }
        if (searchResultsState is! SearchOfficesFetchComplete) {
          return SizedBox(
            width: 1.sw,
            height: 1.sh - 75.h,
            child: FetchResult(
              content: AppLocalizations.of(context)!
                  .error_happened_when_executing_operation,
            ),
          );
        }

        List<EstateOffice> results = searchResultsState.results;

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  documentOutlineIconPath,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.32),
                  width: 0.5.sw,
                ),
                kHe32,
                Text(
                  AppLocalizations.of(context)!.no_results_body,
                )
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              if (searchTypeCubit.state == OfficeSearchType.area) ...[
                SizedBox(
                  width: inf,
                  child: Text(
                    AppLocalizations.of(context)!.offices_in_this_area + " :",
                  ),
                ),
                kHe24,
              ],
              ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return EstateOfficeCard(
                      office: results.elementAt(index),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => EstateOfficeScreen(
                                    results.elementAt(index).id,
                                  ),
                              transitionDuration: const Duration(seconds: 1)),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const Divider();
                  },
                  itemCount: results.length),
            ],
          ),
        );
      },
    );
  }

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
          hintText: AppLocalizations.of(context)!.search_by_name,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          )),
      isExpanded: true,
      items: searchTypes.map(
        (element) {
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
                    : (element.name == "neighborhood")
                        ? AppLocalizations.of(context)!.search_neighborhood
                        : AppLocalizations.of(context)!.search_by_name,
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
        searchOfficesBloc.add(SearchOfficesCleared());
      },
    );
  }
}
