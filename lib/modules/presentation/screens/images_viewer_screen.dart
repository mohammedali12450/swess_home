import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../constants/api_paths.dart';

class ImagesViewerScreen extends StatefulWidget {
  final List<String> images;
  final String screenTitle;
  final String videoUrl;

  const ImagesViewerScreen(this.images, this.screenTitle, this.videoUrl, {Key? key}) : super(key: key);

  @override
  _ImagesViewerScreenState createState() => _ImagesViewerScreenState();
}

class _ImagesViewerScreenState extends State<ImagesViewerScreen> {
  ChannelCubit currentImageCubit = ChannelCubit(0);
  YoutubePlayerController? _ytbPlayerController;

  // Future<void> secureScreen() async {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
  //
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        String? id = convertUrlToId(widget.videoUrl);
        id ??= "";
        _ytbPlayerController = YoutubePlayerController.fromVideoId(
          videoId: id,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.screenTitle,
          ),
          bottom: TabBar(
            indicatorColor: AppColors.yellowDarkColor,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.image),
              Tab(text: AppLocalizations.of(context)!.video),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildImageScreen(),
            buildVideoScreen(),
            //Icon(Icons.directions_car, size: 350),
          ],
        ),
      ),
    );
  }

  Widget buildImageScreen() {
    List<Image> image = [];
    for (int i = 0; i < widget.images.length; i++) {
      image.add(Image.network(imagesBaseUrl + widget.images.elementAt(i)));
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    return ListView(
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
              image.elementAt(index).image.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool synchronousCall) {
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
            return Center(
              child: Text(AppLocalizations.of(context)!.image_counting((currentImageCubit.state + 1).toString(), widget.images.length.toString()),
                  style: Theme.of(context).textTheme.titleSmall),
            );
          },
        ),
      ],
    );
  }

  Widget buildVideoScreen() {
    return convertUrlToId(widget.videoUrl) == null
        ? Container(
            alignment: Alignment.center,
            height: getScreenHeight(context),
            child: Text(AppLocalizations.of(context)!.no_video),
          )
        : AspectRatio(
            aspectRatio: 16 / 9,
            child: _ytbPlayerController != null ? YoutubePlayer(controller: _ytbPlayerController!) : const Center(child: CircularProgressIndicator()),
          );
  }

  static String? convertUrlToId(String url) {
    if (!url.contains("http") && (url.length == 11)) return url;

    for (var exp in [
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
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
