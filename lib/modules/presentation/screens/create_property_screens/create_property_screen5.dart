import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'build_images_selectors.dart';
import 'create_property_screen6.dart';
import 'create_property_screen_finish.dart';

class CreatePropertyScreen5 extends StatefulWidget {
  static const String id = "CreatePropertyScreen5";

  final Estate currentOffer;

  const CreatePropertyScreen5({Key? key, required this.currentOffer})
      : super(key: key);

  @override
  _CreatePropertyScreen5State createState() => _CreatePropertyScreen5State();
}

class _CreatePropertyScreen5State extends State<CreatePropertyScreen5>
    with RestorationMixin {
  List<File>? propertyImages;

  List<File>? streetPropertyImages;

  TextEditingController descriptionController = TextEditingController();

  File? floorPlanPropertyImages;

  bool isLands = false;
  bool isShops = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLands = widget.currentOffer.estateType!.id == landsPropertyTypeNumber;
    isShops = widget.currentOffer.estateType!.id == shopsPropertyTypeNumber ;
  }

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath:
          (isLands||isShops) ? documentOutlineIconPath : imageOutlineIconPath,
      headerText: "الخطوة الخامسة",
      body: Column(
        children: [
          if (isLands||isShops) ...[
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
                maxLength: 250,
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
                propertyImages = images;
              },
              onFloorPlanImagesSelected: (images) {
                floorPlanPropertyImages = images.first;
              },
              onStreetImagesSelected: (images) {
                streetPropertyImages = images;
              },
            ),
          kHe36,
          MyButton(
            child: ResText(
              (isLands||isShops) ? "إنشاء العرض العقاري" : "التالي",
              textStyle: textStyling(S.s16, W.w5, C.wh),
            ),
            width: Res.width(240),
            height: Res.height(56),
            color: secondaryColor,
            onPressed: () {
              if(!isLands && ! isShops){
                if(!validateData())return;
                widget.currentOffer.estateImages = propertyImages;
                widget.currentOffer.streetImages = streetPropertyImages;
                widget.currentOffer.floorPlanImage = floorPlanPropertyImages;
              }else{
                widget.currentOffer.description = descriptionController.text ;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => (isLands||isShops)
                      ? CreatePropertyScreenFinish(
                          currentOffer: widget.currentOffer)
                      : CreatePropertyScreen6(
                          currentOffer: widget.currentOffer),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool validateData(){
    bool isValidate = true;
    if (propertyImages == null) {
      Fluttertoast.showToast(msg: "يجب تحديد خمس صور للعقار على الأقل");
      return false ;
    }
    if (propertyImages!.length < 5) {
      Fluttertoast.showToast(msg: "يجب تحديد خمس صور للعقار على الأقل");
      isValidate = false;
    }
    return isValidate;
  }


  @override
  // TODO: implement restorationId
  String? get restorationId => "CreatePropertyScreen5";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
  }
}
