import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_introduction_screen.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_bloc.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_event.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_state.dart';
import '../../data/models/estate.dart';
import '../../data/models/estate_office.dart';
import '../widgets/cupertino_action_sheet.dart';
import '../widgets/estate_horizon_card.dart';
import '../widgets/report_estate.dart';
import '../widgets/res_text.dart';
import '../widgets/wonderful_alert_dialog.dart';
import 'authentication_screen.dart';

class EstateOfficeScreen extends StatefulWidget {
  final int id;

  const EstateOfficeScreen(this.id, {Key? key}) : super(key: key);

  @override
  _EstateOfficeScreenState createState() => _EstateOfficeScreenState();
}

class _EstateOfficeScreenState extends State<EstateOfficeScreen> {
  final VisitBloc _visitBloc = VisitBloc(EstateRepository());

  final LikeAndUnlikeBloc _likeAndUnlikeBloc = LikeAndUnlikeBloc(Unliked(), EstateRepository());
  final GetOfficesBloc _getOfficesBloc = GetOfficesBloc(EstateRepository());

  final ScrollController _scrollController = ScrollController();
  final List<Estate> estates = [];
  bool isEstatesFinished = false;
  String? userToken;
  OfficeDetails? results;

  @override
  void initState() {
    super.initState();

    // Register office visit :
    if (UserSharedPreferences.getAccessToken() != null) {
      userToken = UserSharedPreferences.getAccessToken();
    }
    _onRefresh();
    _visitBloc.add(VisitStarted(visitId: widget.id, token: userToken, visitType: VisitType.estateOffice));

    isEstatesFinished = false;
  }

