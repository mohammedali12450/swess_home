import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/interior_status.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/models/system_variables.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/build_images_selectors.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_screen5.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/image_count_validate.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/row_information_switcher.dart';


class CreatePropertyScreen4 extends StatefulWidget {
  static const String id = "CreatePropertyScreen4";

  final Estate currentOffer;

  const CreatePropertyScreen4({Key? key, required this.currentOffer}) : super(key: key);

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

  List<File>? floorPlanPropertyImages;

  bool isCompressing = false;

  late SystemVariables _systemVariables;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializing :
    int estateTypeId = widget.currentOffer.estateType.id;
    isLands = (estateTypeId == landsPropertyTypeNumber);
    isShops = (estateTypeId == shopsPropertyTypeNumber);
    isHouse = (estateTypeId == housePropertyTypeNumber);
    isFarmsOrVacations =
        (estateTypeId == farmsPropertyTypeNumber) || (estateTypeId == vacationsPropertyTypeNumber);
    isSell = widget.currentOffer.estateOfferType.id == sellOfferTypeNumber;
    ownershipTypes = BlocProvider.of<OwnershipTypeBloc>(context).ownershipTypes!;
    interiorStatuses = BlocProvider.of<InteriorStatusesBloc>(context).interiorStatuses!;

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

    _systemVariables = BlocProvider.of<SystemVariablesBloc>(context).systemVariables!;
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

    return CreatePropertyTemplate(
      headerIconPath: (isLands || isShops) ? imageOutlineIconPath : chairOutlineIconPath,
      headerText: AppLocalizations.of(context)!.step_4,
      body: (isLands || isShops)
          ? SingleChildScrollView(
        child: Column(
          children: [
            buildImagesSelectors(
              onPropertyImagesSelected: (images) {
                propertyImages =
                (images == null) ? null : images.map((e) => e as File).toList();
              },
              onStreetImagesSelected: (images) {
                streetPropertyImages =
                (images == null) ? null : images.map((e) => e as File).toList();
              },
              onFloorPlanImagesSelected: (images) {
                floorPlanPropertyImages =
                (images == null) ? null : images.map((e) => e as File).toList();
              },
              compressStateListener: (compressState) {
                isCompressing = compressState;
              },
              maximumCountOfEstateImages:
              int.parse(_systemVariables.maximumCountOfEstateImages),
              maximumCountOfStreetImages:
              int.parse(_systemVariables.maximumCountOfStreetImages),
              maximumCountOfFloorPlanImages:
              int.parse(_systemVariables.maximumCountOfFloorPlanImages),
              minimumCountOfEstateImages: _systemVariables.minimumCountOfEstateImages,
            ),
            32.verticalSpace,
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(240.w, 64.h)),
              child: Text(
                AppLocalizations.of(context)!.next,
              ),
              onPressed: () {
                if (isCompressing) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.wait_compress_message);
                  return;
                }
                if (!landsAndShopsValidateDate()) return;
                widget.currentOffer.estateImages = propertyImages!;
                widget.currentOffer.streetImages = streetPropertyImages;
                widget.currentOffer.floorPlanImages = floorPlanPropertyImages;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePropertyScreen5(currentOffer: widget.currentOffer),
                  ),
                );
              },
            ),
          ],
        ),
      )
          : Column(
        children: [
          if (isSell & isHouse) ...[
            24.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.ownership_type + " :",
              ),
            ),
            16.verticalSpace,
            MyDropdownList(
              elementsList: ownershipTypes.map((e) => e.getName(isArabic)).toList(),
              onSelect: (index) {
                widget.currentOffer.ownershipType = ownershipTypes.elementAt(index);
              },
            ),
          ],
          if (!isLands) ...[
            24.verticalSpace,
            SizedBox(
              width: 1.sw,
              child: Text(
                AppLocalizations.of(context)!.interior_status + " :",
              ),
            ),
            16.verticalSpace,
            MyDropdownList(
              elementsList: interiorStatuses.map((e) => e.getName(isArabic)).toList(),
              onSelect: (index) {
                widget.currentOffer.interiorStatus = interiorStatuses.elementAt(index);
              },
            ),
          ],
          32.verticalSpace,
          if (!isShops || !isLands)
            RowInformationSwitcher(
              content: AppLocalizations.of(context)!.is_the_estate_furnished,
              switcherContent: AppLocalizations.of(context)!.yes,
              onSelected: (isPressed) {
                widget.currentOffer.isFurnished = isPressed;
              },
            ),
          if (isFarmsOrVacations) ...[
            28.verticalSpace,
            RowInformationSwitcher(
              content: AppLocalizations.of(context)!.is_the_estate_on_beach,
              switcherContent: AppLocalizations.of(context)!.yes,
              onSelected: (isPressed) {
                widget.currentOffer.isOnBeach = isPressed;
              },
            ),
            28.verticalSpace,
            RowInformationSwitcher(
              content: AppLocalizations.of(context)!.is_the_estate_has_pool,
              switcherContent: AppLocalizations.of(context)!.yes,
              onSelected: (isPressed) {
                widget.currentOffer.hasSwimmingPool = isPressed;
              },
            ),
          ],
          36.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: Size(240.w, 64.h)),
            child: Text(
              AppLocalizations.of(context)!.next,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePropertyScreen5(currentOffer: widget.currentOffer),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool landsAndShopsValidateDate() {
    if (!isImagesCountValidate(
      context,
      propertyImages == null ? 0 : propertyImages!.length,
      streetPropertyImages == null ? 0 : streetPropertyImages!.length,
      floorPlanPropertyImages == null ? 0 : floorPlanPropertyImages!.length,
    )) {
      return false;
    }
    return true;
  }
}
