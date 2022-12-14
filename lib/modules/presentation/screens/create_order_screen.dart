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
import 'package:swesshome/modules/presentation/widgets/shimmers/notifications_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_state.dart';
import '../../business_logic_components/bloc/estate_types_bloc/estate_types_state.dart';
import '../../business_logic_components/bloc/price_domains_bloc/price_domains_state.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/estate_offer_types_repository.dart';
import '../../data/repositories/estate_types_repository.dart';
import '../../data/repositories/price_domains_repository.dart';
import '../widgets/fetch_result.dart';
import '../widgets/price_picker.dart';
import 'search_location_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  static const String id = "CreateOrderScreen";

  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  // Blocs and Cubits :
  EstateTypesBloc estateTypesBloc = EstateTypesBloc(EstateTypesRepository());
  EstateOfferTypesBloc offerTypesBloc =
      EstateOfferTypesBloc(EstateOfferTypesRepository());
  PriceDomainsBloc priceDomainsBloc =
      PriceDomainsBloc(PriceDomainsRepository());

  ChannelCubit locationErrorCubit = ChannelCubit(null);
  ChannelCubit startPriceCubit = ChannelCubit(0);
  ChannelCubit endPriceCubit = ChannelCubit(0);

  // Controllers :
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  ScrollController scrollController = ScrollController();

  // Others :
  List<EstateType>? estatesTypes;
  List<EstateOfferType>? offerTypes;
  PriceDomain? priceDomains;
  int? selectedEstateTypeId;

  int? selectedEstateOfferTypeId;

  int? selectedPriceDomainId;

  LocationViewer? selectedLocation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    //estateTypesBloc.add(EstateTypesFetchStarted());
    //offerTypesBloc.add(EstateOfferTypesFetchStarted());
    //priceDomainsBloc.add(PriceDomainsFetchStarted("rent"));

    estatesTypes = BlocProvider.of<EstateTypesBloc>(context).estateTypes!;
    offerTypes = BlocProvider.of<EstateOfferTypesBloc>(context).estateOfferTypes!;
    priceDomains = BlocProvider.of<PriceDomainsBloc>(context).priceDomains!;

    //selectedEstateTypeId = estatesTypes.first.id;
    //selectedEstateOfferTypeId = offerTypes.first.id;
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

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
          ),
          body: BlocBuilder<PriceDomainsBloc, PriceDomainsState>(
            bloc: priceDomainsBloc,
            builder: (_, priceDomainState){
              if (priceDomainState is PriceDomainsFetchProgress) {
                return const NotificationsShimmer();
              }
              return  Form(
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
                        BlocBuilder<EstateTypesBloc, EstateTypesState>(
                          bloc: estateTypesBloc,
                          builder: (_, estateTypesState) {
                            if (estateTypesState is EstateTypesFetchError) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                    width: 1.sw,
                                    height: 1.sh - 75.h,
                                    child: FetchResult(
                                        content: AppLocalizations.of(context)!
                                            .error_happened_when_executing_operation)),
                              );
                            }
                            if (estateTypesState is EstateTypesFetchProgress) {
                              return SpinKitWave(
                                color: Theme.of(context).colorScheme.background,
                                size: 24.w,
                              );
                            } else if (estateTypesState is EstateTypesFetchComplete) {
                              estatesTypes = estateTypesState.estateTypes!;
                              // List<String> estateTypesAdd =
                              //     estatesTypes!.map((e) => e.name.split('|').first).toList();
                              // estateTypesAdd.insert(
                              //   0,
                              //   AppLocalizations.of(context)!.undefined,
                              // );
                              // estateTypesAdd = estateTypesAdd.toSet().toList();
                            }
                            return MyDropdownList(
                              elementsList:
                              estatesTypes!.map((e) => e.name.split('|').first).toList(),
                              onSelect: (index) {
                                // set search data estate type :
                                selectedEstateTypeId =
                                    estatesTypes!.elementAt(index).id;
                              },
                              validator: (value) => value == null
                                  ? AppLocalizations.of(context)!.this_field_is_required
                                  : null,
                              selectedItem: AppLocalizations.of(context)!.please_select,
                            );
                          },
                        ),
                        kHe24,
                        Text(
                          AppLocalizations.of(context)!.order_type + " :",
                        ),
                        kHe12,
                        BlocBuilder<EstateOfferTypesBloc, EstateOfferTypesState>(
                          bloc: offerTypesBloc,
                          builder: (_, offerTypesState) {
                            if (offerTypesState is EstateOfferTypesFetchError) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                    width: 1.sw,
                                    height: 1.sh - 75.h,
                                    child: FetchResult(
                                        content: AppLocalizations.of(context)!
                                            .error_happened_when_executing_operation)),
                              );
                            }
                            if (offerTypesState is EstateOfferTypesFetchProgress) {
                              return SpinKitWave(
                                color: Theme.of(context).colorScheme.background,
                                size: 24.w,
                              );
                            } else if (offerTypesState
                            is EstateOfferTypesFetchComplete) {
                              offerTypes = offerTypesState.estateOfferTypes!;
                            }
                            return MyDropdownList(
                              elementsList: offerTypes!.map((e) {
                                if (e.id == 1) {
                                  return EstateOfferType(
                                    id: 1,
                                    name: isArabic ? "شراء" : "buy",
                                  ).name;
                                }
                                return e.name;
                              }).toList(),
                              onSelect: (index) {
                                selectedEstateOfferTypeId =
                                    offerTypes!.elementAt(index).id;
                              },
                              validator: (value) => value == null
                                  ? AppLocalizations.of(context)!
                                  .this_field_is_required
                                  : null,
                              selectedItem:
                              AppLocalizations.of(context)!.please_select,
                            );
                          },
                        ),
                        kHe24,
                        Text(
                          AppLocalizations.of(context)!.price_domain + " :",
                        ),
                        kHe24,
                        BlocBuilder<PriceDomainsBloc, PriceDomainsState>(
                          bloc: priceDomainsBloc,
                          builder: (_, priceDomainState) {
                            if (priceDomainState is PriceDomainsFetchProgress) {
                              return SpinKitWave(
                                color: Theme.of(context).colorScheme.background,
                                size: 24.w,
                              );
                            } else if (priceDomainState
                            is PriceDomainsFetchComplete) {
                              priceDomains = priceDomainState.priceDomains!;
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(AppLocalizations.of(context)!
                                                .min_price),
                                          ],
                                        ),
                                        Align(
                                          alignment: isArabic
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await openPricePicker(
                                                context,
                                                isDark,
                                                title: AppLocalizations.of(context)!
                                                    .title_min_price,
                                                items: priceDomains!.min
                                                    .map(
                                                      (names) => Text(
                                                    names,
                                                    // textScaleFactor: 1.2,
                                                    // textAlign: TextAlign.center,
                                                  ),
                                                )
                                                    .toList(),
                                                onSubmit: (data) {
                                                  startPriceCubit.setState(data);
                                                },
                                              );
                                            },
                                            child:
                                            BlocBuilder<ChannelCubit, dynamic>(
                                              bloc: startPriceCubit,
                                              builder: (_, state) {
                                                return Container(
                                                  alignment: isArabic
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                                  height: 55.h,
                                                  width: 150.w,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                      border: Border.all(
                                                        color:
                                                        AppColors.primaryColor,
                                                        width: 1,
                                                      )),
                                                  child: Text(
                                                      priceDomains!.min[state]),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  kWi24,
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(AppLocalizations.of(context)!
                                                .max_price),
                                          ],
                                        ),
                                        Align(
                                          alignment: isArabic
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await openPricePicker(
                                                context,
                                                isDark,
                                                title: AppLocalizations.of(context)!
                                                    .title_max_price,
                                                items: priceDomains!.max
                                                    .map(
                                                      (names) => Text(
                                                    names,
                                                    // textScaleFactor: 1.2,
                                                    // textAlign: TextAlign.center,
                                                  ),
                                                )
                                                    .toList(),
                                                onSubmit: (data) {
                                                  endPriceCubit.setState(data);
                                                },
                                              );
                                            },
                                            child: BlocBuilder<ChannelCubit,
                                                dynamic>(
                                                bloc: endPriceCubit,
                                                builder: (_, state) {
                                                  return Container(
                                                    alignment: isArabic
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    height: 55.h,
                                                    width: 150.w,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.w),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(8)),
                                                        border: Border.all(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 1,
                                                        )),
                                                    child: Text(
                                                        priceDomains!.max[state]),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
                                String? token = (user == null)
                                    ? null
                                    : UserSharedPreferences.getAccessToken()!;
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
              );
            },
          ),
        ),
      ),
    );
  }
}
