import 'package:flutter/material.dart';
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
import '../../../constants/assets_paths.dart';
import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import '../../business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_bloc.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_event.dart';
import '../../business_logic_components/bloc/rent_estate_bloc/rent_estate_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/estate_type.dart';
import '../../data/models/interior_status.dart';
import '../../data/models/period_type.dart';
import '../../data/models/rent_estate.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/my_dropdown_list.dart';
import 'search_region_screen.dart';

class CreateEstateImmediatelyScreen extends StatefulWidget {
  const CreateEstateImmediatelyScreen({Key? key}) : super(key: key);

  @override
  State<CreateEstateImmediatelyScreen> createState() =>
      _CreateEstateImmediatelyScreenState();
}

class _CreateEstateImmediatelyScreenState
    extends State<CreateEstateImmediatelyScreen> {
  TextEditingController spaceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController roomController = TextEditingController(text: "0");
  TextEditingController floorController = TextEditingController(text: "0");
  TextEditingController salonController = TextEditingController(text: "0");
  TextEditingController bathroomController = TextEditingController(text: "0");
  TextEditingController authenticationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<EstateType>? estatesTypes;
  List<EstateType> estateTypes = [];
  late List<InteriorStatus> interiorStatuses;
  late List<PeriodType> periodTypes;
  String phoneDialCode = "+963";

  ChannelCubit spaceErrorCubit = ChannelCubit(null);
  ChannelCubit priceErrorCubit = ChannelCubit(null);
  ChannelCubit roomErrorCubit = ChannelCubit(null);
  ChannelCubit salonErrorCubit = ChannelCubit(null);
  ChannelCubit bathErrorCubit = ChannelCubit(null);
  ChannelCubit floorErrorCubit = ChannelCubit(null);
  ChannelCubit locationErrorCubit = ChannelCubit(null);
  ChannelCubit authenticationError = ChannelCubit(null);
  ChannelCubit roomCubit = ChannelCubit(0);
  ChannelCubit floorCubit = ChannelCubit(0);
  ChannelCubit salonCubit = ChannelCubit(0);
  ChannelCubit bathroomCubit = ChannelCubit(0);
  ChannelCubit checkFurnishedStateCubit = ChannelCubit(false);
  ChannelCubit isPressTypeCubit = ChannelCubit(0);
  ChannelCubit locationNameCubit = ChannelCubit("");

  late RentEstateBloc _rentEstateBloc;

  RentEstateRequest rentEstate = RentEstateRequest.init();
  RegionViewer? selectedRegion;

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
    interiorStatuses =
        BlocProvider.of<InteriorStatusesBloc>(context).interiorStatuses!;

    _rentEstateBloc = RentEstateBloc(RentEstateRepository());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

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
              onTap: () {
                FocusScope.of(context).unfocus();
              },
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
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.rent),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
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
          buildEstateType(isDark),
          buildSpaceEstate(areaWidget),
          buildPeriodTypes(),
          buildPriceNum(),
          buildInteriorStatuses(),
          buildFurnishedEstate(isArabic, isDark),
          buildChooseNum(
              textController: floorController,
              textCubit: floorCubit,
              icon: Icons.house_siding,
              label: AppLocalizations.of(context)!.floor,
              hint: AppLocalizations.of(context)!.floor_number,
              errorCubit: floorErrorCubit,
              onTap: () {
                rentEstate.floor = int.tryParse(floorController.text)!;
              }),
          buildChooseNum(
              textController: roomController,
              textCubit: roomCubit,
              icon: Icons.bed,
              label: AppLocalizations.of(context)!.room,
              hint: AppLocalizations.of(context)!.rooms_count,
              errorCubit: roomErrorCubit,
              onTap: () {
                rentEstate.room = int.tryParse(roomController.text)!;
              }),
          buildChooseNum(
              textController: salonController,
              textCubit: salonCubit,
              icon: Icons.chair_outlined,
              label: AppLocalizations.of(context)!.salon,
              hint: AppLocalizations.of(context)!.salon_count,
              errorCubit: salonErrorCubit,
              onTap: () {
                rentEstate.salon = int.tryParse(salonController.text)!;
              }),
          buildChooseNum(
              textController: bathroomController,
              textCubit: bathroomCubit,
              icon: Icons.bathtub_outlined,
              label: AppLocalizations.of(context)!.bathroom,
              hint: AppLocalizations.of(context)!.bathroom_count,
              errorCubit: bathErrorCubit,
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
                if (selectedRegion!.id == 0) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.location_message,
                      textColor: AppColors.primaryColor,
                      toastLength: Toast.LENGTH_LONG);
                  return;
                }
                _rentEstateBloc.add(SendRentEstatesFetchStarted(
                    rentEstate: rentEstate,
                    token: UserSharedPreferences.getAccessToken()!));
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
      required ChannelCubit errorCubit,
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
                    } else if (label == AppLocalizations.of(context)!.floor &&
                        textCubit.state > -2) {
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
                    return BlocBuilder<ChannelCubit, dynamic>(
                      bloc: errorCubit,
                      builder: (_, errorMessage) {
                        return TextField(
                          readOnly: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(height: 2),
                          onChanged: (String text) {
                            textController.text = text;
                            textCubit.setState(int.tryParse(text) ?? 0);
                          },
                          controller: textController,
                          // keyboardType: TextInputType.number,
                          // inputFormatters: <TextInputFormatter>[
                          //   FilteringTextInputFormatter.digitsOnly,
                          // ],
                          decoration: InputDecoration(
                            // errorText: AppLocalizations.of(context)!.this_field_is_required,
                            hintText: hint,
                            errorText: errorMessage,
                          ),
                        );
                      },
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
                elementsList:
                    periodTypes.map((e) => e.name.split("|").first).toList(),
                onSelect: (index) {
                  // set search data estate type :
                  rentEstate.periodTypeId = estateTypes.elementAt(index).id;
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

  Widget buildInteriorStatuses() {
    return Column(
      children: [
        //kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.chair_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.interior_status + " :",
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
                elementsList: interiorStatuses.map((e) => e.name).toList(),
                onSelect: (index) {
                  rentEstate.interiorStatusesId =
                      interiorStatuses.elementAt(index).id;
                },
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.this_field_is_required
                    : null,
                selectedItem: AppLocalizations.of(context)!.please_select,
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

  Widget buildEstateType(isDark) {
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
          bloc: isPressTypeCubit,
          builder: (_, pressState) {
            return Padding(
              padding: kSmallAllPadding,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        isPressTypeCubit.setState(0);
                        rentEstate.estateTypeId = 1;
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            padding: kSmallAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 0
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(buildIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            AppLocalizations.of(context)!.house,
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 0
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 0
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kWi16,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        isPressTypeCubit.setState(3);
                        rentEstate.estateTypeId = 4;
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            padding: kSmallAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 3
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(farmIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            AppLocalizations.of(context)!.farm,
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 3
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 3
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kWi16,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        isPressTypeCubit.setState(1);
                        rentEstate.estateTypeId = 2;
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            padding: kTinyAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 1
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(shopIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            AppLocalizations.of(context)!.shop,
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 1
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 1
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kWi16,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        isPressTypeCubit.setState(4);
                        rentEstate.estateTypeId = 5;
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            padding: kSmallAllPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                  color: pressState == 4
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor),
                            ),
                            child: Image.asset(villaIconPath,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            AppLocalizations.of(context)!.villa,
                            style: TextStyle(
                                color: !isDark
                                    ? pressState == 4
                                        ? AppColors.yellowDarkColor
                                        : AppColors.primaryColor
                                    : pressState == 4
                                        ? AppColors.yellowDarkColor
                                        : AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                              checkFurnishedStateCubit.state ? 1 : 0;
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

  Widget buildLocation(isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              kWi8,
              Text(
                AppLocalizations.of(context)!.estate_location + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        kHe12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BlocBuilder<ChannelCubit, dynamic>(
            bloc: locationErrorCubit,
            builder: (_, errorMessage) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(11)),
                    border: Border.all(
                      color: !isDark
                          ? AppColors.primaryColor
                          : AppColors.yellowDarkColor,
                      width: 0.3,
                    )),
                child: TextField(
                  textDirection: TextDirection.rtl,
                  onTap: () async {
                    selectedRegion = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchRegionScreen(),
                      ),
                    ) as RegionViewer;
                    FocusScope.of(context).unfocus();
                    if (selectedRegion != null) {
                      rentEstate.locationId = selectedRegion!.id!;
                      locationNameCubit
                          .setState(selectedRegion!.getLocationName());
                      locationController.text = locationNameCubit.state;
                      locationErrorCubit.setState(null);
                    }
                    return;
                  },
                  controller: locationController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText:
                        AppLocalizations.of(context)!.estate_location_hint,
                    contentPadding: kSmallSymWidth,
                    // errorBorder: kOutlinedBorderRed,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        kHe36,
      ],
    );
  }

  Future<bool> getFieldsValidation() async {
    bool isValidationSuccess = true;

    // location verification
    if (selectedRegion == null) {
      locationErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      scrollController.animateTo(0,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    }
    locationErrorCubit.setState(null);

    // space verification
    if (spaceController.text.isEmpty) {
      spaceErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      scrollController.animateTo(0,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    }
    spaceErrorCubit.setState(null);

    // estate InteriorStatuses & PeriodTypes verification
    if (!_formKey.currentState!.validate()) {
      scrollController.animateTo(500,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    }

    // price verification
    if (priceController.text.isEmpty) {
      priceErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      scrollController.animateTo(300,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    }
    priceErrorCubit.setState(null);

    //room verification
    if (roomCubit.state == 0 || roomController.text.isEmpty) {
      roomErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      scrollController.animateTo(700,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    }
    roomErrorCubit.setState(null);

    //salon verification
    if (salonCubit.state == 0 || salonController.text.isEmpty) {
      salonErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      return false;
    }
    salonErrorCubit.setState(null);

    //bath verification
    if (bathroomCubit.state == 0 || roomController.text.isEmpty) {
      bathErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      return false;
    }
    bathErrorCubit.setState(null);

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

    _formKey.currentState!.save();

    return isValidationSuccess;
  }
}
