import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/estate_office_screen.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/small_elevated_card.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'images_viewer_screen.dart';
import 'map_screen.dart';

class EstateDetailsScreen extends StatefulWidget {
  static const String id = "EstateDetailsScreen";

  final Estate estate;

  const EstateDetailsScreen({Key? key, required this.estate}) : super(key: key);

  @override
  _EstateDetailsScreenState createState() => _EstateDetailsScreenState();
}

class _EstateDetailsScreenState extends State<EstateDetailsScreen> {
  // Blocs and Cubits :
  ChannelCubit currentImageCubit = ChannelCubit(0);
  final VisitBloc _visitBloc = VisitBloc(EstateRepository());
  VisitBloc visitBloc = VisitBloc(EstateRepository());
  String? userToken;

  // Switchers :
  bool isLands = true;
  bool isShops = true;
  bool isSell = true;
  bool isHouse = true;
  bool isFarmsOrVacations = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Register estate visit :

    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      userToken = BlocProvider.of<UserLoginBloc>(context).user!.token;
    }
    _visitBloc.add(
        VisitStarted(visitId: widget.estate.id, token: userToken, visitType: VisitType.estate));
    // switchers initializing:
    isLands = widget.estate.estateType.id == landsPropertyTypeNumber;
    isShops = widget.estate.estateType.id == shopsPropertyTypeNumber;
    isSell = widget.estate.estateOfferType.id == sellOfferTypeNumber;
    isHouse = widget.estate.estateType.id == housePropertyTypeNumber;
    isFarmsOrVacations = (widget.estate.estateType.id == farmsPropertyTypeNumber) ||
        (widget.estate.estateType.id == vacationsPropertyTypeNumber);
  }

  @override
  Widget build(BuildContext context) {
    List<String> estateImages = widget.estate.images
        .where((element) => element.type == "estate_image")
        .map((e) => e.url)
        .toList();
    List<String> streetImages = widget.estate.images
        .where((element) => element.type == "street_image")
        .map((e) => e.url)
        .toList();

    List<String> nearbyPlaces = [];
    if (widget.estate.nearbyPlaces != null) {
      for (String element in widget.estate.nearbyPlaces!.split("|")) {
        nearbyPlaces.add(element);
      }
    }

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
                  Share.share('check out my website https://example.com');
                },
              ),
              const Spacer(),
              ResText(
                "تفاصيل العقار",
                textStyle: textStyling(
                  S.s17,
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
                  Navigator.pop(context);
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
                // Estate Images :
                SizedBox(
                  height: Res.height(400),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagesViewerScreen(estateImages, "صور العقار"),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions.customChild(
                              child: CachedNetworkImage(
                                imageUrl: baseUrl + estateImages.elementAt(index),
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
                          itemCount: estateImages.length,
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
                                      textStyle:
                                          textStyling(S.s12, W.w4, C.wh, fontFamily: F.roboto),
                                    ),
                                    ResText(
                                      estateImages.length.toString(),
                                      textStyle:
                                          textStyling(S.s12, W.w4, C.wh, fontFamily: F.roboto),
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
                // Estate Price and adding date :
                Container(
                  padding: kSmallSymWidth,
                  child: Row(
                    children: [
                      ResText(
                        DateHelper.getDateByFormat(
                            DateTime.parse(
                              widget.estate.createdAt.toString(),
                            ),
                            "yyyy/MM/dd"),
                        textStyle: textStyling(S.s16, W.w5, C.hint).copyWith(height: 1.8),
                      ),
                      const Spacer(),
                      if (widget.estate.estateType.id == rentOfferTypeNumber)
                        ResText(
                          widget.estate.periodType!.name.split("|").first + " /",
                          textStyle: textStyling(
                            S.s20,
                            W.w5,
                            C.bl,
                          ).copyWith(
                            height: 1.8,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ResText(
                        'ل.س',
                        textStyle: textStyling(S.s22, W.w5, C.c2).copyWith(height: 1.8),
                      ),
                      kWi8,
                      ResText(
                        NumbersHelper.getMoneyFormat(
                          int.parse(
                            widget.estate.price.toString(),
                          ),
                        ),
                        textStyle: textStyling(S.s22, W.w5, C.c2, fontFamily: F.libreFranklin),
                      ),
                      kWi4,
                    ],
                  ),
                ),
                // Estate Logo and type :
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
                        child: Container(
                          color: Colors.transparent,
                          child: ResText(
                            widget.estate.estateType.name.split('|').last +
                                ' لل' +
                                widget.estate.estateOfferType.name +
                                ' في ' +
                                widget.estate.location.getLocationName(),
                            textStyle: textStyling(S.s17, W.w6, C.c2),
                            textAlign: TextAlign.right,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Estate Description :
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
                Container(
                  padding: kMediumSymHeight,
                  width: screenWidth,
                  child: ResText(
                    widget.estate.description ?? "",
                    textStyle: textStyling(S.s16, W.w6, C.bl),
                    textAlign: TextAlign.right,
                    maxLines: 100,
                  ),
                ),
                // Estate nearby places :
                if (nearbyPlaces.isNotEmpty) ...[
                  const Divider(),
                  RowInformation(
                    title: ": الأماكن القريبة",
                    icon: Icon(
                      Icons.place_outlined,
                      size: Res.width(32),
                    ),
                    onTap: () {},
                    withBottomDivider: false,
                  ),
                  Container(
                    padding: kMediumSymHeight,
                    child: Wrap(
                      runSpacing: 5,
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: nearbyPlaces
                          .map<Widget>(
                            (place) => SmallElevatedCard(
                              content: place,
                              isRemovable: false,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  kHe16,
                  const Divider(),
                ],
                // Rent period :
                if (widget.estate.estateType.id == rentOfferTypeNumber)
                  RowInformation(
                    title: ': مدة الإيجار',
                    widgetContent: Row(
                      children: [
                        ResText(
                          widget.estate.periodType!.name.split("|").elementAt(1),
                          textStyle: textStyling(S.s18, W.w5, C.bl),
                        ),
                        kWi8,
                        ResText(
                          widget.estate.period.toString(),
                          textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(height: 1.4),
                        ),
                      ],
                    ),
                    icon: Icon(
                      Icons.access_time,
                      size: Res.width(32),
                    ),
                    onTap: () {},
                  ),
                // EstateArea :
                RowInformation(
                  title: ': المساحة',
                  widgetContent: Row(
                    children: [
                      ResText(
                        widget.estate.areaUnit.name,
                        textStyle: textStyling(S.s18, W.w5, C.bl),
                      ),
                      kWi8,
                      ResText(
                        widget.estate.area,
                        textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(height: 1.4),
                      ),
                    ],
                  ),
                  icon: SvgPicture.asset(
                    areaOutlineIconPath,
                    color: black,
                    width: Res.width(32),
                    height: Res.width(32),
                  ),
                  onTap: () {},
                ),
                // Furnished State and rooms count:
                if (!isShops && !isLands) ...[
                  RowInformation(
                    title: ': مفروش',
                    content: (widget.estate.isFurnished!) ? "نعم" : "لا",
                    icon: Icon(
                      Icons.chair_outlined,
                      size: Res.width(32),
                    ),
                    onTap: () {},
                  ),
                  if (widget.estate.roomsCount != null)
                    RowInformation(
                      title: ': عدد الغرف',
                      content: widget.estate.roomsCount,
                      icon: Icon(
                        Icons.king_bed_outlined,
                        size: Res.width(32),
                      ),
                      onTap: () {},
                    ),
                ],
                if (isHouse && widget.estate.floor != null)
                  RowInformation(
                    title: ': رقم الطابق',
                    content: widget.estate.floor,
                    icon: Icon(
                      Icons.apartment,
                      size: Res.width(32),
                    ),
                    onTap: () {},
                  ),

                // swimming pool :
                if (isFarmsOrVacations) ...[
                  if (widget.estate.hasSwimmingPool != null)
                    RowInformation(
                      title: ': مسبح',
                      content: widget.estate.hasSwimmingPool! ? "نعم" : "لا",
                      icon: Icon(
                        Icons.pool,
                        size: Res.width(32),
                      ),
                      onTap: () {},
                    ),
                  if (widget.estate.isOnBeach != null)
                    RowInformation(
                      title: ': على الشاطئ',
                      content: widget.estate.isOnBeach! ? "نعم" : "لا",
                      icon: Icon(
                        Icons.beach_access_outlined,
                        size: Res.width(32),
                      ),
                      onTap: () {},
                    ),
                ],
                // Estate ownership type :
                if (isSell)
                  RowInformation(
                    title: 'نوع  العقد : ' + widget.estate.ownershipType!.name,
                    icon: SvgPicture.asset(
                      documentOutlineIconPath,
                      color: black,
                      width: Res.width(32),
                      height: Res.width(32),
                    ),
                    onTap: () {},
                  ),
                // Estate interior status :
                if (!isLands)
                  RowInformation(
                    title: 'حالة العقار : ' + widget.estate.interiorStatus!.name,
                    icon: Icon(
                      Icons.foundation,
                      size: Res.width(32),
                    ),
                    onTap: () {},
                  ),
                // Estate street images:
                if (streetImages.isNotEmpty)
                  RowInformation(
                    title: 'شارع العقار',
                    icon: SvgPicture.asset(
                      streetIconPath,
                      color: black,
                      width: Res.width(28),
                      height: Res.width(28),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagesViewerScreen(streetImages, "صور شارع العقار"),
                        ),
                      );
                    },
                  ),
                if (widget.estate.floorPlanImage != null)
                  RowInformation(
                    title: 'مخطط العقار',
                    icon: Icon(
                      Icons.account_tree_outlined,
                      size: Res.width(32),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagesViewerScreen(
                              [widget.estate.floorPlanImage], "صورة مخطط العقار"),
                        ),
                      );
                    },
                  ),
                // Estate Position :
                if (widget.estate.longitude != null && widget.estate.latitude != null)
                  RowInformation(
                    title: 'موقع العقار على الخريطة',
                    icon: const Icon(
                      Icons.location_on_outlined,
                      size: 32,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapSample(
                            initialMarkers: [
                              Marker(
                                markerId: const MarkerId("1"),
                                position: LatLng(
                                  double.parse(widget.estate.latitude!),
                                  double.parse(widget.estate.longitude!),
                                ),
                              )
                            ],
                            isView: true,
                          ),
                        ),
                      );
                    },
                  ),
                kHe24,
                InkWell(
                  child: Column(
                    children: [
                      SizedBox(
                        width: Res.width(120),
                        height: Res.height(120),
                        child: CachedNetworkImage(
                            imageUrl: baseUrl + widget.estate.estateOffice!.logo!),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EstateOfficeScreen(widget.estate.estateOffice!),
                            ),
                          );
                        },
                        child: ResText(
                          "صفحة المكتب",
                          textStyle: textStyling(S.s14, W.w6, C.bl, fontFamily: F.cairo)
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
                              textStyle: textStyling(S.s18, W.w6, C.wh).copyWith(height: 1.8),
                            ),
                          ],
                        ),
                        color: secondaryColor,
                        borderRadius: 12,
                        width: Res.width(250),
                        onPressed: () {
                          visitBloc.add(
                            VisitStarted(
                                visitId: widget.estate.id,
                                token: userToken,
                                visitType: VisitType.estateCall),
                          );
                          launch("tel://" + widget.estate.estateOffice!.mobile.toString());
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

  final Widget? widgetContent;

  final Widget icon;

  final bool withBottomDivider;

  const RowInformation({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.widgetContent,
    this.withBottomDivider = true,
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
                (widgetContent != null)
                    ? widgetContent!
                    : ResText(
                        content ?? "",
                        textStyle: textStyling(S.s18, W.w5, C.bl),
                      ),
                kWi8,
                ResText(
                  title,
                  textStyle: textStyling(S.s18, W.w6, C.bl).copyWith(height: 1.8),
                  textAlign: TextAlign.right,
                ),
                kWi16,
                SizedBox(
                  width: Res.width(32),
                  height: Res.width(32),
                  child: Center(child: icon),
                ),
              ],
            ),
          ),
        ),
        if (withBottomDivider) const Divider(),
      ],
    );
  }
}
