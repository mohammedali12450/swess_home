import 'package:flutter/material.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/vertical_images_viewer.dart';

Column buildImagesSelectors({
  required Function(List? images) onPropertyImagesSelected,
  required Function(List? images) onStreetImagesSelected,
  required Function(List? images) onFloorPlanImagesSelected,
  List? initialEstateImages,
  List? initialStreetImages,
  List? initialFloorImages,
}) {
  return Column(
    children: [
      kHe24,
      SizedBox(
        width: inf,
        child: ResText(
          ":صور العقار",
          textStyle: textStyling(S.s18, W.w6, C.bl),
          textAlign: TextAlign.right,
        ),
      ),
      kHe16,
      VerticalImagesViewer(
        onSelect: (selectedImages) {
          onPropertyImagesSelected(selectedImages);
        },
        images: initialEstateImages,
      ),
      kHe16,
      SizedBox(
        width: inf,
        child: ResText(
          ":صور شارع العقار ( اختياري )",
          textStyle: textStyling(S.s18, W.w6, C.bl),
          textAlign: TextAlign.right,
        ),
      ),
      kHe16,
      VerticalImagesViewer(
        onSelect: (selectedImages) {
          onStreetImagesSelected(selectedImages);
        },
        images: initialStreetImages,
      ),
      kHe16,
      SizedBox(
        width: inf,
        child: ResText(
          ":صور مخطط العقار ( اختياري )",
          textStyle: textStyling(S.s18, W.w6, C.bl),
          textAlign: TextAlign.right,
        ),
      ),
      kHe16,
      VerticalImagesViewer(
        onSelect: (selectedImages) {
          onFloorPlanImagesSelected(selectedImages);
        },
        images: initialFloorImages,
        isSingleImage: true,
      ),
    ],
  );
}
