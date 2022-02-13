import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/screens/estate_details_screen.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class EstateCard extends StatefulWidget {
  final Estate estate;

  const EstateCard({Key? key, required this.estate}) : super(key: key);

  @override
  _EstateCardState createState() => _EstateCardState();
}

class _EstateCardState extends State<EstateCard> {
  ChannelCubit currentImageCubit = ChannelCubit(0);
  ChannelCubit likeCubit = ChannelCubit(false);
  ChannelCubit saveCubit = ChannelCubit(false);

  @override
  Widget build(BuildContext context) {
    int intPrice = int.parse(widget.estate.price!);
    String estatePrice = NumbersHelper.getMoneyFormat(intPrice);
    String specialWord = (widget.estate.estateType!.id == 1 ||
            widget.estate.estateType!.id == 2 ||
            widget.estate.estateType!.id == 5)
        ? " مميز"
        : " مميزة";
    String estateType = widget.estate.estateType!.name.split('|').elementAt(1) +
        ((widget.estate.contractId! == 4) ? specialWord : "");
    String addingDate = DateHelper.getDateByFormat(
        DateTime.parse(widget.estate.publishedAt!), "yyyy/mm/dd");
    Color estateTypeBackgroundColor = Colors.white;
    Color estatePriceBackgroundColor = Colors.white;
    Color estateTypeColor = Colors.white;
    Color estatePriceColor = Colors.white;
    switch (widget.estate.contractId!) {
      case 1:
        {
          estateTypeBackgroundColor = baseColor;
          estatePriceBackgroundColor = baseColor.withAlpha(120);
          estateTypeColor = black;
          estatePriceColor = black;
          break;
        }
      case 2:
        {
          estateTypeBackgroundColor = baseColor;
          estatePriceBackgroundColor = baseColor.withAlpha(80);
          estateTypeColor = black;
          estatePriceColor = black;
          break;
        }
      case 3:
        {
          estateTypeBackgroundColor = lastColor;
          estatePriceBackgroundColor = lastColor.withAlpha(220);
          estateTypeColor = white;
          estatePriceColor = white;
          break;
        }
      case 4:
        {
          estateTypeBackgroundColor = secondaryColor;
          estatePriceBackgroundColor = secondaryColor.withAlpha(220);
          estateTypeColor = white;
          estatePriceColor = white;
          break;
        }
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Res.height(8),
      ),
      width: screenWidth,
      decoration: BoxDecoration(
        color: white,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
              color: black.withOpacity(0.32),
              offset: const Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 2)
        ],
        gradient: LinearGradient(colors: [
          (widget.estate.contractId == 4) ? Colors.yellow[200]! : Colors.white,
          white,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EstateDetailsScreen(estate: widget.estate),
                ),
              );
            },
            child: Column(
              children: [
                // Estate images :
                SizedBox(
                  height: Res.height(300),
                  child: Stack(
                    children: [
                      PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions.customChild(
                            child: CachedNetworkImage(
                              imageUrl: baseUrl +
                                  widget.estate.images!.elementAt(index).url,
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                            disableGestures: true,
                          );
                        },
                        itemCount: widget.estate.images!.length,
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
                          color: Colors.white24,
                        ),
                      ),
                      BlocBuilder<ChannelCubit, dynamic>(
                        bloc: currentImageCubit,
                        builder: (_, currentImageIndex) {
                          return Positioned(
                            top: Res.height(4),
                            left: Res.width(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: black.withOpacity(0.64),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20,
                                    color: white,
                                  ),
                                  kWi4,
                                  ResText(
                                    (currentImageIndex + 1).toString() + '/',
                                    textStyle: textStyling(S.s12, W.w4, C.wh,
                                        fontFamily: F.roboto),
                                  ),
                                  ResText(
                                    widget.estate.images!.length.toString(),
                                    textStyle: textStyling(S.s12, W.w4, C.wh,
                                        fontFamily: F.roboto),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: Res.height(4),
                        right: Res.width(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: black.withOpacity(0.64),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(2),
                            ),
                          ),
                          child: IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                              color: white,
                            ),
                            onPressed: () {
                              // TODO : Process this state
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Estate price and type :
                SizedBox(
                  height: Res.height(100),
                  child: Row(
                    children: [
                      // type :
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: estateTypeBackgroundColor,
                          padding: kSmallAllPadding,
                          child: Center(
                            child: ResText(
                              estateType,
                              textStyle: textStyling(S.s18, W.w5, C.bl)
                                  .copyWith(
                                      color: estateTypeColor, height: 1.8),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ),
                      // price
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: inf,
                          color: estatePriceBackgroundColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  right: Res.width(12),
                                ),
                                child: ResText(
                                  'ل.س',
                                  textStyle: textStyling(
                                    S.s20,
                                    W.w5,
                                    C.bl,
                                  ).copyWith(
                                      height: 1.8, color: estatePriceColor),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  right: Res.width(12),
                                ),
                                child: ResText(
                                  estatePrice,
                                  textStyle: textStyling(S.s22, W.w4, C.bl,
                                          fontFamily: F.libreFranklin)
                                      .copyWith(color: estatePriceColor),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Estate address and office logo
                Container(
                  height: Res.height(100),
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: Res.height(75),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                baseUrl + widget.estate.estateOffice!.logo!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: ResText(
                                widget.estate.location!.getLocationName(),
                                textStyle: textStyling(S.s20, W.w6, C.c2),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            kHe12,
                            ResText(
                              "تاريخ الإضافة: " + addingDate,
                              textStyle: textStyling(S.s18, W.w6, C.bl),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      kWi8
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: saveCubit,
                builder: (_, isSaved) {
                  return IconButton(
                    onPressed: () {
                      saveCubit.setState(!isSaved);
                    },
                    icon: (isSaved)
                        ? const Icon(
                            Icons.bookmark,
                            color: secondaryColor,
                          )
                        : const Icon(Icons.bookmark_border_outlined),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  launch(
                    "tel://" + widget.estate.estateOffice!.mobile.toString(),
                  );
                },
                icon: const Icon(Icons.call),
              ),
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: likeCubit,
                builder: (_, isLiked) {
                  return IconButton(
                    onPressed: () {
                      likeCubit.setState(!isLiked);
                    },
                    icon: (isLiked)
                        ? const Icon(
                            Icons.favorite,
                            color: secondaryColor,
                          )
                        : const Icon(Icons.favorite_border),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