  _onRefresh() async {
    _getOfficesBloc.add(
      GetOfficesDetailsStarted(officeId: widget.id, token: userToken),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          iconTheme:
          IconThemeData(color: isDark ? Colors.white : AppColors.black),
          backgroundColor:
          isDark ? const Color(0xff26282B) : AppColors.white,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.office_details,
            style:
            TextStyle(color: isDark ? Colors.white : AppColors.black),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          _onRefresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController
            ..addListener(
              () {
                if (_scrollController.offset == _scrollController.position.maxScrollExtent && !_getOfficesBloc.isFetching && !isEstatesFinished) {
                  _getOfficesBloc
                    ..isFetching = true
                    ..add(
                      GetOfficesDetailsStarted(officeId: widget.id, token: userToken),
                    );
                }
              },
            ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              kHe24,
              BlocConsumer<GetOfficesBloc, GetOfficesStates>(
                bloc: _getOfficesBloc,
                listener: (_, estateState) async {
                  if (estateState is GetOfficesFetchError) {
                    var error = estateState.isConnectionError ? AppLocalizations.of(context)!.no_internet_connection : estateState.errorMessage;
                    await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);
                  }
                  if (estateState is GetOfficesFetchComplete) {
                    results = estateState.results;
                    estates.addAll(estateState.results.estates);
                    _getOfficesBloc.isFetching = false;
                    if (estateState.results.estates.isEmpty && estates.isNotEmpty) {
                      isEstatesFinished = true;
                    }
                  }
                },
                builder: (_, estateState) {
                  if (estateState is GetOfficesFetchError && estates.isEmpty) {
                    return RefreshIndicator(
                      color: Theme.of(context).colorScheme.primary,
                      onRefresh: () async {
                        _getOfficesBloc.page = 1;
                        _onRefresh();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                            width: 1.sw,
                            height: 1.sh - 75.h,
                            child: FetchResult(content: AppLocalizations.of(context)!.error_happened_when_executing_operation)),
                      ),
                    );
                  }
                  if (estateState is GetOfficesFetchProgress && estates.isEmpty) {
                    return const PropertyShimmer();
                  } else if (estateState is! GetOfficesFetchComplete && estates.isEmpty) {
                    return FetchResult(
                      content: AppLocalizations.of(context)!.error_happened_when_executing_operation,
                      iconSize: 0.25.sw,
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        width: getScreenWidth(context),
                        child: (results!.communicationMedias != null)
                            ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: buildImage(),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: buildOfficeDetails(),
                                    ),
                                  ],
                                ),
                            )
                            : Column(
                                children: [
                                  buildImage(),
                                  20.verticalSpace,
                                  ResText(
                                    results!.estateOffice.name!,
                                    textStyle: Theme.of(context).textTheme.headline4!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          //fontSize: 24.sp
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  12.verticalSpace,
                                  ResText(
                                    results!.estateOffice.locationS!,
                                    textStyle: Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                      ),
                      // 8.verticalSpace,
                      // Account name and rate :
                      kHe4,
                      if (results!.estateOffice.workHours! != " - ")
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.lightblue,
                              ),
                              borderRadius: lowBorderRadius,
                            ),
                            child: Text(
                              results!.estateOffice.workHours!,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),
                      kHe28,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(150.w, 50.h),
                                ),
                                onPressed: () async {
                                  if (BlocProvider.of<UserLoginBloc>(context).user == null) {
                                    await buildSignInRequiredDialog();
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreatePropertyIntroductionScreen(officeId: results!.estateOffice.id),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add,size: 20,color: AppColors.white),
                                    ResText(
                                      AppLocalizations.of(context)!.post_estate,
                                      textStyle: TextStyle(fontSize: 15.sp, color: AppColors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            kWi16,
                            Expanded(
                              flex: 1,
                              child: BlocConsumer<LikeAndUnlikeBloc, LikeAndUnlikeState>(
                                bloc: _likeAndUnlikeBloc,
                                listener: (_, likeAndUnlikeState) async {
                                  if (likeAndUnlikeState is LikeAndUnlikeError) {
                                    var error =
                                        likeAndUnlikeState.isConnectionError ? AppLocalizations.of(context)!.no_internet_connection : likeAndUnlikeState.error;
                                    await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);
                                    _likeAndUnlikeBloc.add(ReInitializeLikeState(isLike: results!.estateOffice.isLiked!));
                                  } else if (likeAndUnlikeState is Liked) {
                                    results!.estateOffice.isLiked = true;
                                  } else if (likeAndUnlikeState is Unliked) {
                                    results!.estateOffice.isLiked = false;
                                  }
                                },
                                builder: (_, likeAndUnlikeState) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(fixedSize: Size(180.w, 64.h)),
                                    onPressed: () async {
                                      if (userToken == null) {
                                        await buildSignInRequiredDialog();
                                        return;
                                      }

                                      if (likeAndUnlikeState is Liked) {
                                        _likeAndUnlikeBloc.add(
                                          UnlikeStarted(token: userToken, unlikedObjectId: results!.estateOffice.id, likeType: LikeType.estateOffice),
                                        );
                                      }
                                      if (likeAndUnlikeState is Unliked) {
                                        _likeAndUnlikeBloc.add(
                                          LikeStarted(token: userToken, likedObjectId: results!.estateOffice.id, likeType: LikeType.estateOffice),
                                        );
                                      }
                                    },
                                    child: (likeAndUnlikeState is LikeAndUnlikeProgress)
                                        ? SpinKitWave(
                                            color: AppColors.white,
                                            size: 16.w,
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon((likeAndUnlikeState is Liked) ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,size: 20,color: AppColors.white),
                                              kWi12,
                                              ResText(
                                                (likeAndUnlikeState is Liked) ? AppLocalizations.of(context)!.liked : AppLocalizations.of(context)!.like,
                                                textStyle: TextStyle(fontSize: 15.sp, color: AppColors.white),
                                              )
                                            ],
                                          ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      kHe28,
                      Container(
                        height: 32.h,
                        width: 1.sw,
                        color: isDark ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          right: isArabic ? 8.w : 0,
                          left: !isArabic ? 8.w : 0,
                        ),
                        child: Row(
                          children: [
                            ResText(
                              AppLocalizations.of(context)!.estate_offers,
                              textStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                            ResText(
                              "  ${results!.estateOffice.estateLength!} : ",
                              textStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      kHe16,
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: estates.length,
                        itemBuilder: (_, index) {
                          return EstateHorizonCard(
                            estate: estates.elementAt(index),
                            onClosePressed: () {
                              showReportModalBottomSheet(context, estates.elementAt(index).id!);
                            },
                            closeButton: false,
                          );
                          // return EstateCard(
                          //   color: Theme.of(context).colorScheme.background,
                          //   estate: estates.elementAt(index),
                          //   onClosePressed: () {
                          //     showReportModalBottomSheet(
                          //         context, estates.elementAt(index).id!);
                          //   },
                          //   removeCloseButton: false,
                          // );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return Container(
      // height: 200.h,
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => ImageDialog(path: results!.estateOffice.logo!),
            );
          },
          child: Hero(
            tag: results!.estateOffice.id.toString(),
            child: Container(
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: lowBorderRadius,
              ),
              child: CachedNetworkImage(imageUrl: imagesBaseUrl + results!.estateOffice.logo!),
            ),
            // child: CircleAvatar(
            //   radius: 90.w,
            //   backgroundColor: Colors.grey,
            //   backgroundImage:
            //       CachedNetworkImageProvider(
            //           imagesBaseUrl +
            //               results!.logo!),
            // ),
          ),
        ),
      ),
    );
  }

  Widget buildOfficeDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ResText(
          results!.estateOffice.name!,
          textStyle: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        12.verticalSpace,
        ResText(
          results!.estateOffice.locationS!,
          textStyle: Theme.of(context).textTheme.headline6,
        ),
        12.verticalSpace,
        SizedBox(
          width: 200.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  _visitBloc.add(
                    VisitStarted(visitId: results!.estateOffice.id, token: userToken, visitType: VisitType.officeCall),
                  );
                  await myCupertinoActionSheet(
                    context,
                    elementsList: results!.communicationMedias!.phone!.map((e) => e.value).toList(),
                    onPressed: results!.communicationMedias!.phone!
                        .map((e) => () {
                              launch(
                                "tel://" + e.value!,
                              );
                            })
                        .toList(),
                  );
                  // launch(
                  //   "tel://" + results!.mobile!,
                  // );
                },
                child: const Icon(Icons.phone_outlined),
              ),
              InkWell(
                onTap: () async {
                  _visitBloc.add(
                    VisitStarted(visitId: results!.estateOffice.id, token: userToken, visitType: VisitType.officeCall),
                  );
                  // launch(
                  //   "tel://" + results!.mobile!,
                  // );
                },
                child: const Icon(Icons.facebook_rounded),
              ),
              InkWell(
                onTap: () async {
                  _visitBloc.add(
                    VisitStarted(visitId: results!.estateOffice.id, token: userToken, visitType: VisitType.officeCall),
                  );
                  await myCupertinoActionSheet(
                    context,
                    elementsList: results!.communicationMedias!.whatsApp!.map((e) => e.value).toList(),
                    onPressed: results!.communicationMedias!.whatsApp!
                        .map((e) => () {
                              launch("tel://" + e.value!);
                            })
                        .toList(),
                  );
                },
                child: const Icon(Icons.add /*whatsapp_outlined*/),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future buildSignInRequiredDialog() async {
    await showWonderfulAlertDialog(
      context,
      AppLocalizations.of(context)!.confirmation,
      AppLocalizations.of(context)!.this_features_require_login,
      removeDefaultButton: true,
      dialogButtons: [
        ElevatedButton(
          child: Text(
            AppLocalizations.of(context)!.sign_in,
          ),
          onPressed: () async {
            await Navigator.pushNamed(context, AuthenticationScreen.id);
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text(
            AppLocalizations.of(context)!.cancel,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      width: 400.w,
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String path;

  const ImageDialog({required this.path, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: getScreenWidth(context),
        height: 400.h,
        decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(imagesBaseUrl + path), fit: BoxFit.cover)),
      ),
    );
  }
}
