import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';

import '../../../constants/api_paths.dart';

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
              width: 1.sw,
              height: 1.sw,
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
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                backgroundDecoration:  BoxDecoration(
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
                      (currentImageCubit.state + 1).toString(), widget.images.length.toString()),
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: AppColors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
