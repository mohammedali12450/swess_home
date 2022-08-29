import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate_offer_type.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/models/price_domain.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/presentation/screens/after_estate_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  // Controllers :
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  ScrollController scrollController = ScrollController();

  // Others :
  late List<EstateType> estatesTypes;
  late List<EstateOfferType> offerTypes;
  late List<PriceDomain> priceDomains;
  late int selectedEstateTypeId;

  late int selectedEstateOfferTypeId;

  int? selectedPriceDomainId;

  LocationViewer? selectedLocation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    offerTypes =
        BlocProvider.of<EstateOfferTypesBloc>(context).estateOfferTypes!;
    priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;

    selectedEstateTypeId = estatesTypes.first.id;
    selectedEstateOfferTypeId = offerTypes.first.id;
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    List<String> priceDomainsNames =
        priceDomains.map((e) => e.getTextPriceDomain(isArabic)).toList();
    // priceDomainsNames.insert(0, AppLocalizations.of(context)!.unselected);
    // Remove duplicates:
    priceDomainsNames = priceDomainsNames.toSet().toList();
    print(priceDomainsNames);

    return BlocListener<EstateOrderBloc, EstateOrderState>(
      listener: (_, estateOrderState) async {
        if (estateOrderState is SendEstateOrderComplete) {
          Navigator.pushNamed(context, AfterEstateOrderScreen.id);
        } else if (estateOrderState is SendEstateOrderError) {
          if (estateOrderState.isAuthorizationError) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              estateOrderState.error,
              removeDefaultButton: true,
              width: 400.w,
              dialogButtons: [
                ElevatedButton(
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text(
                    AppLocalizations.of(context)!.sign_in,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AuthenticationScreen.id);
                  },
                ),
              ],
            );
          } else {
            var error = estateOrderState.isConnectionError
                ? AppLocalizations.of(context)!.no_internet_connection
                : estateOrderState.error;
            await showWonderfulAlertDialog(
                context, AppLocalizations.of(context)!.error, error);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.create_estate_order,
            ),
            // actions: [
            //   // Container(
            //   //   margin: EdgeInsets.only(
            //   //     left: (isArabic) ? 16.w : 0,
            //   //     right: (!isArabic) ? 16.w : 0,
            //   //   ),
            //   //   child: IconButton(
            //   //     icon: const Icon(
            //   //       Icons.history,
            //   //       color: AppColors.white,
            //   //     ),
            //   //     onPressed: () {
            //   //       Navigator.pushNamed(context, RecentEstateOrdersScreen.id);
            //   //     },
            //   //   ),
            //   // )
            // ],
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              padding: kMediumSymWidth,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kHe16,
                    Text(
                      AppLocalizations.of(context)!.estate_location + " :",
                    ),
                    kHe12,
                    BlocBuilder<ChannelCubit, dynamic>(
                      bloc: locationErrorCubit,
                      builder: (_, errorMessage) {
                        return TextField(
                          textDirection: TextDirection.rtl,
                          onTap: () async {
                            selectedLocation = await Navigator.of(context)
                                    .pushNamed(SearchLocationScreen.id)
                                as LocationViewer?;
                            if (selectedLocation != null) {
                              officeAddressController.text =
                                  selectedLocation!.getLocationName();
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
                            hintText: AppLocalizations.of(context)!
                                .estate_location_hint,
                            contentPadding: kSmallSymWidth,
                            errorBorder: kOutlinedBorderRed,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.4),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    kHe24,
                    Text(
                      AppLocalizations.of(context)!.estate_type + " :",
                    ),
                    kHe12,
                    MyDropdownList(
                      elementsList: estatesTypes
                          .map((e) => e.getName(isArabic).split('|').first)
                          .toList(),
                      onSelect: (index) {
                        selectedEstateTypeId = estatesTypes.elementAt(index).id;
                      },
                      validator: (value) => value == null
                          ? AppLocalizations.of(context)!.this_field_is_required
                          : null,
                      selectedItem: AppLocalizations.of(context)!.please_select,
                    ),
                    kHe24,
                    Text(
                      AppLocalizations.of(context)!.order_type + " :",
                    ),
                    kHe12,
                    MyDropdownList(
                      elementsList: offerTypes.map((e) {
                        if (e.id == 1) {
                          return EstateOfferType(
                                  id: 1, nameArabic: "شراء", nameEnglish: "buy")
                              .getName(isArabic);
                        }
                        return e.getName(isArabic);
                      }).toList(),
                      onSelect: (index) {
                        selectedEstateOfferTypeId =
                            offerTypes.elementAt(index).id;
                      },
                      validator: (value) => value == null
                          ? AppLocalizations.of(context)!.this_field_is_required
                          : null,
                      selectedItem: AppLocalizations.of(context)!.please_select,
                    ),
                    kHe24,
                    Text(
                      AppLocalizations.of(context)!.price_domain + " :",
                    ),
                    kHe24,
                    MyDropdownList(
                      elementsList: priceDomainsNames,
                      onSelect: (index) {
                        bool isNoneSelected = index == 0;
                        selectedPriceDomainId = (isNoneSelected)
                            ? null
                            : priceDomains.elementAt(index - 1).id;
                      },
                      validator: (value) => value == null
                          ? AppLocalizations.of(context)!.this_field_is_required
                          : null,
                      selectedItem: AppLocalizations.of(context)!.please_select,
                    ),
                    kHe24,
                    Text(
                      AppLocalizations.of(context)!.notes + " :",
                    ),
                    kHe16,
                    Container(
                      width: inf,
                      padding: kSmallSymWidth,
                      height: 250.h,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextField(
                        maxLength: 600,
                        controller: notesController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: AppLocalizations.of(context)!
                              .order_create_notes_descriptions,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    kHe24,
                    Center(
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
                          if (selectedLocation == null) {
                            locationErrorCubit.setState(
                                AppLocalizations.of(context)!
                                    .this_field_is_required);
                            scrollController.animateTo(0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                            return;
                          }

                          EstateOrder estateOrder = EstateOrder(
                            locationId: selectedLocation!.id,
                            estateTypeId: selectedEstateTypeId,
                            estateOfferId: selectedEstateOfferTypeId,
                            priceDomainId: selectedPriceDomainId,
                            description: (notesController.text.isEmpty)
                                ? null
                                : notesController.text,
                          );
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            User? user =
                                BlocProvider.of<UserLoginBloc>(context).user;
                            String? token = (user == null) ? null : user.token;
                            BlocProvider.of<EstateOrderBloc>(context).add(
                              SendEstateOrderStarted(
                                  order: estateOrder, token: token),
                            );
                          }
                        },
                      ),
                    ),
                    kHe32,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
