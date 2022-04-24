import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/enums.dart';
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
                    radius: 96.w,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(imagesBaseUrl + widget.office.logo!),
                  ),
                ),
                24.verticalSpace,
                // Account name and rate :
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: RateContainer(
                        rate: double.parse(
                          widget.office.rating.toString(),
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      widget.office.name!,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
                12.verticalSpace,
                Text(
                  widget.office.location!.getLocationName(),
                  style: Theme.of(context).textTheme.headline5,
                ),
                kHe12,
                Text(
                  widget.office.mobile!,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                kHe32,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(180.w, 64.h)),
                      onPressed: () async {
                        if (BlocProvider.of<UserLoginBloc>(context).user == null) {
                          await buildSignInRequiredDialog();
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add),
                          Text(
                            AppLocalizations.of(context)!.post_estate,
                          )
                        ],
                      ),
                    ),
                    kWi16,
                    BlocConsumer<LikeAndUnlikeBloc, LikeAndUnlikeState>(
                      bloc: _likeAndUnlikeBloc,
                      listener: (_, likeAndUnlikeState) async{
                        if (likeAndUnlikeState is LikeAndUnlikeError) {

                          var error = likeAndUnlikeState.isConnectionError
                              ? AppLocalizations.of(context)!.no_internet_connection
                              : likeAndUnlikeState.error;
                          await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);
                          _likeAndUnlikeBloc
                              .add(ReInitializeLikeState(isLike: widget.office.isLiked));
                        } else if (likeAndUnlikeState is Liked) {
                          widget.office.isLiked = true;
                        } else if (likeAndUnlikeState is Unliked) {
                          widget.office.isLiked = false;
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
                          child: (likeAndUnlikeState is LikeAndUnlikeProgress)
                              ? SpinKitWave(
                                  color: AppColors.white,
                                  size: 16.w,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon((likeAndUnlikeState is Liked)
                                        ? Icons.thumb_up_alt
                                        : Icons.thumb_up_alt_outlined),
                                    kWi12,
                                    Text(
                                      (likeAndUnlikeState is Liked)
                                          ? AppLocalizations.of(context)!.liked
                                          : AppLocalizations.of(context)!.like,
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
                  height: 32.h,
                  width: 1.sw,
                  color: isDark
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    right: isArabic ? 8.w : 0,
                    left: !isArabic ? 8.w : 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.estate_offers + " :",
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: AppColors.black,
                        ),
                  ),
                ),
                kHe24,
                BlocConsumer<EstateBloc, EstateState>(
                  bloc: _estateBloc,
                  listener: (_, estateState)async {
                    if (estateState is EstateFetchError) {

                      var error = estateState.isConnectionError
                          ? AppLocalizations.of(context)!.no_internet_connection
                          : estateState.errorMessage;
                      await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);

                    }
                  },
                  builder: (_, estateState) {
                    if (estateState is EstateFetchProgress) {
                      return const PropertyShimmer();
                    }
                    if (estateState is! EstateFetchComplete) {
                      return FetchResult(
                        content:
                            AppLocalizations.of(context)!.error_happened_when_executing_operation,
                        iconSize: 0.25.sw,
                      );
                    }

                    List<Estate> estates = estateState.estates;

                    if (estates.isEmpty) {
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
                      itemCount: estates.length,
                      itemBuilder: (_, index) {
                        return EstateCard(
                          estate: estates.elementAt(index),
                          removeCloseButton: true,
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
