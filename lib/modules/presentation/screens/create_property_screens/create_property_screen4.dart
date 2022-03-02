import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/interior_status.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/row_information_switcher.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'build_images_selectors.dart';
import 'create_property_screen5.dart';

class CreatePropertyScreen4 extends StatefulWidget {
  static const String id = "CreatePropertyScreen4";

  final Estate currentOffer;

  const CreatePropertyScreen4({Key? key, required this.currentOffer})
      : super(key: key);

  @override
  _CreatePropertyScreen4State createState() => _CreatePropertyScreen4State();
}

class _CreatePropertyScreen4State extends State<CreatePropertyScreen4> {
  bool isShops = false;
  bool isLands = false;
  bool isSell = false;
  bool isFarmsOrVacations = false;
  bool isHouse = false;

  late List<OwnershipType> ownershipTypes;

  late List<InteriorStatus> interiorStatuses;

  List<File>? propertyImages;

  List<File>? streetPropertyImages;

  File? floorPlanPropertyImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int estateType = widget.currentOffer.estateType.id;
    isLands = (estateType == landsPropertyTypeNumber);
    isShops = (estateType == shopsPropertyTypeNumber);
    isSell = widget.currentOffer.estateOfferType.id == sellOfferTypeNumber;
    isFarmsOrVacations = (estateType == farmsPropertyTypeNumber) ||
        (estateType == vacationsPropertyTypeNumber);
    isHouse = (estateType == housePropertyTypeNumber);
    ownershipTypes =
        BlocProvider.of<OwnershipTypeBloc>(context).ownershipTypes!;
    interiorStatuses =
        BlocProvider.of<InteriorStatusesBloc>(context).interiorStatuses!;

    if (isSell && isHouse) {
      widget.currentOffer.ownershipType = ownershipTypes.first;
    }
    if (!isLands) {
      widget.currentOffer.interiorStatus = interiorStatuses.first;
    }
    if (isFarmsOrVacations) {
      widget.currentOffer.hasSwimmingPool = false;
      widget.currentOffer.isOnBeach = false;
    }
    if (!isLands && !isShops) {
      widget.currentOffer.isFurnished = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath:
          (isLands || isShops) ? imageOutlineIconPath : chairOutlineIconPath,
      headerText: "الخطوة الرابعة",
      body: (isLands || isShops)
          ? SingleChildScrollView(
            child: Column(
                children: [
                  buildImagesSelectors(
                    onPropertyImagesSelected: (images) {
                      propertyImages = (images == null)? null : images.map((e) => e as File).toList() ;
                    },
                    onStreetImagesSelected: (images) {
                      streetPropertyImages = (images == null)? null : images.map((e) => e as File).toList() ;
                    },
                    onFloorPlanImagesSelected: (images) {
                      floorPlanPropertyImage = (images == null) ? null : images.first;
                    },
                  ),
                  kHe36,
                  MyButton(
                    child: ResText(
                      "التالي",
                      textStyle: textStyling(S.s16, W.w5, C.wh),
                    ),
                    width: Res.width(240),
                    height: Res.height(56),
                    color: secondaryColor,
                    onPressed: () {
                      widget.currentOffer.estateImages = propertyImages!;
                      widget.currentOffer.streetImages = streetPropertyImages;
                      widget.currentOffer.floorPlanImage = floorPlanPropertyImage;
                      widget.currentOffer.floorPlanImage =
                          floorPlanPropertyImage;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreatePropertyScreen5(
                              currentOffer: widget.currentOffer),
                        ),
                      );
                    },
                  ),
                  kHe24,

                ],
              ),
          )
          : Column(
              children: [
                if (isSell & isHouse) ...[
                  kHe24,
                  SizedBox(
                    width: inf,
                    child: ResText(
                      ":نوع العرض",
                      textStyle: textStyling(S.s18, W.w6, C.bl),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  kHe16,
                  MyDropdownList(
                    elementsList: ownershipTypes.map((e) => e.name).toList(),
                    onSelect: (index) {
                      widget.currentOffer.ownershipType =
                          ownershipTypes.elementAt(index);
                    },
                  ),
                ],
                if (!isLands) ...[
                  kHe24,
                  SizedBox(
                    width: inf,
                    child: ResText(
                      ":حالة العقار",
                      textStyle: textStyling(S.s18, W.w6, C.bl),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  kHe16,
                  MyDropdownList(
                    elementsList: interiorStatuses.map((e) => e.name).toList(),
                    onSelect: (index) {
                      widget.currentOffer.interiorStatus =
                          interiorStatuses.elementAt(index);
                    },
                  ),
                ],
                kHe32,
                if (!isShops || !isLands)
                  RowInformationSwitcher(
                    content: "هل العقار مفروش؟",
                    switcherContent: "نعم",
                    onSelected: (isPressed) {
                      widget.currentOffer.isFurnished = isPressed;
                    },
                  ),
                if (isFarmsOrVacations) ...[
                  kHe28,
                  RowInformationSwitcher(
                    content: "هل العقار مطل على الشاطئ؟",
                    switcherContent: "نعم",
                    onSelected: (isPressed) {
                      widget.currentOffer.isOnBeach = isPressed;
                    },
                  ),
                  kHe28,
                  RowInformationSwitcher(
                    content: "هل العقار يحوي مسبح؟",
                    switcherContent: "نعم",
                    onSelected: (isPressed) {
                      widget.currentOffer.hasSwimmingPool = isPressed;
                    },
                  ),
                ],
                kHe36,
                MyButton(
                  child: ResText(
                    "التالي",
                    textStyle: textStyling(S.s16, W.w5, C.wh),
                  ),
                  width: Res.width(240),
                  height: Res.height(56),
                  color: secondaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreatePropertyScreen5(
                            currentOffer: widget.currentOffer),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  bool landsAndShopsValidateDate() {
    int minimumEstateImagesCount =
        BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.minimumCountOfEstateImages;
    int? minimumStreetImagesCount =
        BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.minimumCountOfStreetImages;

    if (propertyImages == null || propertyImages!.length < minimumEstateImagesCount) {
      Fluttertoast.showToast(
          msg: "يجب تحديد " + minimumEstateImagesCount.toString() + " صور للعقار على الأقل!");
      return false;
    }
    if (minimumStreetImagesCount != null) {
      if (streetPropertyImages == null ||
          streetPropertyImages!.length < minimumStreetImagesCount) {
        Fluttertoast.showToast(
            msg: "يجب تحديد " +
                minimumStreetImagesCount.toString() +
                " صور لشارع العقار على الأقل!");
        return false;
      }
    }

    return true;
  }
}
