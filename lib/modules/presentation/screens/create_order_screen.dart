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
import 'package:swesshome/modules/business_logic_components/cubits/notifications_cubit.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/models/price_domain.dart';
import 'package:swesshome/modules/presentation/screens/after_estate_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/notifications_screen.dart';
import 'package:swesshome/modules/presentation/widgets/icone_badge.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../../core/functions/screen_informations.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_order_bloc/estate_order_event.dart';
import '../../data/models/search_data.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/choice_container.dart';
import '../widgets/estate_type.dart';
import '../widgets/price_domain.dart';
import '../widgets/res_text.dart';
import '../widgets/will-pop-scope.dart';
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
  ChannelCubit reversedscroll = ChannelCubit(false);
  ChannelCubit isTextFormFieldPressed = ChannelCubit(false);
  ChannelCubit isPressTypeCubit = ChannelCubit(0);

  // Controllers :
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  ScrollController scrollController = ScrollController();

  // Others :
  List<EstateType>? estatesTypes;
  PriceDomain? priceDomains;
  late SearchData estateOrder;
  late bool isDark;
  //late bool isTextFormFieldPressed ;
  //late bool reversedscroll ;
  LocationViewer? selectedLocation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //isTextFormFieldPressed = false ;
    //reversedscroll = false ;
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;

    estateOrder = SearchData(estateOfferTypeId: 1, description: "");
    estateOrder.estateOfferTypeId = 1;
    estateOrder.estateTypeId = 1;
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return BlocListener<EstateOrderBloc, EstateOrderState>(
      listener: (_, estateOrderState) async {
        if (estateOrderState is SendEstateOrderComplete) {
          Navigator.pushNamed(context, AfterEstateOrderScreen.id);
        } else if (estateOrderState is SendEstateOrderError) {
          var error = estateOrderState.isConnectionError
              ? AppLocalizations.of(context)!.no_internet_connection
              : estateOrderState.error;
          // await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);
          await buildSignInRequiredDialog();
        }
      },
      child: BackHomeScreen(
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(46.0),
              child: AppBar(
                iconTheme: IconThemeData(
                    color: isDark ? Colors.white : AppColors.black),
                centerTitle: true,
                backgroundColor:
                    isDark ? const Color(0xff26282B) : AppColors.white,
                title: Text(
                  AppLocalizations.of(context)!.create_estate_order,
                  style:
                      TextStyle(color: isDark ? Colors.white : AppColors.black),
                ),
                actions: [
                  InkWell(
                    child: BlocBuilder<NotificationsCubit, int>(
                      builder: (_, notificationsCount) {
                        return Padding(
                          padding: EdgeInsets.only(left: 0, right: 12.w),
                          child: IconBadge(
                            icon: const Icon(
                              Icons.notifications_outlined,
                            ),
                            itemCount: notificationsCount,
                            right: 0,
                            top: 5.h,
                            hideZero: true,
                          ),
                        );
                      },
                    ),
                    onTap: () async {
                      if (UserSharedPreferences.getAccessToken() == null) {
                        await showWonderfulAlertDialog(
                            context,
                            AppLocalizations.of(context)!.confirmation,
                            AppLocalizations.of(context)!
                                .this_features_require_login,
                            removeDefaultButton: true,
                            dialogButtons: [
                              ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context)!.sign_in,
                                ),
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, AuthenticationScreen.id);
                                  Navigator.pop(context);
                                },
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
                            width: 400.w);
                        return;
                      }
                      Navigator.pushNamed(context, NotificationScreen.id);
                    },
                  ),
                ],
              ),
            ),
            body: BlocBuilder<ChannelCubit, dynamic>(
              bloc: reversedscroll,
              builder: (_, ischecked) => BlocBuilder<ChannelCubit, dynamic>(
                bloc: isTextFormFieldPressed,
                builder: (_, ispressed) => GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    reversedscroll.setState(false);
                    isTextFormFieldPressed.setState(false);
                  },
                  child: SingleChildScrollView(
                    reverse: ischecked,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Container(
                        padding: kMediumSymWidth,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kHe4,
                                // Text(
                                //   AppLocalizations.of(context)!.order_type + " :",
                                // ),
                                // kHe12,
                                buildChoiceContainer(
                                    context: context,
                                    cubit: isRentCubit,
                                    textRight:
                                        AppLocalizations.of(context)!.buy,
                                    textLeft:
                                        AppLocalizations.of(context)!.rent,
                                    onTapRight: () {
                                      estateOrder.estateOfferTypeId = 1;
                                    },
                                    onTapLeft: () {
                                      estateOrder.estateOfferTypeId = 2;
                                    },
                                    paddingVertical: 5.h,
                                    paddingHorizontal: 0),
                                kHe16,
                                buildLocation(),
                                EstateTypeWidget(
                                  searchData: estateOrder,
                                  isPressTypeCubit: isPressTypeCubit,
                                  removeSelect: false,
                                  estateTypesByLocationBloc: null,
                                ),
                                PriceDomainWidget(
                                  isRentCubit: isRentCubit,
                                  searchData: estateOrder,
                                  startPriceCubit: startPriceCubit,
                                  endPriceCubit: endPriceCubit,
                                ),
                                //buildPriceDomain(isArabic, isDark),
                                buildNote(),
                                buildButton(),
                                kHe8,
                                // ispressed ? SizedBox(height: 260,) : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            drawer: SizedBox(
              width: getScreenWidth(context) * (75 / 100),
              child: const Drawer(
                child: MyDrawer(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocation() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined),
            kWi8,
            ResText(
              "${AppLocalizations.of(context)!.estate_location} :",
              textStyle: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: locationErrorCubit,
          builder: (_, errorMessage) {
            return TextField(
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
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: smallBorderRadius,
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.lightGrey2Color
                        : AppColors.lightblue,
                  ),
                ),
              ),
            );
          },
        ),
        kHe16,
      ],
    );
  }

  Widget buildNote() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.speaker_notes_outlined),
            kWi8,
            ResText(
              "${AppLocalizations.of(context)!.notes} :",
              textStyle: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: noteErrorCubit,
          builder: (_, errorMessage) {
            return BlocBuilder<ChannelCubit, dynamic>(
              bloc: isTextFormFieldPressed,
              builder: (_, ischecked) => BlocBuilder(
                bloc: reversedscroll,
                builder: (_, ispressed) => Container(
                  width: inf,
                  padding: kSmallSymWidth,
                  height: 150.h,
                  decoration: BoxDecoration(
                    borderRadius: smallBorderRadius,
                    border: Border.all(
                      color:
                          !isDark ? Colors.black38 : AppColors.lightGrey2Color,
                    ),
                  ),
                  child: TextField(
                    onTap: () {
                      isTextFormFieldPressed.setState(true);
                      reversedscroll.setState(true);
                    },
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
                ),
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
          fixedSize: const Size(400, 50),
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

  Future buildSignInRequiredDialog() async {
    await showWonderfulAlertDialog(
      context,
      AppLocalizations.of(context)!.error,
      AppLocalizations.of(context)!.this_features_require_login,
      removeDefaultButton: true,
      dialogButtons: [
        ElevatedButton(
          child: Text(
            AppLocalizations.of(context)!.sign_in,
          ),
          onPressed: () async {
            await Navigator.pushNamed(context, AuthenticationScreen.id);
            Navigator.pop(context);
          },
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
      width: 400.w,
    );
  }
}
