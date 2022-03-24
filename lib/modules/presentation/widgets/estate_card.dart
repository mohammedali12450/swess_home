import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/estate_details_screen.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'my_button.dart';

class EstateCard extends StatefulWidget {
  final Estate estate;
  final bool removeBottomBar;
  final Widget? bottomWidget;
  final Function? onClosePressed;
  final bool removeCloseButton;

  const EstateCard({
    Key? key,
    required this.estate,
    this.removeBottomBar = false,
    this.bottomWidget,
    this.onClosePressed,
    this.removeCloseButton = false,
  }) : super(key: key);

  @override
  _EstateCardState createState() => _EstateCardState();
}

class _EstateCardState extends State<EstateCard> {
  ChannelCubit currentImageCubit = ChannelCubit(0);

  late LikeAndUnlikeBloc _likeAndUnlikeBloc;

  late SaveAndUnSaveEstateBloc _saveAndUnSaveEstateBloc;

  VisitBloc visitBloc = VisitBloc(EstateRepository());

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
    int intPrice = int.parse(widget.estate.price);
    String estatePrice = NumbersHelper.getMoneyFormat(intPrice);
    String specialWord = (widget.estate.estateType.id == 1 ||
            widget.estate.estateType.id == 2 ||
            widget.estate.estateType.id == 5)
        ? " مميز"
        : " مميزة";
    String estateType = widget.estate.estateType.getName(true).split('|').elementAt(1) +
        ((widget.estate.contractId! == 4) ? specialWord : "");
    String addingDate =
        DateHelper.getDateByFormat(DateTime.parse(widget.estate.publishedAt!), "yyyy/MM/dd");
    Color estateTypeBackgroundColor = Colors.white;
    Color estatePriceBackgroundColor = Colors.white;
    Color estateTypeColor = Colors.white;
    Color estatePriceColor = Colors.white;
    List<String> estateImages =
        widget.estate.images.where((e) => e.type == "estate_image").map((e) => e.url).toList();

    switch (widget.estate.contractId!) {
      case 1:
        {
          estateTypeBackgroundColor = AppColors.baseColor;
          estatePriceBackgroundColor = AppColors.baseColor.withAlpha(120);
          estateTypeColor = AppColors.black;
          estatePriceColor = AppColors.black;
          break;
        }
      case 2:
        {
          estateTypeBackgroundColor = AppColors.baseColor;
          estatePriceBackgroundColor = AppColors.baseColor.withAlpha(80);
          estateTypeColor = AppColors.black;
          estatePriceColor = AppColors.black;
          break;
        }
      case 3:
        {
          estateTypeBackgroundColor = AppColors.lastColor;
          estatePriceBackgroundColor = AppColors.lastColor.withAlpha(220);
          estateTypeColor = AppColors.white;
          estatePriceColor = AppColors.white;
          break;
        }
      case 4:
        {
          estateTypeBackgroundColor = AppColors.secondaryColor;
          estatePriceBackgroundColor = AppColors.secondaryColor.withAlpha(220);
          estateTypeColor = AppColors.white;
          estatePriceColor = AppColors.white;
          break;
        }
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Res.height(8),
      ),
      width: screenWidth,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.32),
              offset: const Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 2)
        ],
        gradient: LinearGradient(colors: [
          (widget.estate.contractId == 4) ? Colors.yellow[200]! : Colors.white,
          AppColors.white,
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
                              imageUrl: baseUrl + estateImages.elementAt(index),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (_, __, ___) {
                                return Container(
                                  color: AppColors.white,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: AppColors.secondaryColor.withOpacity(0.6),
                                    size: 120,
                                  ),
                                );
                              },
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
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
                                color: AppColors.black.withOpacity(0.64),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20,
                                    color: AppColors.white,
                                  ),
                                  kWi4,
                                  ResText(
                                    (currentImageIndex + 1).toString() + '/',
                                    textStyle: textStyling(S.s12, W.w4, C.wh, fontFamily: F.roboto),
                                  ),
                                  ResText(
                                    estateImages.length.toString(),
                                    textStyle: textStyling(S.s12, W.w4, C.wh, fontFamily: F.roboto),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      if (!widget.removeCloseButton)
                        Positioned(
                          top: Res.height(4),
                          right: Res.width(8),
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
                                size: 16,
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
                                  .copyWith(color: estateTypeColor, height: 1.8),
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
                              if (widget.estate.estateOfferType.id == rentOfferTypeNumber)
                                ResText(
                                  widget.estate.periodType!.getName(true).split("|").first + " /",
                                  textStyle: textStyling(
                                    S.s20,
                                    W.w5,
                                    C.bl,
                                  ).copyWith(height: 1.8, color: estatePriceColor),
                                  textAlign: TextAlign.right,
                                ),
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
                                  ).copyWith(height: 1.8, color: estatePriceColor),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  right: Res.width(12),
                                ),
                                child: ResText(
                                  estatePrice,
                                  textStyle:
                                      textStyling(S.s22, W.w4, C.bl, fontFamily: F.libreFranklin)
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
                                widget.estate.location.getLocationName(),
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
                kHe8,
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
                  listener: (_, saveAndUnSaveState) {
                    if (saveAndUnSaveState is EstateSaveAndUnSaveError) {
                      showWonderfulAlertDialog(context, "خطأ", saveAndUnSaveState.error);
                      _saveAndUnSaveEstateBloc
                          .add(ReInitializeSaveState(isSaved: widget.estate.isSaved!));
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
                            "خطأ",
                            "هذه الميزة تتطلب تسجيل الدخول",
                            removeDefaultButton: true,
                            width: Res.width(400),
                            dialogButtons: [
                              MyButton(
                                width: Res.width(150),
                                color: AppColors.secondaryColor,
                                child: ResText(
                                  "إلغاء",
                                  textStyle: textStyling(S.s16, W.w5, C.wh),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              MyButton(
                                width: Res.width(150),
                                color: AppColors.secondaryColor,
                                child: ResText(
                                  "تسجيل الدخول",
                                  textStyle: textStyling(S.s16, W.w5, C.wh),
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
                          ? const SpinKitWave(
                              color: AppColors.secondaryColor,
                              size: 16,
                            )
                          : Icon((saveAndUnSaveState is EstateSaved)
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined),
                      color: AppColors.secondaryColor,
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
                  listener: (_, likeAndUnlikeState) {
                    if (likeAndUnlikeState is LikeAndUnlikeError) {
                      showWonderfulAlertDialog(context, "خطأ", likeAndUnlikeState.error);
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
                            "تأكيد",
                            "هذه الميزة تتطلب تسجيل الدخول",
                            removeDefaultButton: true,
                            width: Res.width(400),
                            dialogButtons: [
                              MyButton(
                                width: Res.width(150),
                                color: AppColors.secondaryColor,
                                child: ResText(
                                  "إلغاء",
                                  textStyle: textStyling(S.s16, W.w5, C.wh),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              MyButton(
                                width: Res.width(150),
                                color: AppColors.secondaryColor,
                                child: ResText(
                                  "تسجيل الدخول",
                                  textStyle: textStyling(S.s16, W.w5, C.wh),
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
                          ? const SpinKitWave(
                              color: AppColors.secondaryColor,
                              size: 16,
                            )
                          : Icon(
                              (likeAndUnlikeState is Liked)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: AppColors.secondaryColor,
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
