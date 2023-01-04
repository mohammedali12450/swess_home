import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/screens/region_screen.dart';
import '../../../constants/design_constants.dart';
import '../../business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_state.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_event.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/period_type.dart';
import '../../data/models/rent_estate.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/rent_estate_repository.dart';
import '../widgets/my_dropdown_list.dart';
import 'create_estate_immediately_screen.dart';

class EstateImmediatelyScreen extends StatefulWidget {
  const EstateImmediatelyScreen({Key? key}) : super(key: key);

  @override
  State<EstateImmediatelyScreen> createState() =>
      _EstateImmediatelyScreenState();
}

class _EstateImmediatelyScreenState extends State<EstateImmediatelyScreen> {
  late RentEstateBloc _rentEstateBloc;
  List<RentEstate> rentEstates = [];
  int locationId = 0;

  TextEditingController locationController = TextEditingController();

  ChannelCubit isPressSearchCubit = ChannelCubit(false);
  late List<EstateType> estatesTypes;
  List<EstateType> estateTypes = [];
  late List<PeriodType> periodTypes;
  int? estateTypeId;
  final ChannelCubit _priceSelected = ChannelCubit(false);

  @override
  void initState() {
    _rentEstateBloc = RentEstateBloc(RentEstateRepository());
    _rentEstateBloc.add(GetRentEstatesFetchStarted());
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;

    for (int i = 0; i < estatesTypes.length; i++) {
      if (estatesTypes.elementAt(i).id == 3) {
        continue;
      }
      estateTypes.add(estatesTypes.elementAt(i));
    }
    periodTypes = BlocProvider.of<PeriodTypesBloc>(context).periodTypes!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    locationController.text = AppLocalizations.of(context)!.search_by +
        AppLocalizations.of(context)!.location;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text(AppLocalizations.of(context)!.estate_immediately),
            bottom: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
              title: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        padding: EdgeInsets.only(
                            right: !isArabic ? 12 : 0, left: isArabic ? 12 : 0),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    elevation: 2,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16.h, horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                      )),
                  Expanded(
                    flex: 8,
                    child: buildLocation(isDark),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<RentEstateBloc, RentEstateState>(
            bloc: _rentEstateBloc,
            builder: (_, getRentState) {
              if (getRentState is GetRentEstateFetchProgress) {}
              if (getRentState is GetRentEstateFetchComplete) {
                rentEstates = getRentState.rentEstates;
              }
              return SliverFixedExtentList(
                itemExtent: 250,
                delegate: SliverChildBuilderDelegate((builder, index) {
                  return buildEstateCard(rentEstates.elementAt(index));
                }, childCount: rentEstates.length),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
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
      ),
    );
  }

  Widget buildLocation(isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 5),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                          locationId: locationId,
                        )));
            isPressSearchCubit.setState(false);
          },
          child: BlocBuilder<ChannelCubit, dynamic>(
            bloc: isPressSearchCubit,
            builder: (_, isPress) {
              return Center(
                child: Row(
                  children: [
                    Text(
                      locationController.text,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildEstateCard(RentEstate rentEstate) {
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
                        color: AppColors.lastColor,
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
                        Text(rentEstate.estateType),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.rental_term + " : "),
                        Text(rentEstate.periodType),
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
                        Text(rentEstate.space.toString()),
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
                        Text(rentEstate.isFurnished.toString()),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.estate_price + " : "),
                  Text(rentEstate.price.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ChannelCubit patternCubit = ChannelCubit(null);

  Widget buildDialogBody() {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      spacing: 12.h,
      runSpacing: 12.w,
      children: [
        Container(
          width: inf,
          padding: kSmallSymWidth,
          height: 400.h,
          child: Column(
            children: [
              buildPriceFilter(),
              kHe24,
              buildEstateType(),
              kHe24,
              buildPeriodTypes()
            ],
          ),
        ),
        ElevatedButton(
          child: Text(
            AppLocalizations.of(context)!.ok,
          ),
          onPressed: () async {},
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

              // BlocProvider.of<EstateBloc>(context).add(
              //   EstateFetchStarted(
              //     searchData: SearchData(
              //         locationId: widget.searchData.locationId,
              //         estateTypeId: widget.searchData.estateTypeId,
              //         estateOfferTypeId:
              //         widget.searchData.estateOfferTypeId,
              //         priceMin: widget.searchData.priceMin,
              //         priceMax: widget.searchData.priceMax,
              //         sortType: isPriceSelected ? "desc" : "asc",
              //         sortBy: "price"),
              //     isAdvanced: false,
              //     token: UserSharedPreferences.getAccessToken(),
              //   ),
              // );
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
      children: [
        //kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.estate_rent_period + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondaryDark, width: 0.5),
              borderRadius: const BorderRadius.all(
                Radius.elliptical(8, 8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: MyDropdownList(
                // isOnChangeNull: isKeyboardOpened,
                elementsList:
                    periodTypes.map((e) => e.name.split("|").first).toList(),
                onSelect: (index) {
                  // widget.currentOffer.periodType =
                  //     periodTypes.elementAt(index);
                  // selectedPeriodCubit!.setState(
                  //   periodTypes
                  //       .elementAt(index)
                  //       .name
                  //       .split("|")
                  //       .elementAt(1),
                  // );
                },
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.this_field_is_required
                    : null,
                selectedItem: AppLocalizations.of(context)!.please_select_here,
              ),
            ),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }

  Widget buildEstateType() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                AppLocalizations.of(context)!.estate_type + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: MyDropdownList(
              elementsList: estateTypes.map((e) {
                return e.name.split('|').first;
              }).toList(),
              onSelect: (index) {
                // set search data estate type :
                estateTypeId = estateTypes.elementAt(index).id;
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
}
