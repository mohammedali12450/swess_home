import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class ImagesViewerScreen extends StatefulWidget {
  final List<String> images;
  final String screenTitle;

  const ImagesViewerScreen(this.images, this.screenTitle, {Key? key}) : super(key: key);

  @override
  _ImagesViewerScreenState createState() => _ImagesViewerScreenState();
}

class _ImagesViewerScreenState extends State<ImagesViewerScreen> {
  ChannelCubit currentImageCubit = ChannelCubit(0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ResText(
                widget.screenTitle,
                textStyle: textStyling(S.s16, W.w5, C.wh),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          automaticallyImplyLeading: true,
          leading: Container(),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: Res.width(24),
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_forward)),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth,
              height: Res.height(600),
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions.customChild(
                    maxScale: 3.0,
                    minScale: 1.0,
                    child: CachedNetworkImage(
                      imageUrl: baseUrl + widget.images.elementAt(index),
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (_, __, ___) {
                        return Container(
                          color: white,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: secondaryColor.withOpacity(0.6),
                            size: 120,
                          ),
                        );
                      },
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 64,
                  ),
                ),
                pageController: PageController(),
                onPageChanged: (newIndex) {
                  currentImageCubit.setState(newIndex);
                },
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            kHe12,
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: currentImageCubit,
              builder: (_, currentImage) {
                return ResText(
                  "الصورة " +
                      (currentImageCubit.state + 1).toString() +
                      " من " +
                      widget.images.length.toString(),
                  textStyle: textStyling(S.s12, W.w5, C.wh),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
