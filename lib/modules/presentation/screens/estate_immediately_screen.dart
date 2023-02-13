import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/design_constants.dart';
import '../../../core/functions/app_theme_information.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_event.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/period_type.dart';
import '../../data/models/rent_estate.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/rent_estate_repository.dart';
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

  late List<EstateType> estatesTypes;

  List<EstateType> estateTypes = [];
  late List<PeriodType> periodTypes;
  bool isEstatesFinished = false;
  final ChannelCubit _priceSelected = ChannelCubit(false);
  RentEstateFilter rentEstateFilter = RentEstateFilter.init();
  RegionViewer? selectedRegion;

  @override
  void initState() {
    _rentEstateBloc = RentEstateBloc(RentEstateRepository());
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;

    for (int i = 0; i < estatesTypes.length; i++) {
      if (estatesTypes.elementAt(i).id == 3) {
        continue;
      }
      estateTypes.add(estatesTypes.elementAt(i));
    }
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
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Scaffold(
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
                                  estateTypeId: null,
                                  price: "desc"),
                            )
                          : FilterRentEstatesFetchStarted(
                              rentEstateFilter: rentEstateFilter),
                    );
                  print("ghina : ${rentEstateFilter.price}\n"
                      "${rentEstateFilter.locationId}\n"
                      "${rentEstateFilter.estateTypeId}\n");
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
                toolbarHeight: 60,
                title: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.yellowDarkColor,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(80),
                              ),
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(8),
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
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
                      child: buildLocation(isDark),
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
                            size: 120,
                          ),
                          kHe24,
                          Text(
                            AppLocalizations.of(context)!.no_results_hint,
                            style: Theme.of(context)
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
                  itemExtent: 350,
                  delegate: SliverChildBuilderDelegate((builder, index) {
                    return buildEstateCard(
                        rentEstates.elementAt(index), isDark);
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
                          // border color
                          color: AppColors.yellowColor,
                          // border thickness
                          width: 2,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 5, 15),
                        width: 100,
                        alignment: Alignment.bottomCenter,
                        height: 72.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: AppColors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                AppLocalizations.of(context)!.create,
                                style: const TextStyle(
                                    color: AppColors.white, fontSize: 16),
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

  Widget buildLocation(isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.yellowDarkColor, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                    "${rentEstateFilter.locationId}\n"
                    "${rentEstateFilter.estateTypeId}\n");
                isPressSearchCubit.setState(false);
              }
              return BlocBuilder<ChannelCubit, dynamic>(
                  bloc: locationNameCubit,
                  builder: (_, locationName) {
                    return Center(
                      child: Row(
                        children: [
                          Text(
                            locationName == ""
                                ? AppLocalizations.of(context)!
                                    .enter_location_name
                                : locationName,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: AppColors.black, fontSize: 16),
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

  Widget buildEstateCard(RentEstate rentEstate, isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    rentEstate.publishedAt,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: isDark
                            ? AppColors.yellowDarkColor
                            : AppColors.lastColor,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.address + " : "),
                  Text(rentEstate.location),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.estate_type + " : "),
                        Text(rentEstate.estateType.split("|")[1])
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.rental_term + " : "),
                        Text(rentEstate.periodType.split("|").first),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                            AppLocalizations.of(context)!.estate_space + " : "),
                        Text(rentEstate.space.toString() +
                            " " +
                            AppLocalizations.of(context)!.meter),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.floor + " : "),
                        Text(rentEstate.floor.toString()),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.room + " : "),
                        Text(rentEstate.room.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.salon + " : "),
                        Text(rentEstate.salon.toString()),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.bathroom + " : "),
                        Text(rentEstate.bathroom.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.furnished + " : "),
                        Text(rentEstate.isFurnished
                            ? AppLocalizations.of(context)!.yes
                            : AppLocalizations.of(context)!.no),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.interior_status + " : "),
                  Text(rentEstate.interiorStatuses),
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.estate_price + " : "),
                  Text(NumbersHelper.getMoneyFormat(rentEstate.price) +
                      " " +
                      AppLocalizations.of(context)!.syrian_bound),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (rentEstate.whatsAppNumber != null) {
                        openWhatsApp(rentEstate.whatsAppNumber);
                      } else {
                        openWhatsApp(rentEstate.phoneNumber);
                      }
                    },
                    icon: const Icon(
                      Icons.whatsapp_outlined,
                      size: 30,
                      color: Colors.green,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    width: 2,
                    color: AppColors.black,
                  ),
                  IconButton(
                    onPressed: () async {
                      launch(
                        "tel://" + rentEstate.phoneNumber,
                      );
                    },
                    icon: const Icon(
                      Icons.call_outlined,
                      size: 30,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
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
          padding: const EdgeInsets.only(bottom: 18.0),
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
                  "${rentEstateFilter.estateTypeId}\n"
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

  openWhatsApp(whatsapp) async {
    var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp + "&text=";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.whats_app_not_installed)));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.whats_app_not_installed)));
      }
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: isPriceSelected
                      ? AppColors.primaryColor
                      : AppColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: AppColors.primaryColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.by_price,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: isPriceSelected
                              ? AppColors.white
                              : AppColors.primaryColor),
                    ),
                    !isPriceSelected
                        ? const Icon(
                            Icons.arrow_downward,
                            color: AppColors.primaryColor,
                            size: 16,
                          )
                        : const Icon(
                            Icons.arrow_upward,
                            color: AppColors.white,
                            size: 16,
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
          child: Text(
            AppLocalizations.of(context)!.estate_rent_period + " :",
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

  Widget buildEstateType() {
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
  }

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
