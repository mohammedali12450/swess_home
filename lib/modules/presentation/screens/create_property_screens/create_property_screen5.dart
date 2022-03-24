import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/system_variables.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'build_images_selectors.dart';
import 'create_property_screen6.dart';
import 'create_property_screen_finish.dart';

class CreatePropertyScreen5 extends StatefulWidget {
  static const String id = "CreatePropertyScreen5";

  final Estate currentOffer;

  const CreatePropertyScreen5({Key? key, required this.currentOffer}) : super(key: key);

  @override
  _CreatePropertyScreen5State createState() => _CreatePropertyScreen5State();
}

class _CreatePropertyScreen5State extends State<CreatePropertyScreen5> with RestorationMixin {
  List<File>? propertyImages;

  List<File>? streetPropertyImages;
  File? floorPlanPropertyImage;

  TextEditingController descriptionController = TextEditingController();

  bool isLands = false;
  bool isShops = false;

  bool isCompressing = false;

  late SystemVariables _systemVariables;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLands = widget.currentOffer.estateType.id == landsPropertyTypeNumber;
    isShops = widget.currentOffer.estateType.id == shopsPropertyTypeNumber;
    _systemVariables = BlocProvider.of<SystemVariablesBloc>(context).systemVariables!;

  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath: (isLands || isShops) ? documentOutlineIconPath : imageOutlineIconPath,
      headerText: "الخطوة الخامسة",
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLands || isShops) ...[
              kHe24,
              SizedBox(
                width: inf,
                child: ResText(
                  ":وصف العقار (اختياري)",
                  textStyle: textStyling(S.s18, W.w6, C.bl),
                  textAlign: TextAlign.right,
                ),
              ),
              kHe16,
              SizedBox(
                width: inf,
                height: Res.height(200),
                child: TextField(
                  controller: descriptionController,
                  style: textStyling(S.s15, W.w5, C.bl),
                  maxLines: 8,
                  maxLength: 600,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: "أدخل وصف إضافي لعقارك !",
                    hintStyle: textStyling(S.s15, W.w5, C.hint),
                    hintTextDirection: TextDirection.rtl,
                    border: kOutlinedBorderBlack,
                    focusedBorder: kOutlinedBorderBlack,
                  ),
                ),
              ),
            ],
            if (!isLands && !isShops)
              buildImagesSelectors(
                onPropertyImagesSelected: (images) {
                  propertyImages = (images == null || images.isEmpty)
                      ? null
                      : images.map((e) => e as File).toList();
                },
                onStreetImagesSelected: (images) {
                  streetPropertyImages = (images == null || images.isEmpty)
                      ? null
                      : images.map((e) => e as File).toList();
                },
                onFloorPlanImagesSelected: (images) {
                  floorPlanPropertyImage = (images == null || images.isEmpty) ? null : images.first;
                },
                compressStateListener: (compressState) {
                  isCompressing = compressState;
                },

                maximumCountOfEstateImages: int.parse(_systemVariables.maximumCountOfEstateImages),
                maximumCountOfStreetImages: int.parse(_systemVariables.maximumCountOfStreetImages),
                maximumCountOfFloorPlanImages:
                int.parse(_systemVariables.maximumCountOfFloorPlanImages),
                minimumCountOfEstateImages: _systemVariables.minimumCountOfEstateImages,


              ),
            kHe36,
            MyButton(
              child: ResText(
                (isLands || isShops) ? "إنشاء العرض العقاري" : "التالي",
                textStyle: textStyling(S.s16, W.w5, C.wh),
              ),
              width: Res.width(240),
              height: Res.height(56),
              color: AppColors.secondaryColor,
              onPressed: () {
                if (!isLands && !isShops) {
                  if (isCompressing) {
                    Fluttertoast.showToast(msg: "الرجاء الانتظار حتى تنتهي عملية الضغط!");
                    return;
                  }
                  if (!validateData()) return;
                  widget.currentOffer.estateImages = propertyImages!;
                  widget.currentOffer.streetImages = streetPropertyImages;
                  widget.currentOffer.floorPlanImage = floorPlanPropertyImage;
                } else {
                  widget.currentOffer.description = descriptionController.text;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => (isLands || isShops)
                        ? CreatePropertyScreenFinish(currentOffer: widget.currentOffer)
                        : CreatePropertyScreen6(currentOffer: widget.currentOffer),
                  ),
                );
              },
            ),
            kHe24,
          ],
        ),
      ),
    );
  }

  bool validateData() {
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
      if (streetPropertyImages == null || streetPropertyImages!.length < minimumStreetImagesCount) {
        Fluttertoast.showToast(
            msg: "يجب تحديد " +
                minimumStreetImagesCount.toString() +
                " صور لشارع العقار على الأقل!");
        return false;
      }
    }




    if (propertyImages!.length > int.parse(_systemVariables.maximumCountOfEstateImages)) {
      showWonderfulAlertDialog(
          context,
          "خطأ",
          "لا يمكنك اختيار أكثر من " +
              _systemVariables.maximumCountOfEstateImages +
              " صورة من صور العقار");
      return false;
    }

    if (streetPropertyImages != null &&
        streetPropertyImages!.length > int.parse(_systemVariables.maximumCountOfStreetImages)) {
      showWonderfulAlertDialog(
          context,
          "خطأ",
          "لا يمكنك اختيار أكثر من " +
              _systemVariables.maximumCountOfStreetImages +
              " صورة من صور شارع العقار");
      return false;
    }




    return true;
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => "CreatePropertyScreen5";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
  }
}
