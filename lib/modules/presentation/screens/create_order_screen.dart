import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/models/price_domain.dart';
import 'package:swesshome/modules/presentation/screens/after_estate_order_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/assets_paths.dart';
import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_order_bloc/estate_order_event.dart';
import '../../data/models/search_data.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/choice_container.dart';
import '../widgets/price_domain.dart';
import 'search_location_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  static const String id = "CreateOrderScreen";

  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  // Blocs and Cubits :
  ChannelCubit locationErrorCubit = ChannelCubit(null);
  ChannelCubit noteErrorCubit = ChannelCubit(null);
  ChannelCubit startPriceCubit = ChannelCubit(0);
  ChannelCubit endPriceCubit = ChannelCubit(0);
  ChannelCubit isRentCubit = ChannelCubit(false);
  ChannelCubit isPressTypeCubit = ChannelCubit(0);

  // Controllers :
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  ScrollController scrollController = ScrollController();

  // Others :
  List<EstateType>? estatesTypes;
  PriceDomain? priceDomains;
  late SearchData estateOrder;

  LocationViewer? selectedLocation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;

    estateOrder = SearchData(estateOfferTypeId: 1, description: "");
    estateOrder.estateOfferTypeId = 1;
    estateOrder.estateTypeId = 1;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return BlocListener<EstateOrderBloc, EstateOrderState>(
      listener: (_, estateOrderState) async {
        if (estateOrderState is SendEstateOrderComplete) {
          Navigator.pushNamed(context, AfterEstateOrderScreen.id);
        } else if (estateOrderState is SendEstateOrderError) {
          var error = estateOrderState.isConnectionError
              ? AppLocalizations.of(context)!.no_internet_connection
              : estateOrderState.error;
          await showWonderfulAlertDialog(
              context, AppLocalizations.of(context)!.error, error);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.create_estate_order,
            ),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              padding: kMediumSymWidth,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kHe16,
                      // Text(
                      //   AppLocalizations.of(context)!.order_type + " :",
                      // ),
                      // kHe12,
                      buildChoiceContainer(
                          context: context,
                          cubit: isRentCubit,
                          textRight: AppLocalizations.of(context)!.buy,
                          textLeft: AppLocalizations.of(context)!.rent,
                          onTapRight: () {
                            estateOrder.estateOfferTypeId = 1;
                          },
                          onTapLeft: () {
                            estateOrder.estateOfferTypeId = 2;
                          },
                          paddingVertical: 5,
                          paddingHorizontal: 0),
                      kHe36,
                      buildLocation(isDark),
                      buildEstateType(isDark),
                      PriceDomainWidget(
                        isRentCubit: isRentCubit,
                        searchData: estateOrder,
                        startPriceCubit: startPriceCubit,
                        endPriceCubit: endPriceCubit,
                      ),
                      //buildPriceDomain(isArabic, isDark),
                      buildNote(isDark),
                      buildButton(),
                      kHe32,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocation(isDark) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined),
            kWi8,
            Text(
              AppLocalizations.of(context)!.estate_location + " :",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: locationErrorCubit,
          builder: (_, errorMessage) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(11)),
                  border: Border.all(
                    color: !isDark
                        ? AppColors.primaryColor
                        : AppColors.yellowDarkColor,
                    width: 1,
                  )),
              child: TextField(
                textDirection: TextDirection.rtl,
                onTap: () async {
                  selectedLocation = await Navigator.of(context)
                      .pushNamed(SearchLocationScreen.id) as LocationViewer?;
                  if (selectedLocation != null) {
                    officeAddressController.text =
                        selectedLocation!.getLocationName();
                    estateOrder.locationId = selectedLocation!.id;
                    locationErrorCubit.setState(null);
                  } else {
                    officeAddressController.clear();
                  }
                },
                controller: officeAddressController,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintText: AppLocalizations.of(context)!.estate_location_hint,
                  contentPadding: kSmallSymWidth,
                  errorBorder: kOutlinedBorderRed,
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
        kHe36,
      ],
    );
  }

  Widget buildEstateType(isDark) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.home_outlined),
            kWi8,
            Text(
              AppLocalizations.of(context)!.estate_type + " :",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: isPressTypeCubit,
          builder: (_, pressState) {
            return Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      isPressTypeCubit.setState(0);
                      estateOrder.estateTypeId = 1;
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
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
                      estateOrder.estateTypeId = 4;
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
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
                      isPressTypeCubit.setState(2);
                      estateOrder.estateTypeId = 3;
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: kTinyAllPadding,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                                color: pressState == 2
                                    ? AppColors.yellowDarkColor
                                    : AppColors.primaryColor),
                          ),
                          child: Image.asset(landIconPath,
                              color: AppColors.primaryColor),
                        ),
                        Text(
                          AppLocalizations.of(context)!.land,
                          style: TextStyle(
                              color: !isDark
                                  ? pressState == 2
                                      ? AppColors.yellowDarkColor
                                      : AppColors.primaryColor
                                  : pressState == 2
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
                      estateOrder.estateTypeId = 2;
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
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
                      estateOrder.estateTypeId = 5;
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.all(10),
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
            );
          },
        ),
        kHe36,
      ],
    );
  }

  Widget buildNote(isDark) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.speaker_notes_outlined),
            kWi8,
            Text(
              AppLocalizations.of(context)!.notes + " :",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: noteErrorCubit,
          builder: (_, errorMessage) {
            return Container(
              width: inf,
              padding: kSmallSymWidth,
              height: 250.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: !isDark ? Colors.black38 : AppColors.yellowDarkColor,
                ),
              ),
              child: TextField(
                maxLength: 600,
                controller: notesController,
                textDirection: TextDirection.rtl,
                onChanged: (value) {
                  estateOrder.description = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: AppLocalizations.of(context)!
                      .order_create_notes_descriptions,
                  errorText: errorMessage,
                ),
                maxLines: 8,
              ),
            );
          },
        ),
        kHe32,
      ],
    );
  }

  Widget buildButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(280, 64),
        ),
        child: BlocBuilder<EstateOrderBloc, EstateOrderState>(
          builder: (_, estateOrderState) {
            if (estateOrderState is SendEstateOrderProgress) {
              return SpinKitWave(
                color: Theme.of(context).colorScheme.background,
                size: 24.w,
              );
            }
            return Text(
              AppLocalizations.of(context)!.send_order,
            );
          },
        ),
        onPressed: () {
          if (validFields()) {
            print("ghina : ${estateOrder.locationId}\n"
                "${estateOrder.estateTypeId}\n"
                "${estateOrder.estateOfferTypeId}\n"
                "${estateOrder.priceMin}\n"
                "${estateOrder.priceMax}");

            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              BlocProvider.of<EstateOrderBloc>(context).add(
                SendEstateOrderStarted(
                    order: estateOrder,
                    token: UserSharedPreferences.getAccessToken()),
              );
            }
          }
        },
      ),
    );
  }

  bool validFields() {
    if (estateOrder.locationId == null) {
      locationErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      return false;
    }
    if (notesController.text == "") {
      noteErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      return false;
    }
    return true;
  }
}
