import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_bloc.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_event.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_state.dart';
import '../../data/models/estate.dart';
import '../../data/models/estate_office.dart';
import '../widgets/cupertino_action_sheet.dart';
import '../widgets/report_estate.dart';
import 'authentication_screen.dart';

class EstateOfficeScreen extends StatefulWidget {
  final int id;

  const EstateOfficeScreen(this.id, {Key? key}) : super(key: key);

  @override
  _EstateOfficeScreenState createState() => _EstateOfficeScreenState();
}

class _EstateOfficeScreenState extends State<EstateOfficeScreen> {
  final VisitBloc _visitBloc = VisitBloc(EstateRepository());

  final LikeAndUnlikeBloc _likeAndUnlikeBloc =
      LikeAndUnlikeBloc(Unliked(), EstateRepository());
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
    _visitBloc.add(VisitStarted(
        visitId: widget.id,
        token: userToken,
        visitType: VisitType.estateOffice));

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.office_details,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
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
                if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent &&
                    !_getOfficesBloc.isFetching &&
                    !isEstatesFinished) {
                  _getOfficesBloc
                    ..isFetching = true
                    ..add(
                      GetOfficesDetailsStarted(
                          officeId: widget.id, token: userToken),
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
                    var error = estateState.isConnectionError
                        ? AppLocalizations.of(context)!.no_internet_connection
                        : estateState.errorMessage;
                    await showWonderfulAlertDialog(
                        context, AppLocalizations.of(context)!.error, error);
                  }
                  if (estateState is GetOfficesFetchComplete) {
                    results = estateState.results;
                    estates.addAll(estateState.results.estates);
                    _getOfficesBloc.isFetching = false;
                    if (estateState.results.estates.isEmpty &&
                        estates.isNotEmpty) {
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
                            child: FetchResult(
                                content: AppLocalizations.of(context)!
                                    .error_happened_when_executing_operation)),
                      ),
                    );
                  }
                  if (estateState is GetOfficesFetchProgress &&
                      estates.isEmpty) {
                    return const PropertyShimmer();
                  } else if (estateState is! GetOfficesFetchComplete &&
                      estates.isEmpty) {
                    return FetchResult(
                      content: AppLocalizations.of(context)!
                          .error_happened_when_executing_operation,
                      iconSize: 0.25.sw,
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: (results!.communicationMedias == null)
                                ? 20
                                : 0),
                        width: getScreenWidth(context),
                        child: (results!.communicationMedias != null)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: buildImage(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: buildOfficeDetails(),
                                  ),
                                ],
                              )
                            : buildImage(),
                      ),
                      8.verticalSpace,
                      // Account name and rate :
                      kHe12,
                      if (results!.estateOffice.workHours! != " - ")
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.green,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              results!.estateOffice.workHours!,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),
                      kHe32,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(180.w, 64.h)),
                                onPressed: () async {
                                  if (BlocProvider.of<UserLoginBloc>(context)
                                          .user ==
                                      null) {
                                    await buildSignInRequiredDialog();
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CreatePropertyIntroductionScreen(
                                              officeId:
                                                  results!.estateOffice.id),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.add),
                                    Text(
                                      AppLocalizations.of(context)!.post_estate,
                                      style: const TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            kWi16,
                            Expanded(
                              flex: 1,
                              child: BlocConsumer<LikeAndUnlikeBloc,
                                  LikeAndUnlikeState>(
                                bloc: _likeAndUnlikeBloc,
                                listener: (_, likeAndUnlikeState) async {
                                  if (likeAndUnlikeState
                                      is LikeAndUnlikeError) {
                                    var error =
                                        likeAndUnlikeState.isConnectionError
                                            ? AppLocalizations.of(context)!
                                                .no_internet_connection
                                            : likeAndUnlikeState.error;
                                    await showWonderfulAlertDialog(
                                        context,
                                        AppLocalizations.of(context)!.error,
                                        error);
                                    _likeAndUnlikeBloc.add(
                                        ReInitializeLikeState(
                                            isLike: results!
                                                .estateOffice.isLiked!));
                                  } else if (likeAndUnlikeState is Liked) {
                                    results!.estateOffice.isLiked = true;
                                  } else if (likeAndUnlikeState is Unliked) {
                                    results!.estateOffice.isLiked = false;
                                  }
                                },
                                builder: (_, likeAndUnlikeState) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(180.w, 64.h)),
                                    onPressed: () async {
                                      if (userToken == null) {
                                        await buildSignInRequiredDialog();
                                        return;
                                      }

                                      if (likeAndUnlikeState is Liked) {
                                        _likeAndUnlikeBloc.add(
                                          UnlikeStarted(
                                              token: userToken,
                                              unlikedObjectId:
                                                  results!.estateOffice.id,
                                              likeType: LikeType.estateOffice),
                                        );
                                      }
                                      if (likeAndUnlikeState is Unliked) {
                                        _likeAndUnlikeBloc.add(
                                          LikeStarted(
                                              token: userToken,
                                              likedObjectId:
                                                  results!.estateOffice.id,
                                              likeType: LikeType.estateOffice),
                                        );
                                      }
                                    },
                                    child: (likeAndUnlikeState
                                            is LikeAndUnlikeProgress)
                                        ? SpinKitWave(
                                            color: AppColors.white,
                                            size: 16.w,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon((likeAndUnlikeState is Liked)
                                                  ? Icons.thumb_up_alt
                                                  : Icons
                                                      .thumb_up_alt_outlined),
                                              kWi12,
                                              Text(
                                                (likeAndUnlikeState is Liked)
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .liked
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .like,
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
                      kHe40,
                      Container(
                        height: 32.h,
                        width: 1.sw,
                        color: isDark
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                        alignment: isArabic
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          right: isArabic ? 8.w : 0,
                          left: !isArabic ? 8.w : 0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.estate_offers,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                            Text(
                              "  ${results!.estateOffice.estateLength!} : ",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      kHe24,
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: estates.length,
                        itemBuilder: (_, index) {
                          return EstateCard(
                            color: Theme.of(context).colorScheme.background,
                            estate: estates.elementAt(index),
                            onClosePressed: () {
                              showReportModalBottomSheet(
                                  context, estates.elementAt(index).id!);
                            },
                            removeCloseButton: false,
                          );
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
    return SizedBox(
      height: 230.h,
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
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90.w),
              ),
              child: CachedNetworkImage(
                  imageUrl: imagesBaseUrl + results!.estateOffice.logo!),
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
        Text(
          results!.estateOffice.name!,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        12.verticalSpace,
        Text(
          results!.estateOffice.locationS!,
          style: Theme.of(context).textTheme.headline6,
        ),
        12.verticalSpace,
        SizedBox(
          width: 200.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  // _visitBloc.add(
                  //   VisitStarted(
                  //       visitId: results!.id,
                  //       token: userToken,
                  //       visitType: VisitType.officeCall),
                  // );
                  await myCupertinoActionSheet(
                    context,
                    elementsList: results!.communicationMedias!.phone!
                        .map((e) => e.value)
                        .toList(),
                    onPressed: [
                      () {},
                      () {},
                    ],
                  );
                  // launch(
                  //   "tel://" + results!.mobile!,
                  // );
                },
                child: const Icon(Icons.phone_outlined),
              ),
              InkWell(
                onTap: () async {
                  // _visitBloc.add(
                  //   VisitStarted(
                  //       visitId: results!.id,
                  //       token: userToken,
                  //       visitType: VisitType.officeCall),
                  // );
                  // launch(
                  //   "tel://" + results!.mobile!,
                  // );
                },
                child: const Icon(Icons.facebook_rounded),
              ),
              InkWell(
                onTap: () async {
                  // _visitBloc.add(
                  //   VisitStarted(
                  //       visitId: results!.id,
                  //       token: userToken,
                  //       visitType: VisitType.officeCall),
                  // );
                  await myCupertinoActionSheet(
                    context,
                    elementsList: results!.communicationMedias!.whatsApp!
                        .map((e) => e.value)
                        .toList(),
                    onPressed: [
                      () {
                        launch(
                          "tel://" + results!.estateOffice.mobile!,
                        );
                      },
                      () {
                        launch(
                          "tel://" + results!.estateOffice.mobile!,
                        );
                      },
                    ],
                  );
                },
                child: const Icon(Icons.whatsapp_outlined),
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
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(imagesBaseUrl + path),
                fit: BoxFit.contain)),
      ),
    );
  }
}
