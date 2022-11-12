import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_introduction_screen.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/rate_container.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../business_logic_components/bloc/office_details_bloc/office_details_bloc.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_event.dart';
import '../../business_logic_components/bloc/office_details_bloc/office_details_state.dart';
import '../widgets/cupertino_action_sheet.dart';
import '../widgets/report_estate.dart';
import 'authentication_screen.dart';

class EstateOfficeScreen extends StatefulWidget {
  //final EstateOffice office;
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
  final EstateBloc _estateBloc = EstateBloc(EstateRepository());

  String? userToken;

  @override
  void initState() {
    super.initState();

    // Register office visit :
    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      userToken = BlocProvider.of<UserLoginBloc>(context).user!.token;
    }

    _visitBloc.add(VisitStarted(
        visitId: widget.id,
        token: userToken,
        visitType: VisitType.estateOffice));

    _getOfficesBloc.add(
      GetOfficesDetailsStarted(officeId: widget.id),
    );
    _estateBloc.add(
      OfficeEstatesFetchStarted(officeId: widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return BlocProvider(
      create: (_) => _estateBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.office_details,
          ),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            _estateBloc.add(
              OfficeEstatesFetchStarted(officeId: widget.id),
            );
            _getOfficesBloc.add(
              GetOfficesDetailsStarted(officeId: widget.id),
            );
          },
          child: SingleChildScrollView(
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
                  },
                  builder: (_, estateState) {
                    if (estateState is GetOfficesFetchProgress) {
                      return const PropertyShimmer();
                    }
                    if (estateState is! GetOfficesFetchComplete) {
                      return FetchResult(
                        content: AppLocalizations.of(context)!
                            .error_happened_when_executing_operation,
                        iconSize: 0.25.sw,
                      );
                    }
                    return Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 230.h,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (_) => ImageDialog(
                                              path: estateState.results.logo!));
                                    },
                                    child: Hero(
                                      tag: estateState.results.id.toString(),
                                      child: CircleAvatar(
                                        radius: 90.w,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                imagesBaseUrl +
                                                    estateState.results.logo!),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    estateState.results.name!,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    estateState.results.location!
                                        .getLocationName(),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  12.verticalSpace,
                                  SizedBox(
                                    width: 200.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            // _visitBloc.add(
                                            //   VisitStarted(
                                            //       visitId: estateState.results.id,
                                            //       token: userToken,
                                            //       visitType: VisitType.officeCall),
                                            // );
                                            await myCupertinoActionSheet(
                                              context,
                                              elementsList: [
                                                "ghina",
                                                "sharaf",
                                              ],
                                              onPressed: [
                                                () {},
                                                () {},
                                              ],
                                            );
                                            // launch(
                                            //   "tel://" + estateState.results.mobile!,
                                            // );
                                          },
                                          child:
                                              const Icon(Icons.phone_outlined),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            // _visitBloc.add(
                                            //   VisitStarted(
                                            //       visitId: estateState.results.id,
                                            //       token: userToken,
                                            //       visitType: VisitType.officeCall),
                                            // );
                                            // launch(
                                            //   "tel://" + estateState.results.mobile!,
                                            // );
                                          },
                                          child: const Icon(
                                              Icons.facebook_rounded),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            // _visitBloc.add(
                                            //   VisitStarted(
                                            //       visitId: estateState.results.id,
                                            //       token: userToken,
                                            //       visitType: VisitType.officeCall),
                                            // );
                                            await myCupertinoActionSheet(
                                              context,
                                              elementsList: [
                                                "ghina",
                                                "sharaf",
                                              ],
                                              onPressed: [
                                                () {
                                                  launch(
                                                    "tel://" +
                                                        estateState
                                                            .results.mobile!,
                                                  );
                                                },
                                                () {
                                                  launch(
                                                    "tel://" +
                                                        estateState
                                                            .results.mobile!,
                                                  );
                                                },
                                              ],
                                            );
                                          },
                                          child: const Icon(
                                              Icons.whatsapp_outlined),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        8.verticalSpace,
                        // Account name and rate :
                        kHe12,
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
                            child: const Text(
                              "9:00 AM - 5:00 PM",
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
                                                    estateState.results.id),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .post_estate,
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
                                              isLike: estateState
                                                  .results.isLiked!));
                                    } else if (likeAndUnlikeState is Liked) {
                                      estateState.results.isLiked = true;
                                    } else if (likeAndUnlikeState is Unliked) {
                                      estateState.results.isLiked = false;
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
                                                    estateState.results.id,
                                                likeType:
                                                    LikeType.estateOffice),
                                          );
                                        }
                                        if (likeAndUnlikeState is Unliked) {
                                          _likeAndUnlikeBloc.add(
                                            LikeStarted(
                                                token: userToken,
                                                likedObjectId:
                                                    estateState.results.id,
                                                likeType:
                                                    LikeType.estateOffice),
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
                                                Icon((likeAndUnlikeState
                                                        is Liked)
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
                          child: Text(
                            AppLocalizations.of(context)!.estate_offers + " :",
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: AppColors.black,
                                    ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                kHe24,
                BlocConsumer<EstateBloc, EstateState>(
                  bloc: _estateBloc,
                  listener: (_, estateState) async {
                    if (estateState is EstateFetchError) {
                      var error = estateState.isConnectionError
                          ? AppLocalizations.of(context)!.no_internet_connection
                          : estateState.errorMessage;
                      await showWonderfulAlertDialog(
                          context, AppLocalizations.of(context)!.error, error);
                    }
                  },
                  builder: (_, estateState) {
                    if (estateState is EstateFetchProgress) {
                      return const PropertyShimmer();
                    }
                    if (estateState is! EstateFetchComplete) {
                      return FetchResult(
                        content: AppLocalizations.of(context)!
                            .error_happened_when_executing_operation,
                        iconSize: 0.25.sw,
                      );
                    }

                    List<Estate> estates = estateState.estates;
                    Iterable<Estate> newStates = estates.reversed;
                    if (newStates.isEmpty) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 60.h,
                        ),
                        width: 1.sw,
                        child: Text(
                          AppLocalizations.of(context)!.office_have_not_estates,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newStates.length,
                      itemBuilder: (_, index) {
                        return EstateCard(
                          color: Theme.of(context).colorScheme.background,
                          estate: newStates.elementAt(index),
                          onClosePressed: () {
                            showReportModalBottomSheet(
                                context, estates.elementAt(index).id);
                          },
                          removeCloseButton: false,
                          //removeCloseButton: true,
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
