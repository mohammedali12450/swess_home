import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/data/repositories/rent_estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/region_screen.dart';
import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/area_units_bloc/area_units_bloc.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_state.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_event.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/area_unit.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/period_type.dart';
import '../../data/models/rent_estate.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/my_dropdown_list.dart';

class CreateEstateImmediatelyScreen extends StatefulWidget {
  const CreateEstateImmediatelyScreen({Key? key}) : super(key: key);

  @override
  State<CreateEstateImmediatelyScreen> createState() =>
      _CreateEstateImmediatelyScreenState();
}

class _CreateEstateImmediatelyScreenState
    extends State<CreateEstateImmediatelyScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController spaceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController roomController = TextEditingController(text: "0");
  TextEditingController floorController = TextEditingController(text: "0");
  TextEditingController salonController = TextEditingController(text: "0");
  TextEditingController bathroomController = TextEditingController(text: "0");
  TextEditingController authenticationController = TextEditingController();

  List<EstateType>? estatesTypes;
  List<EstateType> estateTypes = [];
  late List<PeriodType> periodTypes;
  String phoneDialCode = "+963";

  ChannelCubit isPressSearchCubit = ChannelCubit(false);
  ChannelCubit patternCubit = ChannelCubit(null);
  ChannelCubit spaceErrorCubit = ChannelCubit(null);
  ChannelCubit priceErrorCubit = ChannelCubit(null);
  ChannelCubit estateTypeErrorCubit = ChannelCubit(null);
  ChannelCubit authenticationError = ChannelCubit(null);
  ChannelCubit roomCubit = ChannelCubit(0);
  ChannelCubit floorCubit = ChannelCubit(0);
  ChannelCubit salonCubit = ChannelCubit(0);
  ChannelCubit bathroomCubit = ChannelCubit(0);
  ChannelCubit checkFurnishedStateCubit = ChannelCubit(false);

  late RentEstateBloc _rentEstateBloc;

  RentEstateRequest rentEstate = RentEstateRequest.init();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;

    for (int i = 0; i < estatesTypes!.length; i++) {
      if (estatesTypes!.elementAt(i).id == 3) {
        continue;
      }
      estateTypes.add(estatesTypes!.elementAt(i));
    }
    periodTypes = BlocProvider.of<PeriodTypesBloc>(context).periodTypes!;
    _rentEstateBloc = RentEstateBloc(RentEstateRepository());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    locationController.text = AppLocalizations.of(context)!.enter_location_name;

    List<Widget> areaWidget = [
      Expanded(
        flex: 3,
        child: BlocBuilder<ChannelCubit, dynamic>(
          bloc: spaceErrorCubit,
          builder: (_, errorMessage) {
            return TextField(
              textDirection: TextDirection.ltr,
              controller: spaceController,
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
                spaceErrorCubit.setState(null);
                if (!NumbersHelper.isNumeric(value)) {
                  spaceErrorCubit
                      .setState(AppLocalizations.of(context)!.invalid_value);
                }
                rentEstate.space = int.tryParse(spaceController.text)!;
              },
            );
          },
        ),
      ),
      12.horizontalSpace,
      Expanded(
          flex: 1,
          child: Text(
            AppLocalizations.of(context)!.meter,
            textAlign: TextAlign.center,
          )),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rent),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: kMediumSymHeight,
              child: buildSearchWidgets(isArabic, isDark, areaWidget),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchWidgets(isArabic, isDark, List<Widget> areaWidget) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          buildLocation(isDark),
          buildEstateType(),
          buildSpaceEstate(areaWidget),
          buildPeriodTypes(),
          buildPriceNum(),
          buildFurnishedEstate(isArabic, isDark),
          buildChooseNum(
              textController: floorController,
              textCubit: floorCubit,
              icon: Icons.house_siding,
              label: AppLocalizations.of(context)!.floor,
              hint: AppLocalizations.of(context)!.floor_number,
              onTap: () {
                rentEstate.floor = int.tryParse(floorController.text)!;
              }),
          buildChooseNum(
              textController: roomController,
              textCubit: roomCubit,
              icon: Icons.bed,
              label: AppLocalizations.of(context)!.room,
              hint: AppLocalizations.of(context)!.rooms_count,
              onTap: () {
                rentEstate.room = int.tryParse(roomController.text)!;
              }),
          buildChooseNum(
              textController: salonController,
              textCubit: salonCubit,
              icon: Icons.chair_outlined,
              label: AppLocalizations.of(context)!.salon,
              hint: AppLocalizations.of(context)!.salon_count,
              onTap: () {
                rentEstate.salon = int.tryParse(salonController.text)!;
              }),
          buildChooseNum(
              textController: bathroomController,
              textCubit: bathroomCubit,
              icon: Icons.bathtub_outlined,
              label: AppLocalizations.of(context)!.bathroom,
              hint: AppLocalizations.of(context)!.bathroom_count,
              onTap: () {
                rentEstate.bathroom = int.tryParse(bathroomController.text)!;
              }),
          kHe24,
          buildPhoneNumber(),
          kHe36,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(220.w, 64.h)),
              child: BlocConsumer<RentEstateBloc, RentEstateState>(
                bloc: _rentEstateBloc,
                listener: (_, rentState) async {
                  if (rentState is SendRentEstateFetchComplete) {
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.after_rate_message,
                        toastLength: Toast.LENGTH_LONG);
                    Navigator.pop(context);
                  }
                },
                builder: (_, rentState) {
                  if (rentState is SendRentEstateFetchProgress) {
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
              onPressed: () async {
                if (!await getFieldsValidation()) {
                  return;
                }
                _rentEstateBloc
                    .add(SendRentEstatesFetchStarted(rentEstate: rentEstate));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChooseNum(
      {required TextEditingController textController,
      required ChannelCubit textCubit,
      required IconData icon,
      required String label,
      required String hint,
      required Function() onTap}) {
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
                    onTap();
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
            height: 53,
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

  Widget buildPriceNum() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.price_change_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.estate_price + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondaryDark, width: 0.5),
              borderRadius: const BorderRadius.all(
                Radius.elliptical(8, 8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: BlocBuilder<ChannelCubit, dynamic>(
                    bloc: priceErrorCubit,
                    builder: (_, errorMessage) {
                      return TextField(
                        textDirection: TextDirection.ltr,
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .estate_rent_price_hint_syrian,
                          errorText: errorMessage,
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                        cursorColor: Theme.of(context).colorScheme.onBackground,
                        onChanged: (value) {
                          priceErrorCubit.setState(null);
                          if (!NumbersHelper.isNumeric(value)) {
                            priceErrorCubit.setState(
                                AppLocalizations.of(context)!.invalid_value);
                          }
                          rentEstate.price =
                              int.tryParse(priceController.text)!;
                        },
                      );
                    },
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                    flex: 1,
                    child: Text(
                      AppLocalizations.of(context)!.syrian_bound,
                      textAlign: TextAlign.center,
                    )),
              ],
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
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: estateTypeErrorCubit,
          builder: (_, messageText) {
            return Padding(
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
                    rentEstate.estateTypeId = estateTypes.elementAt(index).id;
                    estateTypeErrorCubit.setState(null);
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
        24.verticalSpace,
      ],
    );
  }

  Widget buildPhoneNumber() {
    return Column(
      children: [
        kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              const Icon(Icons.whatsapp_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.whatsapp_number + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: authenticationError,
          builder: (_, errorMessage) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 53,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.secondaryDark, width: 0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.elliptical(8, 8),
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: IntlPhoneField(
                    controller: authenticationController,
                    showDropdownIcon: false,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        height: 1.6, fontWeight: FontWeight.w400, fontSize: 16),
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      errorMaxLines: 2,
                    ),
                    initialCountryCode: 'SY',
                    onChanged: (phone) {
                      phoneDialCode = phone.countryCode;
                      authenticationError.setState(null);
                      // rentEstate.whatsAppNumber =
                      //     phoneDialCode + authenticationController.text;
                    },
                    disableLengthCheck: true,
                    autovalidateMode: AutovalidateMode.disabled,
                  ),
                ),
              ),
            );
          },
        ),
        kHe32,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              const Icon(Icons.phone_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.phone_communicate + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            alignment: Alignment.center,
            width: getScreenWidth(context),
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondaryDark, width: 0.5),
              borderRadius: const BorderRadius.all(
                Radius.elliptical(8, 8),
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  Text(
                    UserSharedPreferences.getPhoneNumber()!,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          height: 1,
                        ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildFurnishedEstate(isArabic, isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
      child: Column(
        children: [
          BlocBuilder<ChannelCubit, dynamic>(
              bloc: checkFurnishedStateCubit,
              builder: (_, isYes) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: (isArabic) ? 8.w : 0,
                          right: (isArabic) ? 0 : 8.w,
                        ),
                        child: Text(AppLocalizations.of(context)!
                            .is_the_estate_furnished),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 14.h),
                          decoration: BoxDecoration(
                            color: !isDark
                                ? isYes
                                    ? AppColors.primaryColor
                                    : Colors.white
                                : isYes
                                    ? Colors.white
                                    : AppColors.secondaryDark,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.yes,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !isDark
                                  ? !isYes
                                      ? AppColors.primaryColor
                                      : Colors.white
                                  : isYes
                                      ? AppColors.secondaryDark
                                      : Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          checkFurnishedStateCubit.setState(true);
                          rentEstate.isFurnished =
                              checkFurnishedStateCubit.state;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 14.h),
                          decoration: BoxDecoration(
                            color: !isDark
                                ? !isYes
                                    ? AppColors.primaryColor
                                    : Colors.white
                                : !isYes
                                    ? Colors.white
                                    : AppColors.secondaryDark,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.no,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !isDark
                                  ? isYes
                                      ? AppColors.primaryColor
                                      : Colors.white
                                  : !isYes
                                      ? AppColors.secondaryDark
                                      : Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          checkFurnishedStateCubit.setState(false);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                );
              }),
        ],
      ),
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
                              locationId: rentEstate.locationId,
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
        ),
      ],
    );
  }

  // BlocBuilder buildRegionsDetector() {
  //   return BlocBuilder<RegionsBloc, RegionsState>(
  //     builder: (_, regionsFetchState) {
  //       if (regionsFetchState is RegionsFetchComplete) {
  //         return BlocBuilder<ChannelCubit, dynamic>(
  //           bloc: patternCubit,
  //           builder: (_, pattern) {
  //             List<RegionViewer> locations =
  //                 BlocProvider.of<RegionsBloc>(context)
  //                     .getRegionsViewers(pattern, context);
  //             return ListView.separated(
  //               shrinkWrap: true,
  //               itemBuilder: (_, index) {
  //                 return InkWell(
  //                   onTap: () async {
  //                     // set location name in location text field:
  //                     locationController.text =
  //                         locations.elementAt(index).getRegionName();
  //                     // print(locations.elementAt(index).locationName);
  //                     // set search data location id:
  //                     rentEstate.locationId = locations.elementAt(index).id!;
  //                     // unfocused text field :
  //                     FocusScope.of(context).unfocus();
  //                     // save location as recent search:
  //                     //TODO : add recent search to data base
  //                     // await saveAsRecentSearch(
  //                     //     locations.elementAt(index).id!);
  //
  //                     isPressSearchCubit.setState(false);
  //                   },
  //                   child: Container(
  //                     margin: EdgeInsets.symmetric(
  //                       vertical: 8.h,
  //                     ),
  //                     padding: kMediumSymWidth,
  //                     width: inf,
  //                     child: Text(
  //                       locations.elementAt(index).getRegionName(),
  //                       textAlign: TextAlign.right,
  //                       style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //                           color: Theme.of(context).colorScheme.onBackground),
  //                     ),
  //                   ),
  //                 );
  //               },
  //               separatorBuilder: (_, index) {
  //                 return const Divider();
  //               },
  //               itemCount: locations.length,
  //             );
  //           },
  //         );
  //       }
  //       return Container();
  //     },
  //   );
  // }

  ScrollController scrollController = ScrollController();

  Future<bool> getFieldsValidation() async {
    bool isValidationSuccess = true;

    if (!_formKey.currentState!.validate()) {
      // phone number validate :
      if (authenticationController.text.isNotEmpty) {
        try {
          final parsedPhoneNumber = await PhoneNumberUtil()
              .parse(phoneDialCode + authenticationController.text);
          rentEstate.whatsAppNumber =
              parsedPhoneNumber.international.replaceAll(" ", "");
        } catch (e) {
          authenticationError
              .setState(AppLocalizations.of(context)!.invalid_mobile_number);
          return false;
        }
      }

      // space verification
      if (spaceController.text.isEmpty) {
        spaceErrorCubit
            .setState(AppLocalizations.of(context)!.this_field_is_required);
        return false;
      }
      spaceErrorCubit.setState(null);

      // price verification
      if (priceController.text.isEmpty) {
        priceErrorCubit
            .setState(AppLocalizations.of(context)!.this_field_is_required);
        return false;
      }
      priceErrorCubit.setState(null);

      return false;
    }
    _formKey.currentState!.save();

    return isValidationSuccess;
  }
}
