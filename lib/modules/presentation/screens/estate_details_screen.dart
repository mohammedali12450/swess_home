import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/modules/business_logic_components/bloc/share_estate_bloc/share_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/estate_office_screen.dart';
import 'package:swesshome/modules/presentation/widgets/small_elevated_card.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/share_estate_bloc/share_bloc.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/cupertino_action_sheet.dart';
import '../widgets/report_estate.dart';
import '../widgets/res_text.dart';
import 'images_viewer_screen.dart';
import 'map_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  VisitBloc visitBloc = VisitBloc(EstateRepository());
  ShareBloc shareBloc = ShareBloc(EstateRepository());
  String? userToken;

  // Switchers :
  bool isLands = true;
  bool isShops = true;
  bool isSell = true;
  bool isHouse = true;
  bool isFarmsOrVacations = true;
  List<String> estateImages = [];
  List<String> streetImages = [];
  List<String> floorPlanImages = [];
  List<String> nearbyPlaces = [];

  // Others:
  late String currency;

  @override
  void initState() {
    super.initState();

    // Register estate visit :

    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      userToken = UserSharedPreferences.getAccessToken();
    }
    visitBloc.add(VisitStarted(
        visitId: widget.estate.id!,
        token: userToken,
        visitType: VisitType.estate));
    // switchers initializing:
    if(widget.estate.estateType !=null || widget.estate.estateOfferType != null) {
      isLands = widget.estate.estateType!.id == landsPropertyTypeNumber;
      isShops = widget.estate.estateType!.id == shopsPropertyTypeNumber;
      isSell = widget.estate.estateOfferType!.id == sellOfferTypeNumber;
      isHouse = widget.estate.estateType!.id == housePropertyTypeNumber;
      isFarmsOrVacations =
          (widget.estate.estateType!.id == farmsPropertyTypeNumber) ||
              (widget.estate.estateType!.id == vacationsPropertyTypeNumber);
    }
    if(widget.estate.images != null) {
      estateImages = widget.estate.images!
          .where((element) => element.type == "estate_image")
          .map((e) => e.url)
          .toList();
      streetImages = widget.estate.images!
          .where((element) => element.type == "street_image")
          .map((e) => e.url)
          .toList();
      floorPlanImages = widget.estate.images!
          .where((element) => element.type == "floor_plan")
          .map((e) => e.url)
          .toList();
    }

    if (widget.estate.nearbyPlaces != null) {
      for (String element in widget.estate.nearbyPlaces!.split("|")) {
        nearbyPlaces.add(element);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    currency = AppLocalizations.of(context)!.syrian_currency;

    int intPrice = int.parse(widget.estate.price!);
    String estatePrice = NumbersHelper.getMoneyFormat(intPrice);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.estate_details,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.share,
                color: AppColors.white,
              ),
              onPressed: () {
                Share.share('${AppLocalizations.of(context)!.estate_offers} :\n'
                    '${widget.estate.estateType == null ? "" :  widget.estate.estateType!.name.split("|")[1]} لل'
                    '${widget.estate.estateOfferType == null ? "" : widget.estate.estateOfferType!.name} '
                    ' في ${widget.estate.locationS} \n'
                    'https://www.swesshome.com/estate/${widget.estate.id} ');
                if (UserSharedPreferences.getAccessToken() != null) {
                  shareBloc.add(
                    ShareStarted(
                      estateId: widget.estate.id!,
                      token: userToken,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Estate Images :
                SizedBox(
                  height: 400.h,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagesViewerScreen(
                              estateImages,
                              AppLocalizations.of(context)!.estate_images,
                              widget.estate.videoUrl == null
                                  ? ""
                                  : widget.estate.videoUrl!),
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
                                imageUrl: imagesBaseUrl +
                                    estateImages.elementAt(index),
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (_, __, ___) {
                                  return Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.6),
                                      size: 120.w,
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
                              top: 4.h,
                              left: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                  color: AppColors.white.withOpacity(0.64),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      (currentImageIndex + 1).toString() + '/',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            fontFamily: "Hind",
                                            color: AppColors.black,
                                          ),
                                    ),
                                    Text(
                                      estateImages.length.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            fontFamily: "Hind",
                                            color: AppColors.black,
                                          ),
                                    ),
                                    4.horizontalSpace,
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 20.w,
                                      color: AppColors.black,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 4.h,
                          right: 8.w,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.64),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2),
                              ),
                            ),
                            child: IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.close,
                                size: 22.w,
                                color: AppColors.white,
                              ),
                              onPressed: () {
                                showReportModalBottomSheet(
                                    context, widget.estate.id!);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Estate Price and adding date :
                Padding(
                  padding: kTinyAllPadding,
                  child: Row(
                    children: [
                      (UserSharedPreferences.getAccessToken()  == null) ?
                      Padding(
                        padding: EdgeInsets.only(
                          right: (isArabic) ? 12.w : 0,
                          left: (!isArabic) ? 12.w : 0,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async{
                                await Navigator.pushNamed(context, AuthenticationScreen.id);
                              },
                              child: Container(
                                width: 100.w,
                                height: 30.h,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: veryLowBorderRadius,
                                ),
                                child: Center(
                                  child: ResText(
                                    AppLocalizations.of(context)!.sign_in,
                                    textAlign: TextAlign.start,
                                    textStyle: GoogleFonts.libreFranklin(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            kWi8,
                            ResText(
                              " ${AppLocalizations.of(context)!.first} ${AppLocalizations.of(context)!.get_price}",
                              textAlign: TextAlign.start,
                              textStyle: GoogleFonts.libreFranklin(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  height: 1.3.h
                              ),
                            ),
                          ],
                        ),
                      ):
                        // Row(
                        //   children: [
                        //     InkWell(
                        //       onTap: () async{
                        //         await Navigator.pushNamed(context, AuthenticationScreen.id);
                        //       },
                        //       child: ResText(
                        //         AppLocalizations.of(context)!.sign_in,
                        //         textAlign: TextAlign.start,
                        //         textStyle: GoogleFonts.libreFranklin(
                        //             color: Theme.of(context).colorScheme.primary,
                        //             fontWeight: FontWeight.w600,
                        //           decoration: TextDecoration.underline
                        //             ),
                        //       ),
                        //     ),
                        //     ResText(
                        //       " " +  AppLocalizations.of(context)!.first + " " +  AppLocalizations.of(context)!.get_price,
                        //       textAlign: TextAlign.start,
                        //       textStyle: GoogleFonts.libreFranklin(
                        //           color: Theme.of(context).colorScheme.onBackground,
                        //           fontWeight: FontWeight.w400,
                        //         fontSize: 12.sp,
                        //           height: 1.3.h
                        //       ),
                        //     ),
                        //   ],
                        // ) :
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: (isArabic) ? 4.w : 0,
                              left: (!isArabic) ? 4.w : 0,
                            ),
                            child: ResText(
                              estatePrice,
                              textAlign: TextAlign.start,
                              textStyle: GoogleFonts.libreFranklin(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5.h),
                            ),
                          ),
                         if(widget.estate.estateOfferType != null)  if (widget.estate.estateOfferType!.id !=
                             rentOfferTypeNumber)
                            Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                right: (isArabic) ? 8.w : 0,
                                left: (!isArabic) ? 8.w : 0,
                              ),
                              child: ResText(
                                currency,
                                textAlign: TextAlign.start,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      height: 1.8.h,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                          if(widget.estate.estateOfferType != null) if (widget.estate.estateOfferType!.id ==
                              rentOfferTypeNumber)
                            Padding(
                              padding: EdgeInsets.only(
                                right: (isArabic) ? 8.w : 0,
                                left: (!isArabic) ? 8.w : 0,
                              ),
                              child: ResText(
                                AppLocalizations.of(context)!
                                    .currency_over_period(
                                  currency,
                                  widget.estate.periodType != null
                                      ? widget.estate.periodType!.name
                                          .split("|")
                                          .first
                                      : "",
                                ),
                                textAlign: TextAlign.start,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      height: 1.8.h,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                          left: (isArabic) ? 8.w : 0,
                          right: (!isArabic) ? 8.w : 0,
                        ),
                        child: (widget.estate.publishedAt != null) ? ResText(
                          DateHelper.getDateByFormat(
                              DateTime.parse(
                                widget.estate.publishedAt.toString(),
                              ),
                              "yyyy/MM/dd"),
                          textAlign: TextAlign.start,
                          textStyle: Theme.of(context).textTheme.subtitle2,
                        ) : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                // Estate Logo and type :
                Container(
                  height: 100.h,
                  padding: kTinyAllPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.only(
                                left: (isArabic) ? 12.w : 0,
                                right: (!isArabic) ? 12.w : 0,
                              ),
                              child:  widget.estate.estateType == null ? const Center():
                              ResText(
                                AppLocalizations.of(context)!
                                    .estate_offer_place_sentence(
                                  widget.estate.estateType!.name.split('|').last,
                                  widget.estate.estateOfferType!.name,
                                  widget.estate.locationS!,
                                ),
                                textAlign: TextAlign.start,
                                textStyle: Theme.of(context).textTheme.bodyText1,
                                maxLines: 3,
                              ),
                            ),
                            /*if (widget.estate.visitCount != null)
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(bottom: 3.0.h),
                                        child: Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: isDark
                                              ? AppColors.lightblue
                                              : AppColors.lastColor,
                                          size: 20.w,
                                        ),
                                      ),
                                      kWi8,
                                      ResText(
                                        widget.estate.visitCount!.toString(),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                            color: isDark
                                                ? AppColors.lightblue
                                                : AppColors.lastColor,
                                            fontSize: 14.sp,
                                            height: 1.5.h),
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => ImageDialog(
                                    path: widget.estate.estateOffice == null ? "" : widget.estate.estateOffice!.logo!));
                          },
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  //height: 75.h,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: widget.estate.estateOffice == null ? const CachedNetworkImageProvider(swessHomeIconPath) :
                                      CachedNetworkImageProvider(
                                        imagesBaseUrl + widget.estate.estateOffice!.logo!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Estate Viewer
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Estate Description :
                kHe8,
                Container(
                  height: 32.h,
                  width: 1.sw,
                  alignment: AlignmentDirectional.centerStart,
                  color: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.only(
                      right: (isArabic) ? 8.w : 0, left: (!isArabic) ? 8.w : 0),
                  child: ResText(
                    "${AppLocalizations.of(context)!.estate_details} :",
                    textAlign: TextAlign.start,
                    textStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                12.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  width: 1.sw,
                  child: Text(
                    widget.estate.description ?? "",
                    textDirection: intl.Bidi.detectRtlDirectionality(
                            widget.estate.description ?? "hi")
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    maxLines: 100,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          height: 1.8.h,
                        ),
                  ),
                ),
                12.verticalSpace,
                // Estate nearby places :
                if (nearbyPlaces.isNotEmpty) ...[
                  const Divider(height: 1.5),
                  RowInformation(
                    title: "${AppLocalizations.of(context)!.nearby_places} :",
                    icon: Icon(
                      Icons.place_outlined,
                      size: 28.w,
                    ),
                    onTap: () {},
                    withBottomDivider: false,
                  ),
                  16.verticalSpace,
                  Wrap(
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
                  16.verticalSpace,
                  const Divider(),
                ],
                // Estate id :

                RowInformation(
                  title: "${AppLocalizations.of(context)!.estate_id} :",
                  content: widget.estate.id.toString(),
                  icon: SvgPicture.asset(
                    id1IconPath,
                    width: 28.w,
                    height: 28.w,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onTap: () {},
                ),
                // Rent period :
                if(widget.estate.estateOfferType != null) if (widget.estate.estateOfferType!.id == rentOfferTypeNumber)
                  RowInformation(
                    title:
                        "${AppLocalizations.of(context)!.estate_rent_period} :",
                    widgetContent: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ResText(
                            widget.estate.period.toString(),
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: 16.sp),
                          ),
                        ),
                        6.horizontalSpace,
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ResText(
                            widget.estate.periodType != null
                                ? widget.estate.periodType!.name
                                    .split("|")
                                    .elementAt(1)
                                : "",
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                    icon: Icon(
                      Icons.access_time,
                      size: 32.w,
                    ),
                    onTap: () {},
                  ),
                // EstateArea :
                RowInformation(
                  title: "${AppLocalizations.of(context)!.estate_area} :",
                  widgetContent: Row(
                    children: [
                      ResText(
                        widget.estate.area!,
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16.sp),
                      ),
                      8.horizontalSpace,
                      widget.estate.areaUnit == null ? Center() :
                      ResText(
                        widget.estate.areaUnit!.name,
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  icon: SvgPicture.asset(
                    areaOutlineIconPath,
                    width: 28.w,
                    height: 28.w,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onTap: () {},
                ),
                // Furnished State and rooms count:
                if (!isShops && !isLands) ...[
                  RowInformation(
                    title: "${AppLocalizations.of(context)!.furnished} :",
                    content: (widget.estate.isFurnished!)
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no,
                    icon: Icon(
                      Icons.chair_outlined,
                      size: 28.w,
                    ),
                    onTap: () {},
                  ),
                  if (widget.estate.roomsCount != null)
                    RowInformation(
                      title: "${AppLocalizations.of(context)!.rooms_count} :",
                      content: widget.estate.roomsCount,
                      icon: Icon(
                        Icons.king_bed_outlined,
                        size: 28.w,
                      ),
                      onTap: () {},
                    ),
                ],

                if (isHouse && widget.estate.floor != null)
                  RowInformation(
                    title: "${AppLocalizations.of(context)!.floor_number} :",
                    content: widget.estate.floor,
                    icon: Icon(
                      Icons.apartment,
                      size: 28.w,
                    ),
                    onTap: () {},
                  ),

                // swimming pool :
                if (isFarmsOrVacations) ...[
                  if (widget.estate.hasSwimmingPool != null)
                    RowInformation(
                      title: "${AppLocalizations.of(context)!.has_swimming_pool} :",
                      content: widget.estate.hasSwimmingPool!
                          ? AppLocalizations.of(context)!.yes
                          : AppLocalizations.of(context)!.no,
                      icon: Icon(
                        Icons.pool,
                        size: 28.w,
                      ),
                      onTap: () {},
                    ),
                  // if (widget.estate.isOnBeach != null)
                  //   RowInformation(
                  //     title: AppLocalizations.of(context)!.on_beach + " :",
                  //     content: widget.estate.isOnBeach!
                  //         ? AppLocalizations.of(context)!.yes
                  //         : AppLocalizations.of(context)!.no,
                  //     icon: Icon(
                  //       Icons.beach_access_outlined,
                  //       size: 32.w,
                  //     ),
                  //     onTap: () {},
                  //   ),
                ],
                // Estate ownership type :
                if (isSell)
                  RowInformation(
                    title: "${AppLocalizations.of(context)!.ownership_type} :",
                    content:  widget.estate.ownershipType == null ? "" : widget.estate.ownershipType!.name,
                    icon: SvgPicture.asset(
                      documentOutlineIconPath,
                      width: 28.w,
                      height: 28.w,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onTap: () {},
                  ),
                // Estate interior status :
                if (!isLands)
                  RowInformation(
                    title: "${AppLocalizations.of(context)!.interior_status} :",
                    content: widget.estate.interiorStatus!.name,
                    icon: Icon(
                      Icons.foundation,
                      size: 28.w,
                    ),
                    onTap: () {},
                  ),
                // Estate street images:
                if (streetImages.isNotEmpty)
                  RowInformation(
                    title: AppLocalizations.of(context)!.property_street_images,
                    icon: SvgPicture.asset(
                      streetIconPath,
                      width: 28.w,
                      height: 28.w,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagesViewerScreen(
                              streetImages,
                              AppLocalizations.of(context)!
                                  .estate_street_images,
                              widget.estate.videoUrl == null
                                  ? ""
                                  : widget.estate.videoUrl!),
                        ),
                      );
                    },
                  ),
                if (floorPlanImages.isNotEmpty)
                  RowInformation(
                    title: AppLocalizations.of(context)!
                        .floor_plan_property_images,
                    icon: Icon(
                      Icons.account_tree_outlined,
                      size: 28.w,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagesViewerScreen(
                              floorPlanImages,
                              AppLocalizations.of(context)!
                                  .estate_floor_plan_images,
                              widget.estate.videoUrl == null
                                  ? ""
                                  : widget.estate.videoUrl!),
                        ),
                      );
                    },
                  ),
                // Estate Position :
                if (widget.estate.longitude != null &&
                    widget.estate.latitude != null)
                  RowInformation(
                    title: AppLocalizations.of(context)!.estate_position,
                    icon: Icon(
                      Icons.location_on_outlined,
                      size: 28.w,
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
                // 10.verticalSpace,
                kHe24,
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EstateOfficeScreen(widget.estate.estateOffice == null ? -1 : widget.estate.estateOffice!.id),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        width: 120.w,
                        height: 120.h,
                        child: widget.estate.estateOffice == null ?  CachedNetworkImage(imageUrl: swessHomeIconPath) :
                        CachedNetworkImage(
                            imageUrl: imagesBaseUrl + widget.estate.estateOffice!.logo!),
                      ),
                      kHe8,
                      widget.estate.estateOffice == null ? Center() :
                      ResText(
                        widget.estate.estateOffice!.name!,
                        textStyle: Theme.of(context).textTheme.headline4,
                      ),
                      kHe12,
                      widget.estate.estateOffice == null ? Center() :
                      ResText(
                        widget.estate.estateOffice!.location!.getLocationName(),
                        textStyle: Theme.of(context).textTheme.headline6,
                      ),
                      kHe8,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(160.w, 50.h)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ResText(
                              AppLocalizations.of(context)!.office_page,
                              textStyle: TextStyle(fontSize: 12.sp),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EstateOfficeScreen(
                            widget.estate.estateOffice == null ? -1 : widget.estate.estateOffice!.id),
                            ),
                          );
                        },
                      ),
                      kHe24,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(220.w, 64.h)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            kWi12,
                            Text(
                              AppLocalizations.of(context)!.call,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          visitBloc.add(
                            VisitStarted(
                                visitId: widget.estate.id!,
                                token: userToken,
                                visitType: VisitType.officeCall),
                          );
                          await myCupertinoActionSheet(
                            context,
                            elementsList: [
                              widget.estate.estateOffice == null ? "" :
                              widget.estate.estateOffice!.phone!.split("+")[1] +
                                  "+"
                            ],
                            onPressed: [
                              () {
                                launch("tel://" +
                                    widget.estate.estateOffice!.phone
                                        .toString());
                              },
                            ],
                          );
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  8.horizontalSpace,
                  SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: Center(child: icon),
                  ),
                  8.horizontalSpace,
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ResText(
                      title,
                      textStyle: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 15),
                    ),
                  ),
                  8.horizontalSpace,
                  (widgetContent != null)
                      ? widgetContent!
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ResText(
                              content ?? "",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 16.sp),
                              textAlign: TextAlign.start,
                              maxLines: 8,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          if (withBottomDivider) ...[4.verticalSpace, const Divider()],
        ],
      ),
    );
  }
}
