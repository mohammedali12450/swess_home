import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/estate_details_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/enums.dart';
import '../screens/authentication_screen.dart';

class EstateCard extends StatefulWidget {
  final Estate estate;
  final bool removeBottomBar;
  final Widget? bottomWidget;
  final Function? onClosePressed;
  final bool removeCloseButton;

  const EstateCard(
      {Key? key,
      required this.estate,
      this.removeBottomBar = false,
      this.bottomWidget,
      required this.removeCloseButton,
      this.onClosePressed})
      : super(key: key);

  @override
  _EstateCardState createState() => _EstateCardState();
}

class _EstateCardState extends State<EstateCard> {
  ChannelCubit currentImageCubit = ChannelCubit(0);

  late LikeAndUnlikeBloc _likeAndUnlikeBloc;

  late SaveAndUnSaveEstateBloc _saveAndUnSaveEstateBloc;
  VisitBloc visitBloc = VisitBloc(EstateRepository());

  late String currency;
  String? userToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _likeAndUnlikeBloc = LikeAndUnlikeBloc(
      (widget.estate.isLiked!) ? Liked() : Unliked(),
      EstateRepository(),
    );

    _saveAndUnSaveEstateBloc = SaveAndUnSaveEstateBloc(
      (widget.estate.isSaved!) ? EstateSaved() : EstateUnSaved(),
      EstateRepository(),
    );

    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null && user.token != null) {
      userToken = user.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode(context);

    currency = AppLocalizations.of(context)!.syrian_currency;
    if (BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.isForStore) {
      currency = AppLocalizations.of(context)!.lebanon_currency;
    }

    int intPrice = int.parse(widget.estate.price);
    String estatePrice = NumbersHelper.getMoneyFormat(intPrice);

    String estateType = widget.estate.estateType.getName(isArabic).split('|').elementAt(1);
    String addingDate =
        DateHelper.getDateByFormat(DateTime.parse(widget.estate.createdAt!), "yyyy/MM/dd");
    List<String> estateImages =
        widget.estate.images.where((e) => e.type == "estate_image").map((e) => e.url).toList();

    Color estateTypeBackgroundColor = Colors.white;
    Color estatePriceBackgroundColor = Colors.white;
    Color estateTypeColor = Colors.white;
    Color estatePriceColor = Colors.white;

    if (isDarkMode) {
      switch (widget.estate.contractId!) {
        case 1:
        case 2:
          {
            estateTypeBackgroundColor = Colors.white12;
            estatePriceBackgroundColor = Colors.white54;
            estateTypeColor = AppColors.white;
            estatePriceColor = AppColors.black;
            break;
          }
        case 3:
        case 4:
          {
            estateTypeBackgroundColor = Colors.black38;
            estatePriceBackgroundColor = Colors.white24;
            estateTypeColor = AppColors.white;
            estatePriceColor = AppColors.white;
            break;
          }
      }
    } else {
      switch (widget.estate.contractId!) {
        case 1:
        case 2:
          {
            estateTypeBackgroundColor = Theme.of(context).colorScheme.primary.withAlpha(180);
            estatePriceBackgroundColor = Theme.of(context).colorScheme.secondary;
            estateTypeColor = AppColors.white;
            estatePriceColor = AppColors.black;
            break;
          }
        case 3:
        case 4:
          {
            estateTypeBackgroundColor = Theme.of(context).colorScheme.primary;
            estatePriceBackgroundColor = Theme.of(context).colorScheme.secondary;
            estateTypeColor = AppColors.white;
            estatePriceColor = AppColors.black;
            break;
          }
      }
    }


    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      width: 1.sw,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: const Offset(0, 2),
            blurRadius: 4,
          )
        ],
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
                  height: 300.h,
                  child: Stack(
                    children: [
                      PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions.customChild(
                            child: CachedNetworkImage(
                              imageUrl: imagesBaseUrl  + estateImages.elementAt(index),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (_, __, ___) {
                                return Icon(
                                  Icons.camera_alt_outlined,
                                  size: 120.w,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.64),
                                );
                              },
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            disableGestures: true,
                          );
                        },
                        itemCount: widget.estate.images
                            .where((element) => element.type == "estate_image")
                            .length,
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
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
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
                                    style: Theme.of(context).textTheme.caption!.copyWith(
                                          fontFamily: "Hind",
                                          color: AppColors.black,
                                        ),
                                  ),
                                  Text(
                                    estateImages.length.toString(),
                                    style: Theme.of(context).textTheme.caption!.copyWith(
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
                      if (!widget.removeCloseButton)
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
                              icon: const Icon(
                                Icons.close,
                                size: 22,
                                color: AppColors.white,
                              ),
                              onPressed: () {
                                if (widget.onClosePressed != null) {
                                  widget.onClosePressed!();
                                }
                              },
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                // Estate price and type :
                SizedBox(
                  height: 100.h,
                  child: Row(
                    children: [
                      // price
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 1.sh,
                          decoration: BoxDecoration(
                            color: estatePriceBackgroundColor,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: (isArabic) ? 12.w : 0,
                                  left: (!isArabic) ? 12.w : 0,
                                ),
                                child: Text(
                                  estatePrice,
                                  style: GoogleFonts.libreFranklin(
                                      color: estatePriceColor,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5),
                                ),
                              ),
                              if (widget.estate.estateOfferType.id != rentOfferTypeNumber)
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: (isArabic) ? 8.w : 0,
                                    left: (!isArabic) ? 8.w : 0,
                                  ),
                                  child: Text(
                                    currency,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        height: 1.8,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w400,
                                        color: estatePriceColor),
                                  ),
                                ),
                              if (widget.estate.estateOfferType.id == rentOfferTypeNumber)
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: (isArabic) ? 8.w : 0,
                                    left: (!isArabic) ? 8.w : 0,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.currency_over_period(
                                      currency,
                                      widget.estate.periodType!.getName(isArabic)!.split("|").first,
                                    ),
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        height: 1.8,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w400,
                                        color: estatePriceColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // type :
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: estateTypeBackgroundColor,
                          child: Center(
                            child: Text(
                              estateType,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: estateTypeColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Estate address and office logo
                Container(
                  height: 100.h,
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: (isArabic) ? 8.w : 0,
                            left: (!isArabic) ? 8.w : 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: Text(
                                  widget.estate.location.getLocationName(),
                                ),
                              ),
                              12.verticalSpace,
                              Text(
                                AppLocalizations.of(context)!.adding_date + " : " + addingDate,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 75.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                imagesBaseUrl + widget.estate.estateOffice!.logo!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      8.horizontalSpace
                    ],
                  ),
                ),
              ],
            ),
          ),
          // bottom bar :
          if (!widget.removeBottomBar) ...[
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocConsumer<SaveAndUnSaveEstateBloc, SaveAndUnSaveEstateState>(
                  bloc: _saveAndUnSaveEstateBloc,
                  listener: (_, saveAndUnSaveState) async{
                    if (saveAndUnSaveState is EstateSaveAndUnSaveError) {
                      var error = saveAndUnSaveState.isConnectionError
                          ? AppLocalizations.of(context)!.no_internet_connection
                          : saveAndUnSaveState.error;
                      await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);
                    _saveAndUnSaveEstateBloc.add(
                        ReInitializeSaveState(isSaved: widget.estate.isSaved!),
                      );
                    }
                    if (saveAndUnSaveState is EstateSaved) {
                      widget.estate.isSaved = true;
                    }
                    if (saveAndUnSaveState is EstateUnSaved) {
                      widget.estate.isSaved = false;
                    }
                  },
                  builder: (_, saveAndUnSaveState) {
                    return IconButton(
                      onPressed: () {
                        if (userToken == null) {
                          showWonderfulAlertDialog(
                            context,
                            AppLocalizations.of(context)!.confirmation  ,
                            AppLocalizations.of(context)!.this_features_require_login,
                            removeDefaultButton: true,
                            width: 400.w,
                            dialogButtons: [
                              ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context)!.cancel,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context)!.sign_in,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AuthenticationScreen(
                                        popAfterFinish: true,
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                  User? user = BlocProvider.of<UserLoginBloc>(context).user;
                                  if (user != null && user.token != null) {
                                    userToken = user.token;
                                  }
                                  return;
                                },
                              ),
                            ],
                          );
                          return;
                        }

                        if (saveAndUnSaveState is EstateSaved) {
                          _saveAndUnSaveEstateBloc.add(
                              UnSaveEventStarted(token: userToken, estateId: widget.estate.id));
                        }
                        if (saveAndUnSaveState is EstateUnSaved) {
                          _saveAndUnSaveEstateBloc
                              .add(EstateSaveStarted(token: userToken, estateId: widget.estate.id));
                        }
                      },
                      icon: (saveAndUnSaveState is EstateSaveAndUnSaveProgress)
                          ? SpinKitWave(
                              color: Theme.of(context).colorScheme.primary,
                              size: 16.w,
                            )
                          : Icon((saveAndUnSaveState is EstateSaved)
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined),
                      color: Theme.of(context).colorScheme.primary,
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    visitBloc.add(
                      VisitStarted(
                          visitId: widget.estate.id,
                          token: userToken,
                          visitType: VisitType.estateCall),
                    );
                    launch(
                      "tel://" + widget.estate.estateOffice!.mobile.toString(),
                    );
                  },
                  icon: const Icon(Icons.call),
                ),
                BlocConsumer<LikeAndUnlikeBloc, LikeAndUnlikeState>(
                  bloc: _likeAndUnlikeBloc,
                  listener: (_, likeAndUnlikeState)async {
                    if (likeAndUnlikeState is LikeAndUnlikeError) {
                      var error = likeAndUnlikeState.isConnectionError
                          ? AppLocalizations.of(context)!.no_internet_connection
                          : likeAndUnlikeState.error;
                      await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);
                    _likeAndUnlikeBloc.add(
                        ReInitializeLikeState(isLike: widget.estate.isLiked!),
                      );
                    }
                    if (likeAndUnlikeState is Liked) {
                      widget.estate.isLiked = true;
                    }
                    if (likeAndUnlikeState is Unliked) {
                      widget.estate.isLiked = false;
                    }
                  },
                  builder: (_, likeAndUnlikeState) {
                    return IconButton(
                      onPressed: () async {
                        if (userToken == null) {
                          showWonderfulAlertDialog(
                            context,
                            AppLocalizations.of(context)!.confirmation,
                            AppLocalizations.of(context)!.this_features_require_login,
                            removeDefaultButton: true,
                            width: 400.w,
                            dialogButtons: [
                              ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context)!.cancel,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context)!.sign_in,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AuthenticationScreen(
                                        popAfterFinish: true,
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                  User? user = BlocProvider.of<UserLoginBloc>(context).user;
                                  if (user != null && user.token != null) {
                                    userToken = user.token;
                                  }
                                  return;
                                },
                              ),
                            ],
                          );
                          return;
                        }
                        if (likeAndUnlikeState is Liked) {
                          _likeAndUnlikeBloc.add(
                            UnlikeStarted(
                              token: userToken,
                              unlikedObjectId: widget.estate.id,
                              likeType: LikeType.estate,
                            ),
                          );
                        }
                        if (likeAndUnlikeState is Unliked) {
                          _likeAndUnlikeBloc.add(
                            LikeStarted(
                                token: userToken,
                                likedObjectId: widget.estate.id,
                                likeType: LikeType.estate),
                          );
                        }
                      },
                      icon: (likeAndUnlikeState is LikeAndUnlikeProgress)
                          ? SpinKitWave(
                              color: Theme.of(context).colorScheme.primary,
                              size: 16.w,
                            )
                          : Icon(
                              (likeAndUnlikeState is Liked)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    );
                  },
                ),
              ],
            ),
          ],
          // bottom widget :
          if (widget.bottomWidget != null) widget.bottomWidget!,
        ],
      ),
    );
  }
}
