import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_introduction_screen.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/rate_container.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'authentication_screen.dart';

class EstateOfficeScreen extends StatefulWidget {
  final EstateOffice office;

  const EstateOfficeScreen(this.office, {Key? key}) : super(key: key);

  @override
  _EstateOfficeScreenState createState() => _EstateOfficeScreenState();
}

class _EstateOfficeScreenState extends State<EstateOfficeScreen> {
  final VisitBloc _visitBloc = VisitBloc(EstateRepository());
  late LikeAndUnlikeBloc _likeAndUnlikeBloc;

  final EstateBloc _estateBloc = EstateBloc(
    EstateRepository(),
  );

  String? userToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Register office visit :

    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      userToken = BlocProvider.of<UserLoginBloc>(context).user!.token;
    }
    _likeAndUnlikeBloc =
        LikeAndUnlikeBloc((widget.office.isLiked) ? Liked() : Unliked(), EstateRepository());

    _visitBloc.add(VisitStarted(
        visitId: widget.office.id, token: userToken, visitType: VisitType.estateOffice));

    _estateBloc.add(
      OfficeEstatesFetchStarted(officeId: widget.office.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _estateBloc,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: Res.height(75),
          backgroundColor: AppColors.secondaryColor,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Res.width(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          title: SizedBox(
            width: inf,
            child: ResText(
              "تفاصيل المكتب",
              textStyle: textStyling(S.s18, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          leading: Container(
            margin: EdgeInsets.only(
              left: Res.width(16),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.public,
                color: AppColors.white,
              ),
              onPressed: () {},
            ),
          ),
        ),
        body: RefreshIndicator(
          color: AppColors.secondaryColor,
          onRefresh: () async {
            _estateBloc.add(
              OfficeEstatesFetchStarted(officeId: widget.office.id),
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                kHe32,
                Hero(
                  tag: widget.office.id.toString(),
                  child: CircleAvatar(
                    radius: Res.width(96),
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(baseUrl + widget.office.logo!),
                  ),
                ),
                kHe24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: RateContainer(
                        rate: double.parse(widget.office.rating!),
                      ),
                    ),
                    kWi8,
                    ResText(
                      widget.office.name!,
                      textStyle: textStyling(S.s24, W.w6, C.bl).copyWith(height: 1.8),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
                kHe16,
                SizedBox(
                  width: screenWidth,
                  child: ResText(
                    widget.office.location!.getLocationName(),
                    textStyle: textStyling(S.s18, W.w5, C.bl),
                    textAlign: TextAlign.center,
                  ),
                ),
                kHe12,
                SizedBox(
                  width: screenWidth,
                  child: ResText(
                    widget.office.mobile!,
                    textStyle: textStyling(S.s18, W.w5, C.bl),
                    textAlign: TextAlign.center,
                  ),
                ),
                kHe32,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      width: Res.width(150),
                      onPressed: () async {
                        if (BlocProvider.of<UserLoginBloc>(context).user == null) {
                          await showWonderfulAlertDialog(
                            context,
                            "تأكيد",
                            "إن هذه الميزة تتطلب تسجيل الدخول",
                            removeDefaultButton: true,
                            dialogButtons: [
                              MyButton(
                                child: ResText(
                                  "إلغاء",
                                  textStyle: textStyling(S.s16, W.w5, C.wh).copyWith(height: 1.8),
                                ),
                                width: Res.width(140),
                                color: AppColors.secondaryColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              MyButton(
                                child: ResText(
                                  "تسجيل الدخول",
                                  textStyle: textStyling(S.s16, W.w5, C.wh).copyWith(height: 1.8),
                                ),
                                width: Res.width(140),
                                color: AppColors.secondaryColor,
                                onPressed: () async {
                                  await Navigator.pushNamed(context, AuthenticationScreen.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                            width: Res.width(400),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CreatePropertyIntroductionScreen(officeId: widget.office.id),
                          ),
                        );
                      },
                      color: AppColors.white,
                      shadow: [lowElevation],
                      border: Border.all(color: AppColors.secondaryColor),
                      borderRadius: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add),
                          ResText(
                            "نشر عقار",
                            textStyle: textStyling(S.s14, W.w5, C.bl),
                          )
                        ],
                      ),
                    ),
                    kWi16,
                    BlocConsumer<LikeAndUnlikeBloc, LikeAndUnlikeState>(
                      bloc: _likeAndUnlikeBloc,
                      listener: (_, likeAndUnlikeState) {
                        if (likeAndUnlikeState is LikeAndUnlikeError) {
                          showWonderfulAlertDialog(context, "خطأ", likeAndUnlikeState.error);
                          _likeAndUnlikeBloc.add(ReInitializeLikeState(isLike: widget.office.isLiked));
                        } else if (likeAndUnlikeState is Liked) {
                          widget.office.isLiked = true;
                        } else if (likeAndUnlikeState is Unliked) {
                          widget.office.isLiked = false;
                        }
                      },
                      builder: (_, likeAndUnlikeState) {
                        return MyButton(
                          width: Res.width(150),
                          onPressed: () {
                            if (likeAndUnlikeState is Liked) {
                              _likeAndUnlikeBloc.add(
                                UnlikeStarted(
                                    token: userToken,
                                    unlikedObjectId: widget.office.id,
                                    likeType: LikeType.estateOffice),
                              );
                            }
                            if (likeAndUnlikeState is Unliked) {
                              _likeAndUnlikeBloc.add(
                                LikeStarted(
                                    token: userToken,
                                    likedObjectId: widget.office.id,
                                    likeType: LikeType.estateOffice),
                              );
                            }
                          },
                          color: AppColors.white,
                          shadow: [lowElevation],
                          border: Border.all(color: AppColors.secondaryColor),
                          borderRadius: 4,
                          child: (likeAndUnlikeState is LikeAndUnlikeProgress)
                              ? const SpinKitWave(
                                  color: AppColors.secondaryColor,
                                  size: 16,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon((likeAndUnlikeState is Liked)
                                        ? Icons.thumb_up_alt
                                        : Icons.thumb_up_alt_outlined),
                                    kWi12,
                                    ResText(
                                      (likeAndUnlikeState is Liked) ? "تم الإعجاب" : "إعجاب",
                                      textStyle: textStyling(S.s14, W.w5, C.bl),
                                      textAlign: TextAlign.right,
                                    )
                                  ],
                                ),
                        );
                      },
                    )
                  ],
                ),
                kHe40,
                Container(
                  height: Res.height(32),
                  width: screenWidth,
                  color: AppColors.secondaryColor,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(
                    right: Res.width(8),
                  ),
                  child: ResText(
                    ": العروض العقارية",
                    textStyle: textStyling(S.s14, W.w4, C.wh),
                    textAlign: TextAlign.right,
                  ),
                ),
                kHe24,
                BlocConsumer<EstateBloc, EstateState>(
                  bloc: _estateBloc,
                  listener: (_, estateState) {
                    if (estateState is EstateFetchError) {
                      showWonderfulAlertDialog(context, "خطأ", estateState.errorMessage);
                    }
                  },
                  builder: (_, estateState) {
                    if (estateState is EstateFetchProgress) {
                      return const EstatesShimmer();
                    }
                    if (estateState is! EstateFetchComplete) {
                      return FetchResult(
                        content: "حدث خطأ أثناء تنفيذ العملية",
                        iconSize: screenWidth / 4,
                      );
                    }

                    List<Estate> estates = estateState.estates;

                    if (estates.isEmpty) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: Res.height(60),
                        ),
                        width: screenWidth,
                        child: ResText(
                          "! لم يقم هذا المكتب بنشر عروض عقارية",
                          textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(
                            color: AppColors.black.withOpacity(0.48),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: estates.length,
                      itemBuilder: (_, index) {
                        return EstateCard(
                          estate: estates.elementAt(index),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
