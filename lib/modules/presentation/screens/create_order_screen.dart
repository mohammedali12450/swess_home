import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
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
import 'package:swesshome/modules/presentation/screens/after_estate_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/recent_estates_orders_screen.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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

  @override
  void initState() {
    // TODO: implement initState
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
    List<String> priceDomainsNames =
        priceDomains.map((e) => e.getTextPriceDomain(true)).toList();
    priceDomainsNames.insert(0, "غير محدد");

    return BlocListener<EstateOrderBloc, EstateOrderState>(
      listener: (_, estateOrderState) {
        if (estateOrderState is SendEstateOrderComplete) {
          Navigator.pushNamed(context, AfterEstateOrderScreen.id);
        }
        else if (estateOrderState is SendEstateOrderError) {
          if (estateOrderState.isAuthorizationError) {
            showWonderfulAlertDialog(
              context,
              "خطأ",
              estateOrderState.error,
              removeDefaultButton: true,
              width: Res.width(400),
              dialogButtons: [
                MyButton(
                  width: Res.width(150),
                  color: AppColors.secondaryColor,
                  child: ResText(
                    "إلغاء",
                    textStyle: textStyling(S.s16, W.w5, C.wh),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MyButton(
                  width: Res.width(150),
                  color: AppColors.secondaryColor,
                  child: ResText(
                    "تسجيل الدخول",
                    textStyle: textStyling(S.s16, W.w5, C.wh),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AuthenticationScreen.id);
                  },
                ),
              ],
            );
          } else {
            showWonderfulAlertDialog(context, "خطأ", estateOrderState.error);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: Res.height(75),
            backgroundColor: AppColors.secondaryColor,
            automaticallyImplyLeading: false,
            actions: [
              Container(
                margin: EdgeInsets.only(
                  right: Res.width(16),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
              ),
            ],
            title: SizedBox(
              width: inf,
              child: ResText(
                "إنشاء طلب عقاري",
                textStyle: textStyling(S.s18, W.w5, C.wh),
                textAlign: TextAlign.right,
              ),
            ),
            leading: Container(
              margin: EdgeInsets.only(
                left: Res.width(16),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.history,
                  color: AppColors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RecentEstateOrdersScreen.id) ;
                },
              ),
            ),
          ),
          body: Container(
            padding: kMediumSymWidth,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  kHe16,
                  SizedBox(
                    width: inf,
                    child: ResText(
                      ":مكان العقار",
                      textStyle: textStyling(S.s18, W.w5, C.bl),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  kHe12,
                  BlocBuilder<ChannelCubit, dynamic>(
                    bloc: locationErrorCubit,
                    builder: (_, errorMessage) {
                      return TextField(
                        style: textStyling(S.s14, W.w5, C.bl)
                            .copyWith(height: 1.8),
                        textDirection: TextDirection.rtl,
                        onTap: () async {
                          selectedLocation = await Navigator.of(context)
                                  .pushNamed(SearchLocationScreen.id)
                              as LocationViewer?;
                          if (selectedLocation != null) {
                            officeAddressController.text =
                                selectedLocation!.getLocationName();
                            locationErrorCubit.setState(null);
                          }
                        },
                        controller: officeAddressController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                          errorText: errorMessage,
                          hintText: 'أدخل مكان العقار مثل المالكي, الميدان ..',
                          hintStyle: textStyling(S.s14, W.w5, C.hint),
                          hintTextDirection: TextDirection.rtl,
                          contentPadding: kSmallSymWidth,
                          errorBorder: kOutlinedBorderRed,
                          focusedBorder: kOutlinedBorderBlack,
                          enabledBorder: kOutlinedBorderGrey,
                        ),
                      );
                    },
                  ),
                  kHe24,
                  SizedBox(
                    width: inf,
                    child: ResText(
                      ":نوع العقار",
                      textStyle: textStyling(S.s18, W.w5, C.bl),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  kHe12,
                  MyDropdownList(
                    elementsList: estatesTypes
                        .map((e) => e.getName(true).split('|').first)
                        .toList(),
                    onSelect: (index) {
                      selectedEstateTypeId = estatesTypes.elementAt(index).id;
                    },
                  ),
                  kHe24,
                  SizedBox(
                    width: inf,
                    child: ResText(
                      ":نوع العرض",
                      textStyle: textStyling(S.s18, W.w5, C.bl),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  kHe12,
                  MyDropdownList(
                    elementsList: offerTypes.map((e) => e.getName(true)).toList(),
                    onSelect: (index) {
                      selectedEstateOfferTypeId =
                          offerTypes.elementAt(index).id;
                    },
                  ),
                  kHe24,
                  SizedBox(
                    width: inf,
                    child: ResText(
                      ": مجال السعر",
                      textStyle: textStyling(S.s18, W.w5, C.bl),
                      textAlign: TextAlign.right,
                    ),
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
                  ),
                  kHe24,
                  SizedBox(
                    width: inf,
                    child: ResText(
                      ":ملاحظات",
                      textStyle: textStyling(S.s18, W.w5, C.bl),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  kHe16,
                  Container(
                    width: inf,
                    padding: kSmallSymWidth,
                    height: Res.height(250),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      style: textStyling(S.s16, W.w5, C.bl),
                      controller: notesController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "اكتب الملاحظات المرافقة للطلب",
                        hintStyle: textStyling(S.s14, W.w5, C.hint),
                        hintTextDirection: TextDirection.rtl,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  kHe24,
                  MyButton(
                    child: BlocBuilder<EstateOrderBloc, EstateOrderState>(
                      builder: (_, estateOrderState) {
                        if (estateOrderState is SendEstateOrderProgress) {
                          return const SpinKitWave(
                            color: AppColors.white,
                            size: 24,
                          );
                        }
                        return ResText(
                          "إرسال الطلب",
                          textStyle: textStyling(S.s18, W.w5, C.wh),
                        );
                      },
                    ),
                    color: AppColors.secondaryColor,
                    width: Res.width(200),
                    onPressed: () {
                      if (selectedLocation == null) {
                        locationErrorCubit.setState("قم بتحديد موقع العقار");
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

                      User? user = BlocProvider.of<UserLoginBloc>(context).user;
                      String? token = (user == null) ? null : user.token;
                      BlocProvider.of<EstateOrderBloc>(context).add(
                        SendEstateOrderStarted(
                            order: estateOrder, token: token),
                      );
                    },
                  ),
                  kHe32,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
