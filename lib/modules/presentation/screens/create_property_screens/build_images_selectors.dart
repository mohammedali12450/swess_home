import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/widgets/vertical_images_viewer.dart';

Builder buildImagesSelectors({
  required Function(List? images) onPropertyImagesSelected,
  required Function(List? images) onStreetImagesSelected,
  required Function(List? images) onFloorPlanImagesSelected,
  List? initialEstateImages,
  List? initialStreetImages,
  List? initialFloorImages,
  Function(bool isCompressing)? compressStateListener,
  int? maximumCountOfEstateImages,
  int? maximumCountOfStreetImages,
  int? maximumCountOfFloorPlanImages,
  int? minimumCountOfEstateImages,
}) {
  bool isCompressing = false;

  return Builder(
    builder: (context) => Column(
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.property_images + " :",
            ),
            const Spacer(),
            if (maximumCountOfEstateImages != null && minimumCountOfEstateImages != null)
              Text(
                AppLocalizations.of(context)!.range_count_of_images(
                  minimumCountOfEstateImages.toString(),
                  maximumCountOfEstateImages.toString(),
                ),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            8.horizontalSpace,
          ],
        ),
        16.verticalSpace,
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
        16.verticalSpace,
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.property_street_images +
                  " ( ${AppLocalizations.of(context)!.optional} ) :",
            ),
            const Spacer(),
            if (maximumCountOfStreetImages != null)
              Text(
                AppLocalizations.of(context)!.min_count_of_images(
                  maximumCountOfStreetImages.toString(),
                ),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            8.horizontalSpace,
          ],
        ),
        16.verticalSpace,
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
        16.verticalSpace,
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.floor_plan_property_images +
                  " ( ${AppLocalizations.of(context)!.optional} ) :",
            ),
            const Spacer(),
            if (maximumCountOfFloorPlanImages != null)
              Text(
                AppLocalizations.of(context)!
                    .max_count_of_images(maximumCountOfFloorPlanImages.toString()),
                style: Theme.of(context).textTheme.subtitle2,
                maxLines: 2,
              ),
            8.horizontalSpace,
          ],
        ),
        16.verticalSpace,
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
        ),
      ],
    ),
  );
}
