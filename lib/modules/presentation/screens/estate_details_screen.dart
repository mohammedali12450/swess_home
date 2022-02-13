import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class EstateDetailsScreen extends StatefulWidget {
  static const String id = "EstateDetailsScreen";

  final Estate estate;

  const EstateDetailsScreen({Key? key, required this.estate}) : super(key: key);

  @override
  _EstateDetailsScreenState createState() => _EstateDetailsScreenState();
}

class _EstateDetailsScreenState extends State<EstateDetailsScreen> {
  ChannelCubit currentImageCubit = ChannelCubit(0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          toolbarHeight: Res.height(75),
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.share,
                  color: white,
                ),
                onPressed: () {
                  // TODO : Process this state
                },
              ),
              const Spacer(),
              ResText(
                "تفاصيل العقار",
                textStyle: textStyling(
                  S.s20,
                  W.w5,
                  C.wh,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Res.width(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: white,
                ),
                onPressed: () {
                  //TODO process this state
                },
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Res.height(400),
                  child: InkWell(
                    onTap: () {},
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
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
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: kSmallSymWidth,
                  child: Row(
                    children: [
                      ResText(
                        DateHelper.getDateByFormat(
                            DateTime.parse(
                                widget.estate.publishedAt.toString()),
                            "yyyy/MM/dd"),
                        textStyle: textStyling(S.s16, W.w5, C.hint)
                            .copyWith(height: 1.8),
                      ),
                      const Spacer(),
                      ResText(
                        'ل.س',
                        textStyle: textStyling(S.s22, W.w5, C.c2)
                            .copyWith(height: 1.8),
                      ),
                      kWi4,
                      ResText(
                        NumbersHelper.getMoneyFormat(
                          int.parse(
                            widget.estate.price.toString(),
                          ),
                        ),
                        textStyle: textStyling(S.s22, W.w5, C.c2,
                            fontFamily: F.libreFranklin),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: Res.height(100),
                  padding: kSmallSymWidth,
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
                                widget.estate.estateType!.name.split('|').last +
                                    ' لل' +
                                    widget.estate.estateOfferType!.name +
                                    ' في ' +
                                    widget.estate.location!.getLocationName(),
                                textStyle: textStyling(S.s16, W.w6, C.c2),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: Res.height(32),
                  width: screenWidth,
                  color: secondaryColor,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: Res.width(8)),
                  child: ResText(
                    ":التفاصيل",
                    textStyle: textStyling(S.s14, W.w4, C.wh),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: inf,
                  child: ResText(
                    widget.estate.description ?? "",
                    textStyle: textStyling(S.s16, W.w6, C.bl),
                    textAlign: TextAlign.right,
                  ),
                ),
                kHe16 ,
                RowInformation(
                  title: ': المساحة',
                  content: widget.estate.area,
                  icon: SvgPicture.asset(
                    areaOutlineIconPath,
                    color: black,
                    width: 32,
                    height: 32,
                  ),
                  onTap: () {},
                ),
                RowInformation(
                  title: ': مفروش',
                  content: (widget.estate.isFurnished!) ? "نعم" : "لا",
                  icon: const Icon(
                    Icons.chair_outlined,
                    size: 32,
                  ),
                  onTap: () {},
                ),
                RowInformation(
                  title: 'شارع العقار',
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: SvgPicture.asset(
                      streetIconPath,
                      color: black,
                      width: 32,
                      height: 32,
                    ),
                  ),
                  onTap: () {},
                ),
                RowInformation(
                  title: 'صور العقار',
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    size: 32,
                  ),
                  onTap: () {},
                ),
                RowInformation(
                  title: 'موقع العقار على الخريطة',
                  icon: const Icon(
                    Icons.location_on_outlined,
                    size: 32,
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Column(
                    children: [
                      SizedBox(
                        width: Res.width(120),
                        height: Res.height(120),
                        child: CachedNetworkImage(
                            imageUrl:
                                baseUrl + widget.estate.estateOffice!.logo!),
                      ),
                      kHe8,
                      ResText(
                        widget.estate.estateOffice!.name!,
                        textStyle: textStyling(S.s24, W.w6, C.bl),
                        textAlign: TextAlign.center,
                      ),
                      kHe12,
                      ResText(
                        widget.estate.estateOffice!.location!.getLocationName(),
                        textStyle: textStyling(S.s18, W.w5, C.bl),
                        textAlign: TextAlign.center,
                      ),
                      kHe8,
                      InkWell(
                        onTap: () {
                          // TODO : Process this state :
                        },
                        child: ResText(
                          "صفحة المكتب",
                          textStyle: textStyling(S.s14, W.w6, C.bl,
                                  fontFamily: F.cairo)
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      kHe24,
                      MyButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.call,
                              color: white,
                            ),
                            kWi12,
                            ResText(
                              "اتصال",
                              textStyle: textStyling(S.s18, W.w6, C.wh)
                                  .copyWith(height: 1.8),
                            ),
                          ],
                        ),
                        color: secondaryColor,
                        borderRadius: 12,
                        width: Res.width(250),
                        onPressed: () {
                          launch("tel://" +
                              widget.estate.estateOffice!.mobile.toString());
                        },
                      ),
                      kHe24,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowInformation extends StatelessWidget {
  final Function() onTap;

  final String title;

  final String? content;

  final Widget icon;

  const RowInformation({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: kMediumSymWidth,
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ResText(
                  content ?? "",
                  textStyle: textStyling(S.s18, W.w5, C.bl),
                ),
                kWi8,
                ResText(
                  title,
                  textStyle:
                      textStyling(S.s18, W.w6, C.bl).copyWith(height: 1.8),
                ),
                kWi16,
                icon,
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
