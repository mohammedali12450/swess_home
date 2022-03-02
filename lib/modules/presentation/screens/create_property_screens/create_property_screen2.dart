import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/area_units_bloc/area_units_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/area_unit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/models/period_type.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'create_property_screen3.dart';

class CreatePropertyScreen2 extends StatefulWidget {
  static const String id = "CreatePropertyScreen2";
  final Estate currentOffer;

  const CreatePropertyScreen2({Key? key, required this.currentOffer}) : super(key: key);

  @override
  _CreatePropertyScreen2State createState() => _CreatePropertyScreen2State();
}

class _CreatePropertyScreen2State extends State<CreatePropertyScreen2> {
  // Blocs and cubits:

  ChannelCubit? selectedPeriodCubit;
  ChannelCubit areaErrorCubit = ChannelCubit(null);
  ChannelCubit priceErrorCubit = ChannelCubit(null);

  // other:
  late List<AreaUnit> areaTypes;

  late List<PeriodType> periodTypes;

  late List<OwnershipType> ownershipTypes;

  bool isSell = true;
  bool isHouse = true;

  // controllers:
  TextEditingController areaController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController roomsCountController = TextEditingController();
  TextEditingController periodController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initializing :
    isSell = widget.currentOffer.estateOfferType.id == sellOfferTypeNumber;
    isHouse = widget.currentOffer.estateType.id == housePropertyTypeNumber;
    areaTypes = BlocProvider.of<AreaUnitsBloc>(context).areaUnits!;
    periodTypes = BlocProvider.of<PeriodTypesBloc>(context).periodTypes!;
    ownershipTypes = BlocProvider.of<OwnershipTypeBloc>(context).ownershipTypes!;
    widget.currentOffer.areaUnit = areaTypes.first;
    if (!isHouse && isSell) {
      widget.currentOffer.ownershipType = ownershipTypes.first;
    }
    if (!isSell) {
      widget.currentOffer.periodType = periodTypes.first;
      selectedPeriodCubit = ChannelCubit(periodTypes.first.name.split("|").elementAt(1));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0;
    return CreatePropertyTemplate(
      headerIconPath: areaOutlineIconPath,
      headerText: "الخطوة الثانية",
      body: SingleChildScrollView(
        child: Column(
          children: [
            kHe24,
            SizedBox(
              width: inf,
              child: ResText(
                ":مساحة العقار",
                textStyle: textStyling(S.s18, W.w6, C.bl),
                textAlign: TextAlign.right,
              ),
            ),
            kHe16,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: MyDropdownList(
                      elementsList: areaTypes.map((e) => e.name).toList(),
                      onSelect: (index) {
                        widget.currentOffer.areaUnit = areaTypes.elementAt(index);
                      },
                      isOnChangeNull: isKeyboardOpened,
                    ),
                  ),
                ),
                kWi12,
                Expanded(
                  flex: 2,
                  child: BlocBuilder<ChannelCubit, dynamic>(
                      bloc: areaErrorCubit,
                      builder: (_, errorMessage) {
                        return TextField(
                          style: textStyling(S.s17, W.w4, C.bl, fontFamily: F.roboto)
                              .copyWith(letterSpacing: 0.3),
                          controller: areaController,
                          keyboardType: TextInputType.number,
                          cursorColor: black,
                          decoration: InputDecoration(
                            errorText: errorMessage,
                            isDense: true,
                            border: kOutlinedBorderBlack,
                            focusedBorder: kOutlinedBorderBlack,
                          ),
                          onChanged: (_) {
                            areaErrorCubit.setState(null);
                          },
                        );
                      }),
                ),
              ],
            ),
            kHe24,
            SizedBox(
              width: inf,
              child: ResText(
                (isSell) ? ":سعر العقار" : ":سعر إيجار العقار",
                textStyle: textStyling(S.s18, W.w6, C.bl),
                textAlign: TextAlign.right,
              ),
            ),
            kHe16,
            Row(
              children: [
                (isSell)
                    ? Container()
                    : Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: MyDropdownList(
                            isOnChangeNull: isKeyboardOpened,
                            elementsList: periodTypes.map((e) => e.name.split('|').first).toList(),
                            onSelect: (index) {
                              widget.currentOffer.periodType = periodTypes.elementAt(index);
                              selectedPeriodCubit!.setState(
                                  periodTypes.elementAt(index).name.split('|').elementAt(1));
                            },
                          ),
                        ),
                      ),
                kWi12,
                Expanded(
                  flex: 2,
                  child: BlocBuilder<ChannelCubit, dynamic>(
                    bloc: priceErrorCubit,
                    builder: (_, errorMessage) => TextField(
                      style: textStyling(S.s17, W.w4, C.bl, fontFamily: F.roboto)
                          .copyWith(letterSpacing: 0.3),
                      controller: priceController,
                      cursorColor: black,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: errorMessage,
                        suffix: ResText(
                          "ل.س",
                          textStyle: textStyling(S.s16, W.w5, C.bl),
                        ),
                        border: kOutlinedBorderBlack,
                        focusedBorder: kOutlinedBorderBlack,
                        isDense: true,
                      ),
                      onChanged: (value) {
                        priceController.text =
                            NumbersHelper.getMoneyFormat(int.parse(value.replaceAll(',', '')));
                        priceController.selection = TextSelection.fromPosition(
                          TextPosition(offset: priceController.text.length),
                        );
                        priceErrorCubit.setState(null);
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (!isSell) ...[
              kHe24,
              SizedBox(
                width: inf,
                child: ResText(
                  ":مدة إيجار العقار",
                  textStyle: textStyling(S.s18, W.w6, C.bl),
                  textAlign: TextAlign.right,
                ),
              ),
              kHe12,
              TextField(
                style: textStyling(S.s17, W.w4, C.bl, fontFamily: F.roboto)
                    .copyWith(letterSpacing: 0.3),
                controller: periodController,
                cursorColor: black,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffix: BlocBuilder<ChannelCubit, dynamic>(
                    bloc: selectedPeriodCubit,
                    builder: (_, periodName) {
                      return ResText(
                        periodName,
                        textStyle: textStyling(S.s16, W.w5, C.bl),
                      );
                    },
                  ),
                  border: kOutlinedBorderBlack,
                  focusedBorder: kOutlinedBorderBlack,
                  isDense: true,
                ),
              ),
            ],

            // If the selected property type is house :
            if (isHouse) ...[
              kHe24,
              SizedBox(
                width: inf,
                child: ResText(
                  ":عدد الغرف ( اختياري )",
                  textStyle: textStyling(S.s18, W.w6, C.bl),
                  textAlign: TextAlign.right,
                ),
              ),
              kHe16,
              TextField(
                controller: roomsCountController,
                cursorColor: black,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  border: kUnderlinedBorderBlack,
                  focusedBorder: kUnderlinedBorderBlack,
                ),
              ),
              kHe24,
              SizedBox(
                width: inf,
                child: ResText(
                  ":رقم الطابق ( اختياري )",
                  textStyle: textStyling(S.s18, W.w6, C.bl),
                  textAlign: TextAlign.right,
                ),
              ),
              kHe16,
              TextField(
                controller: floorController,
                cursorColor: black,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  border: kUnderlinedBorderBlack,
                  focusedBorder: kUnderlinedBorderBlack,
                ),
              ),
            ],
            // If the selected property type is shops and lands :
            if (isSell && !isHouse) ...[
              kHe24,
              SizedBox(
                width: inf,
                child: ResText(
                  ":نوع الملكية",
                  textStyle: textStyling(S.s18, W.w6, C.bl),
                  textAlign: TextAlign.right,
                ),
              ),
              kHe16,
              MyDropdownList(
                elementsList: ownershipTypes.map((e) => e.name).toList(),
                onSelect: (index) {
                  widget.currentOffer.ownershipType = ownershipTypes.elementAt(index);
                },
              ),
            ],
            kHe40,
            MyButton(
              child: ResText(
                "التالي",
                textStyle: textStyling(S.s16, W.w5, C.wh),
              ),
              width: Res.width(240),
              height: Res.height(56),
              color: secondaryColor,
              onPressed: () {
                if (!validateData()) return;
                widget.currentOffer.area = areaController.text;
                widget.currentOffer.price = priceController.text.replaceAll(",", "");
                if (!isSell) {
                  widget.currentOffer.period = periodController.text;
                }
                if (isHouse) {
                  widget.currentOffer.roomsCount = roomsCountController.text;
                  widget.currentOffer.floor = floorController.text;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePropertyScreen3(currentOffer: widget.currentOffer),
                  ),
                );
              },
            ),
            kHe12,
          ],
        ),
      ),
    );
  }

  bool validateData() {
    bool validation = true;

    if (areaController.text.isEmpty) {
      areaErrorCubit.setState("هذا الحقل مطلوب");
      validation = false;
    }
    if (priceController.text.isEmpty) {
      priceErrorCubit.setState("هذا الحقل مطلوب");
      validation = false;
    }

    return validation;
  }
}
