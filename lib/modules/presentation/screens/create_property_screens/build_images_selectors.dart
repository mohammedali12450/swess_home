import 'package:flutter/material.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/vertical_images_viewer.dart';

Column buildImagesSelectors({
  required Function(List? images) onPropertyImagesSelected,
  required Function(List? images) onStreetImagesSelected,
  required Function(List? images) onFloorPlanImagesSelected,
  Function(bool isCompressing)? compressStateListener,
  List? initialEstateImages,
  List? initialStreetImages,
  List? initialFloorImages,
  int? maximumCountOfEstateImages ,
  int? maximumCountOfStreetImages ,
  int? maximumCountOfFloorPlanImages ,
  int? minimumCountOfEstateImages ,
}) {

  bool isCompressing = false;

  return Column(
    children: [
      kHe24,
      Row(
        children: [
          kWi8 ,
          if(maximumCountOfEstateImages!=null && minimumCountOfEstateImages!=null)
            ResText(
              "( من " + minimumCountOfEstateImages.toString() + " إلى " +maximumCountOfEstateImages.toString() + " صور )",
              textStyle: textStyling(S.s16, W.w5, C.hint),
              textAlign: TextAlign.left,
            ),
          const Spacer() ,
          ResText(
            ":صور العقار",
            textStyle: textStyling(S.s18, W.w6, C.bl),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      kHe16,
      VerticalImagesViewer(
        onStartPicking: () {
          if (isCompressing) return false;
          isCompressing = true;
          if (compressStateListener != null) {
            compressStateListener(isCompressing);
          }
          return true;
        },
        onSelect: (selectedImages) {
          onPropertyImagesSelected(selectedImages);
          isCompressing = false;
          if (compressStateListener != null) {
            compressStateListener(isCompressing);
          }
        },
        images: initialEstateImages,
      ),
      kHe16,
      Row(
        children: [
          kWi8 ,
          if(maximumCountOfStreetImages!=null)
            ResText(
              "( الحد الأعلى " + maximumCountOfStreetImages.toString() + " صور )",
              textStyle: textStyling(S.s16, W.w5, C.hint),
              textAlign: TextAlign.left,
            ),
          const Spacer() ,
          ResText(
            ":صور شارع العقار ( اختياري )",
            textStyle: textStyling(S.s18, W.w6, C.bl),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      kHe16,
      VerticalImagesViewer(
        onStartPicking: () {
          if (isCompressing) return false;
          isCompressing = true;
          if (compressStateListener != null) {
            compressStateListener(isCompressing);
          }
          return true;
        },
        onSelect: (selectedImages) {
          onStreetImagesSelected(selectedImages);
          isCompressing = false;
          if (compressStateListener != null) {
            compressStateListener(isCompressing);
          }
        },
        images: initialStreetImages,
      ),
      kHe16,
      Row(
        children: [
          kWi8 ,
          if(maximumCountOfFloorPlanImages!=null)
            ResText(
              "( الحد الأعلى " + maximumCountOfFloorPlanImages.toString() + " صور )",
              textStyle: textStyling(S.s16, W.w5, C.hint),
              textAlign: TextAlign.left,
            ),
          const Spacer() ,
          ResText(
            ":صور مخطط العقار ( اختياري )",
            textStyle: textStyling(S.s18, W.w6, C.bl),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      kHe16,
      VerticalImagesViewer(
        onStartPicking: () {
          if (isCompressing) return false;
          isCompressing = true;
          if (compressStateListener != null) {
            compressStateListener(isCompressing);
          }
          return true;
        },
        onSelect: (selectedImages) {
          onFloorPlanImagesSelected(selectedImages);
          isCompressing = false;
          if (compressStateListener != null) {
            compressStateListener(isCompressing);
          }
        },
        images: initialFloorImages,
        isSingleImage: true,
      ),
    ],
  );
}
