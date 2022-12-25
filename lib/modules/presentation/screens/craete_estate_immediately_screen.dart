import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/area_units_bloc/area_units_bloc.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import '../../business_logic_components/bloc/rating_bloc/rating_bloc.dart';
import '../../business_logic_components/bloc/rating_bloc/rating_state.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/area_unit.dart';
import '../../data/models/estate_immediately.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/period_type.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/rating_repository{.dart';
import '../widgets/my_dropdown_list.dart';
import '../widgets/wonderful_alert_dialog.dart';

class CreateEstateImmediatelyScreen extends StatefulWidget {
  const CreateEstateImmediatelyScreen({Key? key}) : super(key: key);

  @override
  State<CreateEstateImmediatelyScreen> createState() =>
      _CreateEstateImmediatelyScreenState();
}

class _CreateEstateImmediatelyScreenState
    extends State<CreateEstateImmediatelyScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController roomController = TextEditingController(text: "0");
  TextEditingController floorController = TextEditingController(text: "0");
  TextEditingController salonController = TextEditingController(text: "0");
  TextEditingController bathroomController = TextEditingController(text: "0");

  List<EstateType>? estatesTypes;
  late List<AreaUnit> areaTypes;
  late List<PeriodType> periodTypes;

  ChannelCubit isPressSearchCubit = ChannelCubit(false);
  ChannelCubit patternCubit = ChannelCubit(null);
  ChannelCubit areaErrorCubit = ChannelCubit(null);

  ChannelCubit roomCubit = ChannelCubit(0);
  ChannelCubit floorCubit = ChannelCubit(0);
  ChannelCubit salonCubit = ChannelCubit(0);
  ChannelCubit bathroomCubit = ChannelCubit(0);

  final RatingBloc _ratingBloc = RatingBloc(RatingRepository());

  EstateImmediately estateImmediately = EstateImmediately();

  @override
  void initState() {
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    areaTypes = BlocProvider.of<AreaUnitsBloc>(context).areaUnits!;
    periodTypes = BlocProvider.of<PeriodTypesBloc>(context).periodTypes!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

    List<Widget> areaWidget = [
      Expanded(
        flex: 2,
        child: BlocBuilder<ChannelCubit, dynamic>(
          bloc: areaErrorCubit,
          builder: (_, errorMessage) {
            return TextField(
              textDirection: TextDirection.ltr,
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.area_hint,
                errorText: errorMessage,
                isDense: true,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              cursorColor: Theme.of(context).colorScheme.onBackground,
              onChanged: (value) {
                areaErrorCubit.setState(null);
                if (!NumbersHelper.isNumeric(value)) {
                  areaErrorCubit
                      .setState(AppLocalizations.of(context)!.invalid_value);
                }
              },
            );
          },
        ),
      ),
      12.horizontalSpace,
      Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.5),
            child: MyDropdownList(
              //isOnChangeNull: isKeyboardOpened,
              elementsList: areaTypes.map((e) => e.name).toList(),
              onSelect: (index) {
                // widget.currentOffer.areaUnit = areaTypes.elementAt(index);
              },
              selectedItem: AppLocalizations.of(context)!.please_select_here,
              validator: (value) => value == null
                  ? AppLocalizations.of(context)!.this_field_is_required
                  : null,
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rent),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: isPressSearchCubit,
              builder: (_, isPress) {
                if (isPress) {
                  return Container(
                    padding: kMediumSymHeight,
                    child: buildRegionsDetector(),
                  );
                }
                return Container(
                  padding: kMediumSymHeight,
                  child: buildSearchWidgets(isDark, areaWidget),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchWidgets(isDark, List<Widget> areaWidget) {
    return Column(
      children: [
        buildLocation(isDark),
        buildEstateType(),
        buildSpaceEstate(areaWidget),
        buildPeriodTypes(),
        buildChooseNum(
            textController: floorController,
            textCubit: floorCubit,
            icon: Icons.house_siding,
            label: AppLocalizations.of(context)!.floor,
            hint: AppLocalizations.of(context)!.floor_number),
        buildChooseNum(
            textController: roomController,
            textCubit: roomCubit,
            icon: Icons.bed,
            label: AppLocalizations.of(context)!.room,
            hint: AppLocalizations.of(context)!.rooms_count),
        buildChooseNum(
            textController: salonController,
            textCubit: salonCubit,
            icon: Icons.chair_outlined,
            label: AppLocalizations.of(context)!.salon,
            hint: AppLocalizations.of(context)!.salon_count),
        buildChooseNum(
            textController: bathroomController,
            textCubit: bathroomCubit,
            icon: Icons.bathtub_outlined,
            label: AppLocalizations.of(context)!.bathroom,
            hint: AppLocalizations.of(context)!.bathroom_count),
        kHe24,
        ElevatedButton(
          style: ElevatedButton.styleFrom(fixedSize: Size(220.w, 64.h)),
          child: BlocConsumer<RatingBloc, RatingState>(
            bloc: _ratingBloc,
            listener: (_, ratingState) async {
              if (ratingState is RatingComplete) {
                // selectedRatingCubit.setState(-1);
                // notesController.clear();
                // unfocused text field :
                FocusScope.of(context).unfocus();
              }

              if (ratingState is RatingError) {
                var error = ratingState.isConnectionError
                    ? AppLocalizations.of(context)!.no_internet_connection
                    : ratingState.error;
                await showWonderfulAlertDialog(
                    context, AppLocalizations.of(context)!.error, error);
              }
              if (ratingState is RatingComplete) {
                Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.after_rate_message,
                    toastLength: Toast.LENGTH_LONG);
                Navigator.pop(context);
              }
            },
            builder: (_, ratingState) {
              if (ratingState is RatingProgress) {
                return SpinKitWave(
                  size: 24.w,
                  color: Theme.of(context).colorScheme.background,
                );
              }
              return Text(
                AppLocalizations.of(context)!.send,
              );
            },
          ),
          onPressed: () {
            // if (_ratingBloc.state is RatingProgress ||
            //     _ratingBloc.state is RatingComplete) {
            //   return;
            // }
            // if (selectedRatingCubit.state == -1) {
            //   Fluttertoast.showToast(
            //       msg: AppLocalizations.of(context)!
            //           .you_must_select_rate_first);
            //   return;
            // }
            //
            // _ratingBloc.add(
            //   RatingStarted(
            //       token: token,
            //       rate: selectedRatingCubit.state.toString(),
            //       notes: notesController.text),
            // );
          },
        ),
      ],
    );
  }

  Widget buildChooseNum(
      {required TextEditingController textController,
      required ChannelCubit textCubit,
      required IconData icon,
      required String label,
      required String hint}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon),
              kWi8,
              Text(
                label + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    if (textCubit.state > 0) {
                      textCubit.setState(textCubit.state - 1);
                      textController.text = textCubit.state.toString();
                    }
                  },
                  child: const SizedBox(
                    height: 40,
                    child: Icon(Icons.minimize_outlined),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: BlocBuilder<ChannelCubit, dynamic>(
                  bloc: textCubit,
                  builder: (_, state) {
                    return TextField(
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(height: 2),
                      onChanged: (String text) {
                        textController.text = text;
                        //textCubit.setState(int.tryParse(text) ?? 0);
                      },
                      controller: textController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        // errorText: AppLocalizations.of(context)!.this_field_is_required,
                        hintText: hint,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    textCubit.setState(textCubit.state + 1);
                    textController.text = textCubit.state.toString();
                  },
                  child: const SizedBox(
                    height: 40,
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
        24.verticalSpace,
      ],
    );
  }

  Widget buildPeriodTypes() {
    return Column(
      children: [
        //kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.repeat),
              kWi8,
              Text(
                AppLocalizations.of(context)!.estate_rent_period + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe12,
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

  Widget buildSpaceEstate(List<Widget> areaWidget) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.view_in_ar_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.estate_space + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondaryDark, width: 0.5),
              borderRadius: const BorderRadius.all(
                Radius.elliptical(8, 8),
              ),
            ),
            child: Row(children: areaWidget),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }

  Widget buildEstateType() {
    return Column(
      children: [
        kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: MyDropdownList(
              elementsList:
                  estatesTypes!.map((e) => e.name.split('|').first).toList(),
              onSelect: (index) {
                // set search data estate type :
                estateImmediately.estateTypeId =
                    estatesTypes!.elementAt(index).id;
              },
              validator: (value) => value == null
                  ? AppLocalizations.of(context)!.this_field_is_required
                  : null,
              selectedItem: AppLocalizations.of(context)!.please_select,
            ),
          ),
        ),
        24.verticalSpace,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Container(
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
            child: Center(
              child: TextFormField(
                  validator: (value) => value == null
                      ? AppLocalizations.of(context)!.this_field_is_required
                      : null,
                  // readOnly: locationDetectedCubit.state,
                  onTap: () {
                    isPressSearchCubit.setState(true);

                    locationController.clear();
                    //locationDetectedCubit.setState(true);
                    patternCubit.setState(null);
                    FocusScope.of(context).unfocus();

                    if (locationController.text.isEmpty) {
                      patternCubit.setState("");
                      return;
                    }
                  },
                  controller: locationController,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: AppColors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                    ),
                    border: kUnderlinedBorderWhite,
                    focusedBorder: kUnderlinedBorderWhite,
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor)),
                    hintText: AppLocalizations.of(context)!.enter_area_name,
                    hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.black38,
                        ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      //regionsBloc.add(SearchRegionCleared());
                      return;
                    } else {
                      patternCubit.setState(value);
                    }
                  }),
            ),
          ),
        )
      ],
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
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () async {
                      // set location name in location text field:
                      locationController.text =
                          locations.elementAt(index).getRegionName();
                      // print(locations.elementAt(index).locationName);
                      // set search data location id:
                      estateImmediately.locationId =
                          locations.elementAt(index).id;
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
                        locations.elementAt(index).getRegionName(),
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
