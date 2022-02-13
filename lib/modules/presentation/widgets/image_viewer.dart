import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/utils/helpers/images_compressor.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class ImagesViewer extends StatefulWidget {
  final Function(List<File> selectedImages) onSelect;
  final bool isSingleImage;

  const ImagesViewer(
      {Key? key, required this.onSelect, this.isSingleImage = false})
      : super(key: key);

  @override
  _ImagesViewerState createState() => _ImagesViewerState();
}

class _ImagesViewerState extends State<ImagesViewer> {
  List<File> selectedImages = [];
  final ChannelCubit _showImageCubit = ChannelCubit(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Res.height(108),
          width: inf,
          decoration: BoxDecoration(
            border: Border.all(color: black),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                BlocBuilder<ChannelCubit, dynamic>(
                  bloc: _showImageCubit,
                  builder: (_, images) {
                    return ReorderableListView.builder(
                      shrinkWrap: true,
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final File item = selectedImages.removeAt(oldIndex);
                        selectedImages.insert(newIndex, item);
                        _showImageCubit.setState(
                          List.of(selectedImages),
                        );
                        widget.onSelect(selectedImages);
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: (images != null) ? images!.length : 0,
                      itemBuilder: (_, imageIndex) {
                        return Card(
                          key: UniqueKey(),
                          child: Center(
                            child: Container(
                              width: Res.width(80),
                              height: Res.width(80),
                              margin: EdgeInsets.only(
                                left: Res.width(8),
                              ),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  image: DecorationImage(
                                    image: FileImage(
                                      File(images!.elementAt(imageIndex).path),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      buildDefaultDragHandles: true,
                    );
                  },
                ),
                  InkWell(
                    key: UniqueKey(),
                    onTap: () {
                      selectImages(context,
                          isSingleImage: widget.isSingleImage);
                    },
                    child: Center(
                      child: Container(
                        width: Res.width(80),
                        height: Res.width(80),
                        margin: EdgeInsets.only(
                          left: Res.width(16),
                          right: Res.width(16),
                        ),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          boxShadow: [lowElevation],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: Res.width(36),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> selectImages(BuildContext context,
      {bool isSingleImage = false}) async {
    ImagePicker picker = ImagePicker();
    // Single image state:
    if (isSingleImage) {
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      selectedImages.clear();
      selectedImages.add(await compressFile(File(pickedImage.path)));
      _showImageCubit.setState(
        List.from(selectedImages),
      );
      widget.onSelect(selectedImages);
      return;
    }

    // Multiple images state :
    List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      for (XFile file in pickedImages) {
        selectedImages.add(await compressFile(File(file.path)));
        // selectedImages.add(File(file.path));
      }
      _showImageCubit.setState(
        List.from(selectedImages),
      );
      widget.onSelect(selectedImages);
    }
  }
}
