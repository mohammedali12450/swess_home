import 'dart:io';
import 'package:flutter/material.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/widgets/image_viewer.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';

Column buildImagesSelectors({
  required Function(List<File>) onPropertyImagesSelected,
  required Function(List<File>) onStreetImagesSelected,
  required Function(List<File>) onFloorPlanImagesSelected,
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
      ImagesViewer(
        onSelect: (selectedImages) {
          onPropertyImagesSelected(selectedImages);
        },
      ),
      kHe16,
      SizedBox(
        width: inf,
        child: ResText(
          ":صور شارع العقار (اختياري)",
          textStyle: textStyling(S.s18, W.w6, C.bl),
          textAlign: TextAlign.right,
        ),
      ),
      kHe16,
      ImagesViewer(
        onSelect: (selectedImages) {
          onStreetImagesSelected(selectedImages);
        },
      ),
      kHe16,
      SizedBox(
        width: inf,
        child: ResText(
          ":صور مخطط العقار (اختياري)",
          textStyle: textStyling(S.s18, W.w6, C.bl),
          textAlign: TextAlign.right,
        ),
      ),
      kHe16,
      ImagesViewer(
        onSelect: (selectedImages) {
          onFloorPlanImagesSelected(selectedImages);
        },
        isSingleImage: true ,
      ),
    ],
  );
}
