import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/images_compressor.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'my_button.dart';
import 'wonderful_alert_dialog.dart';

// ignore: must_be_immutable
class VerticalImagesViewer extends StatefulWidget {
  List? images; // url or file .
  final bool isSingleImage;
  final Function(List? images) onSelect;

  VerticalImagesViewer({
    Key? key,
    required this.onSelect,
    this.isSingleImage = false,
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
      width: screenWidth,
      padding: kMediumSymHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: black.withOpacity(0.32),
        ),
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
                  ? Padding(
                      padding: EdgeInsets.only(bottom: Res.height(12)),
                      child: ReorderableWrap(
                        runSpacing: Res.height(8),
                        runAlignment: WrapAlignment.start,
                        alignment: WrapAlignment.start,
                        onReorder: _onReorder,
                        children: images
                            .map((image) => _buildImageCard(image, images.indexOf(image) + 1))
                            .toList(),
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
      builder: (_, bosConstrains) {
        return Stack(
          children: [
            Container(
              height: bosConstrains.maxWidth / 2.2,
              width: bosConstrains.maxWidth / 2.2,
              margin: EdgeInsets.symmetric(horizontal: Res.width(4)),
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
                  style: textStyling(S.s50, W.w6, C.wh, fontFamily: F.roboto)
                      .copyWith(color: white.withOpacity(0.56), fontSize: 75),
                ),
              ),
            ),
            Positioned(
                right: 8,
                top: 4,
                child: Container(
                  decoration: const BoxDecoration(
                      color: white, borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.close,
                      color: secondaryColor,
                      size: 16,
                    ),
                    onPressed: () async {
                      await showWonderfulAlertDialog(context, "تأكيد", "هل تريد حذف هذه الصورة؟",
                          removeDefaultButton: true,
                          dialogButtons: [
                            MyButton(
                              color: secondaryColor,
                              width: Res.width(120),
                              child: ResText(
                                "لا",
                                textStyle: textStyling(S.s16, W.w5, C.wh),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            MyButton(
                              color: secondaryColor,
                              width: Res.width(120),
                              child: ResText(
                                "نعم",
                                textStyle: textStyling(S.s16, W.w5, C.wh),
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
          margin: EdgeInsets.symmetric(horizontal: Res.width(4)),
          decoration: BoxDecoration(
              color: white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.32), offset: const Offset(-1, 2), blurRadius: 4)
              ]),
          child: InkWell(
            onTap: () {
              if(isImagesLoadingCubit.state == true)return ;
              selectImages(context, isSingleImage: widget.isSingleImage);
            },
            child: BlocBuilder<ChannelCubit, dynamic>(
              bloc: isImagesLoadingCubit,
              builder: (_, isLoading) {
                return Center(
                  child: (isLoading)
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SpinKitWave(color: secondaryColor , size: 24,),
                          kHe8 ,
                           ResText(
                            "جاري ضغط الصور",
                            textStyle: textStyling(S.s12, W.w4, C.bl),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                      : Icon(
                          Icons.add,
                          size: 48,
                          color: black.withOpacity(0.48),
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> selectImages(BuildContext context, {bool isSingleImage = false}) async {
    ImagePicker picker = ImagePicker();
    // Single image state:
    if (isSingleImage) {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      widget.images ??= [];
      widget.images!.clear();
      widget.images!.add(await compressFile(File(pickedImage.path)));
      imagesCardsCubit.setState(
        List.from(widget.images!),
      );
      widget.onSelect(widget.images);
      return;
    }

    // Multiple images state :
    List<XFile>? pickedImages = await picker.pickMultiImage();
    isImagesLoadingCubit.setState(true);
    if (pickedImages != null) {
      widget.images ??= [];
      for (XFile file in pickedImages) {
        widget.images!.add(await compressFile(File(file.path)));
        // selectedImages.add(File(file.path));
      }
      isImagesLoadingCubit.setState(false);
      imagesCardsCubit.setState(
        List.from(widget.images!),
      );
      widget.onSelect(widget.images);
    }
  }
}
