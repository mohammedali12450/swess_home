import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/modules/business_logic_components/bloc/area_units_bloc/area_units_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/area_unit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/models/period_type.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'create_property_screen3.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePropertyScreen2 extends StatefulWidget {
  static const String id = "CreatePropertyScreen2";
  final Estate currentOffer;

  const CreatePropertyScreen2({Key? key, required this.currentOffer})
      : super(key: key);

  @override
  _CreatePropertyScreen2State createState() => _CreatePropertyScreen2State();
}

class _CreatePropertyScreen2State extends State<CreatePropertyScreen2> {
  // Blocs and cubits:

  ChannelCubit? selectedPeriodCubit;
  ChannelCubit areaErrorCubit = ChannelCubit(null);
  ChannelCubit priceErrorCubit = ChannelCubit(null);
  ChannelCubit periodErrorCubit = ChannelCubit(null);

  // other:
  late List<AreaUnit> areaTypes;

  late List<PeriodType> periodTypes;

  late List<OwnershipType> ownershipTypes;

  bool isSell = true;
  bool isHouse = true;

  bool isForStore = false;

  // controllers:
  TextEditingController areaController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController roomsCountController = TextEditingController();
  TextEditingController periodController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // initializing :
    areaTypes = BlocProvider.of<AreaUnitsBloc>(context).areaUnits!;
    periodTypes = BlocProvider.of<PeriodTypesBloc>(context).periodTypes!;
    ownershipTypes =
        BlocProvider.of<OwnershipTypeBloc>(context).ownershipTypes!;
    isSell = widget.currentOffer.estateOfferType!.id == sellOfferTypeNumber;
    isHouse = widget.currentOffer.estateType!.id == housePropertyTypeNumber;
    widget.currentOffer.areaUnit = areaTypes.first;
    if (!isHouse && isSell) {
      widget.currentOffer.ownershipType = ownershipTypes.first;
    }

