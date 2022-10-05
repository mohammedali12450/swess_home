import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';

import '../../../constants/api_paths.dart';

class ImagesViewerScreen extends StatefulWidget {
  final List<String> images;
  final String screenTitle;

  const ImagesViewerScreen(this.images, this.screenTitle, {Key? key})
      : super(key: key);

  @override
  _ImagesViewerScreenState createState() => _ImagesViewerScreenState();
}

class _ImagesViewerScreenState extends State<ImagesViewerScreen> {
  ChannelCubit currentImageCubit = ChannelCubit(0);

  @override
  Widget build(BuildContext context) {
    List<Image> image = [];
    for (int i = 0; i < widget.images.length; i++) {
      image.add(Image.network(imagesBaseUrl + widget.images.elementAt(i)));
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.screenTitle,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: getScreenHeight(context) - 100,
            width: getScreenWidth(context),
            child: PageView.builder(
              onPageChanged: (newIndex) {
                currentImageCubit.setState(newIndex);
              },
              itemCount: image.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                image
                    .elementAt(index)
                    .image
                    .resolve(const ImageConfiguration())
                    .addListener(ImageStreamListener(
                        (ImageInfo info, bool synchronousCall) {
                  if (!completer.isCompleted) {
                    completer.complete(info.image);
                  }
                }));
                return InteractiveViewer(
                  panEnabled: false, // Set it to false to prevent panning.
                  //boundaryMargin: const EdgeInsets.all(80),
                  minScale: 0.5,
                  maxScale: 4,
                  child: image.elementAt(index),
                );
              },
            ),
          ),
          12.verticalSpace,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: currentImageCubit,
            builder: (_, currentImage) {
              return Text(
                AppLocalizations.of(context)!.image_counting(
                    (currentImageCubit.state + 1).toString(),
                    widget.images.length.toString()),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: AppColors.black),
              );
            },
          ),
        ],
      ),
    );
  }

/*@override
  Widget build(BuildContext context) {
    CachedNetworkImage image = CachedNetworkImage(
        imageUrl: imagesBaseUrl + widget.images.elementAt(1));
    print(image.memCacheHeight);
    print(image.width);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          title: Text(
            widget.screenTitle,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: getScreenWidth(context),
              height: getScreenHeight(context) - 100,
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions.customChild(
                    maxScale: 3.0,
                    minScale: 1.0,
                    child: CachedNetworkImage(
                      imageUrl: imagesBaseUrl + widget.images.elementAt(index),
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (_, __, ___) {
                        return Icon(
                          Icons.camera_alt_outlined,
                          size: 120.w,
                        );
                      },
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 64.w,
                  ),
                ),
                pageController: PageController(),
                onPageChanged: (newIndex) {
                  currentImageCubit.setState(newIndex);
                },
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            12.verticalSpace,
            BlocBuilder<ChannelCubit, dynamic>(
              bloc: currentImageCubit,
              builder: (_, currentImage) {
                return Text(
                  AppLocalizations.of(context)!.image_counting(
                      (currentImageCubit.state + 1).toString(),
                      widget.images.length.toString()),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: AppColors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }*/
}
