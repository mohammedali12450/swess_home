import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/images_compressor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class VerticalImagesViewer extends StatefulWidget {
  List? images; // url or file .
  final Function(List? images) onSelect;
  final bool Function()? onStartPicking;

  VerticalImagesViewer({
    Key? key,
    required this.onSelect,
    this.onStartPicking,
    this.images,
  }) : super(key: key);

  @override
  _VerticalImagesViewerState createState() => _VerticalImagesViewerState();
}

class _VerticalImagesViewerState extends State<VerticalImagesViewer> {
  late ChannelCubit imagesCardsCubit;
  late ChannelCubit isImagesLoadingCubit = ChannelCubit(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagesCardsCubit = ChannelCubit(widget.images);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onBackground),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: BlocBuilder<ChannelCubit, dynamic>(
        bloc: imagesCardsCubit,
        builder: (_, images) {
          images = images as List?;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (images != null && images.isNotEmpty)
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: ReorderableWrap(
                          runSpacing: 8.h,
                          runAlignment: WrapAlignment.start,
                          alignment: WrapAlignment.start,
                          onReorder: _onReorder,
                          children: images
                              .map(
                                (image) => _buildImageCard(image, images.indexOf(image) + 1),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  : Container(),
              addCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageCard(dynamic image, int index) {
    ImageProvider imageProvider = const NetworkImage("");
    if (image is String) {
      imageProvider = CachedNetworkImageProvider(image);
    } else if (image is File) {
      imageProvider = FileImage(File(image.path));
    }
    return LayoutBuilder(
      key: UniqueKey(),
      builder: (_, boxConstrains) {
        return Stack(
          children: [
            Container(
              height: boxConstrains.maxWidth / 2.2,
              width: boxConstrains.maxWidth / 2.2,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  index.toString(),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: AppColors.white.withOpacity(0.64), fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Positioned(
                right: 8.w,
                top: 4.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          offset: const Offset(1, 0),
                          spreadRadius: 1,
                          blurRadius: 4),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                    ),
                    onPressed: () async {
                      await showWonderfulAlertDialog(
                          context,
                          AppLocalizations.of(context)!.confirmation,
                          AppLocalizations.of(context)!.delete_image_confirmation,
                          removeDefaultButton: true,
                          dialogButtons: [
                            ElevatedButton(
                              child: Text(
                                AppLocalizations.of(context)!.no,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: Text(
                                AppLocalizations.of(context)!.yes,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                widget.images!.removeAt(index - 1);
                                widget.onSelect(widget.images!);
                                imagesCardsCubit.setState(List.from(widget.images!));
                                Navigator.pop(context);
                              },
                            ),
                          ]);
                    },
                  ),
                ))
          ],
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    dynamic image = widget.images!.removeAt(oldIndex);
    widget.images!.insert(newIndex, image);
    imagesCardsCubit.setState(List.from(widget.images!));
    widget.onSelect(widget.images);
  }

  Widget addCard() {
    return LayoutBuilder(
      key: UniqueKey(),
      builder: (_, bosConstrains) {
        return Container(
          height: bosConstrains.maxWidth / 3.5,
          width: bosConstrains.maxWidth / 3.5,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  offset: const Offset(1, 1),
                  spreadRadius: 2,
                  blurRadius: 3),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (isImagesLoadingCubit.state == true) return;
              if (widget.onStartPicking != null && !widget.onStartPicking!()) {
                Fluttertoast.showToast(msg: AppLocalizations.of(context)!.wait_compress_message);
                return;
              }
              selectImages(context);
            },
            child: BlocBuilder<ChannelCubit, dynamic>(
              bloc: isImagesLoadingCubit,
              builder: (_, isLoading) {
                return Center(
                  child: (isLoading)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitWave(
                              color: Theme.of(context).colorScheme.onBackground,
                              size: 24.w,
                            ),
                            8.verticalSpace,
                            Text(
                              AppLocalizations.of(context)!.compressing_images,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 13.sp),
                            ),
                          ],
                        )
                      : const Icon(
                          Icons.add,
                          size: 48,
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> selectImages(BuildContext context) async {
    ImagePicker picker = ImagePicker();
    // Multiple images state :
    List<XFile>? pickedImages = await picker.pickMultiImage();
    isImagesLoadingCubit.setState(true);
    if (pickedImages != null) {
      widget.images ??= [];
      for (XFile file in pickedImages) {
        File temp = await compressFile(File(file.path));
        widget.images!.add(temp);
        // selectedImages.add(File(file.path));
      }
      imagesCardsCubit.setState(
        List.from(widget.images!),
      );
    }
    isImagesLoadingCubit.setState(false);
    widget.onSelect(widget.images);
  }
}