    if (!isSell) {
      widget.currentOffer.periodType = periodTypes.first;
      selectedPeriodCubit =
          ChannelCubit(periodTypes.first.name.split("|").elementAt(1));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0;

    isForStore = BlocProvider.of<SystemVariablesBloc>(context)
        .systemVariables!
        .isForStore;

    List<Widget> priceWidget = [
      Expanded(
        flex: 1,
        child: BlocBuilder<ChannelCubit, dynamic>(
          bloc: areaErrorCubit,
          builder: (_, errorMessage) {
            return Padding(
              padding: EdgeInsets.only(top: isArabic? 12 : 8),
              child: TextField(
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
              ),
            );
          },
        ),
      ),
      10.horizontalSpace,
      Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: MyDropdownList(
              isOnChangeNull: isKeyboardOpened,
              elementsList: areaTypes.map((e) => e.name).toList(),
              onSelect: (index) {
                widget.currentOffer.areaUnit = areaTypes.elementAt(index);
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

    return CreatePropertyTemplate(
      headerIconPath: areaOutlineIconPath,
      headerText: AppLocalizations.of(context)!.step_2,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.verticalSpace,
              Text(
                "${AppLocalizations.of(context)!.estate_area} :",
              ),
              // 8.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: priceWidget),
              20.verticalSpace,
              Text(
                (isSell)
                    ? "${AppLocalizations.of(context)!.estate_price} :"
                    : "${AppLocalizations.of(context)!.estate_rent_price} :",
              ),
              // 16.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: BlocBuilder<ChannelCubit, dynamic>(
                      bloc: priceErrorCubit,
                      builder: (_, errorMessage) {
                        late String hintText;

                        if (isForStore) {
                          hintText = (isSell)
                              ? AppLocalizations.of(context)!
                                  .estate_price_hint_lebanon
                              : AppLocalizations.of(context)!
                                  .estate_rent_price_hint_lebanon;
                        } else {
                          hintText = (isSell)
                              ? AppLocalizations.of(context)!
                                  .estate_price_hint_syrian
                              : AppLocalizations.of(context)!
                                  .estate_rent_price_hint_syrian;
                        }

                        return Padding(
                          padding: EdgeInsets.only(top: isArabic? 12 : 8),
                          child: TextField(
                            textDirection: TextDirection.ltr,
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: hintText,
                              errorText: errorMessage,
                              isDense: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onBackground,
                            onChanged: (value) {
                              if (!NumbersHelper.isNumeric(
                                  value.replaceAll(",", ""))) {
                                priceErrorCubit.setState(
                                    AppLocalizations.of(context)!.invalid_value);
                                return;
                              }
                              priceController.text = NumbersHelper.getMoneyFormat(
                                  int.parse(value.replaceAll(',', '')));
                              priceController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: priceController.text.length),
                              );
                              priceErrorCubit.setState(null);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  12.horizontalSpace,
                  (isSell)
                      ? Container()
                      : Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              FocusScope.of(context).unfocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: MyDropdownList(
                                isOnChangeNull: isKeyboardOpened,
                                elementsList: periodTypes
                                    .map((e) =>
                                        e.name.split("|").first)
                                    .toList(),
                                onSelect: (index) {
                                  widget.currentOffer.periodType =
                                      periodTypes.elementAt(index);
                                  selectedPeriodCubit!.setState(
                                    periodTypes
                                        .elementAt(index)
                                        .name
                                        .split("|")
                                        .elementAt(1),
                                  );
                                },
                                validator: (value) => value == null
                                    ? AppLocalizations.of(context)!
                                        .this_field_is_required
                                    : null,
                                selectedItem: AppLocalizations.of(context)!
                                    .please_select_here,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              if (!isSell) ...[
                24.verticalSpace,
                Text(
                  "${AppLocalizations.of(context)!.estate_rent_period} :",
                  textAlign: TextAlign.right,
                ),
                // 12.verticalSpace,
                BlocBuilder<ChannelCubit, dynamic>(
                  bloc: periodErrorCubit,
                  builder: (_, errorMessage) {
                    return TextField(
                      textDirection: TextDirection.ltr,
                      controller: periodController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: errorMessage,
                        suffix: BlocBuilder<ChannelCubit, dynamic>(
                          bloc: selectedPeriodCubit,
                          builder: (_, periodName) {
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Text(
                                periodName,
                              ),
                            );
                          },
                        ),
                        isDense: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                      ),
                      cursorColor: Theme.of(context).colorScheme.onBackground,
                      onChanged: (_) {
                        periodErrorCubit.setState(null);
                      },
                    );
                  },
                ),
              ],
              if (isHouse) ...[
                24.verticalSpace,
                Text(
                  "${AppLocalizations.of(context)!.rooms_count} ( ${AppLocalizations.of(context)!.optional} ) :",
                ),
                // 16.verticalSpace,
                TextField(
                  controller: roomsCountController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.rooms_count_hint,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  cursorColor: Theme.of(context).colorScheme.onBackground,
                ),
                24.verticalSpace,
                Text(
                  "${AppLocalizations.of(context)!.floor_number} ( ${AppLocalizations.of(context)!.optional} ) :",
                ),
                // 16.verticalSpace,
                TextField(
                  controller: floorController,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.floor_hint,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  cursorColor: Theme.of(context).colorScheme.onBackground,
                ),
              ],
              if (isSell && !isHouse) ...[
                24.verticalSpace,
                Text(
                  "${AppLocalizations.of(context)!.ownership_type} :",
                ),
                // 16.verticalSpace,
                MyDropdownList(
                  elementsList:
                      ownershipTypes.map((e) => e.name).toList(),
                  onSelect: (index) {
                    widget.currentOffer.ownershipType =
                        ownershipTypes.elementAt(index);
                  },
                  validator: (value) => value == null
                      ? AppLocalizations.of(context)!.this_field_is_required
                      : null,
                  selectedItem: AppLocalizations.of(context)!.please_select,
                ),
              ],
              40.verticalSpace,
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(240.w, 64.h)),
                  child: Text(
                    AppLocalizations.of(context)!.next,
                  ),
                  onPressed: () {
                    if (!validateData()) return;
                    widget.currentOffer.area = areaController.text;
                    widget.currentOffer.price =
                        priceController.text.replaceAll(",", "");
                    if (!isSell) {
                      widget.currentOffer.period = periodController.text;
                    }
                    if (isHouse) {
                      widget.currentOffer.roomsCount =
                          roomsCountController.text;
                      widget.currentOffer.floor = floorController.text;
                    }
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreatePropertyScreen3(
                              currentOffer: widget.currentOffer),
                        ),
                      );
                    }
                  },
                ),
              ),
              // 42.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  bool validateData() {
    bool validation = true;

    if (areaController.text.isEmpty) {
      areaErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      validation = false;
    }
    if (!NumbersHelper.isNumeric(areaController.text)) {
      areaErrorCubit.setState(AppLocalizations.of(context)!.invalid_value);
    }

    if (priceController.text.isEmpty) {
      priceErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      validation = false;
    }
    if (!isSell && periodController.text.isEmpty) {
      periodErrorCubit
          .setState(AppLocalizations.of(context)!.this_field_is_required);
      validation = false;
    }

    return validation;
  }
}
