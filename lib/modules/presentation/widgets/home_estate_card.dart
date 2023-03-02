import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

import '../../../constants/api_paths.dart';
import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../constants/enums.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../../utils/helpers/date_helper.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_bloc.dart';
import '../../business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_event.dart';
import '../../business_logic_components/bloc/like_and_unlike_bloc/like_and_unlike_state.dart';
import '../../data/models/estate.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/estate_repository.dart';
import '../screens/authentication_screen.dart';
import '../screens/estate_details_screen.dart';

class HomeEstateCard extends StatefulWidget {
  final Estate estate;

  const HomeEstateCard({required this.estate, Key? key}) : super(key: key);

  @override
  State<HomeEstateCard> createState() => _HomeEstateCardState();
}

class _HomeEstateCardState extends State<HomeEstateCard> {
  late LikeAndUnlikeBloc _likeAndUnlikeBloc;
  String? userToken;

  @override
  void initState() {
    super.initState();

    _likeAndUnlikeBloc = LikeAndUnlikeBloc(
      (widget.estate.isLiked!) ? Liked() : Unliked(),
      EstateRepository(),
    );

    if (UserSharedPreferences.getAccessToken() != null) {
      userToken = UserSharedPreferences.getAccessToken()!;
    }
  }

  @override
  Widget build(BuildContext context) {
    int intPrice = int.tryParse(widget.estate.price!)!;
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EstateDetailsScreen(estate: widget.estate),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.white,
          ),
          color: Theme.of(context).colorScheme.background,
          borderRadius: medBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(0, 4),
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: medBorderRadius,
                child: Container(
                  width: getScreenWidth(context) * (65 / 100),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.white,
                    ),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: widget.estate.images!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl:
                              imagesBaseUrl + widget.estate.images![0].url,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(swessHomeIconPath),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: getScreenWidth(context) * (65 / 100),
                padding: kSmallSymWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kHe12,
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          ResText(
                            "${widget.estate.estateType!.name.split("|").first}"
                            " - "
                            "${widget.estate.estateOfferType!.name}"
                            "${(widget.estate.periodType == null) ? " " : "/ ${widget.estate.periodType!.name.split("|").first}"}",
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.sp),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  ResText(
                                    widget.estate.locationS!,
                                    textStyle:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  ResText(
                                    DateHelper.getDateByFormat(
                                        DateTime.parse(
                                            widget.estate.publishedAt!),
                                        "yyyy/MM/dd"),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: isDark
                                                ? AppColors.yellowDarkColor
                                                : AppColors.lastColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    kHe20,
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        width: getScreenWidth(context) * (60 / 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: ResText(
                                NumbersHelper.getMoneyFormat(intPrice) +
                                    " " +
                                    AppLocalizations.of(context)!.syrian_bound,
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            BlocConsumer<LikeAndUnlikeBloc, LikeAndUnlikeState>(
                              bloc: _likeAndUnlikeBloc,
                              listener: (_, likeAndUnlikeState) async {
                                if (likeAndUnlikeState is LikeAndUnlikeError) {
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
                                        isLike: widget.estate.isLiked!),
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
                                return SizedBox(
                                  height: 45.h,
                                  width: 45.w,
                                  child: FloatingActionButton(
                                    heroTag: widget.estate.id.toString(),
                                    elevation: 5,
                                    backgroundColor: AppColors.lastColor,
                                    onPressed: () async {
                                      if (userToken == null) {
                                        showWonderfulAlertDialog(
                                          context,
                                          AppLocalizations.of(context)!
                                              .confirmation,
                                          AppLocalizations.of(context)!
                                              .this_features_require_login,
                                          removeDefaultButton: true,
                                          width: 400.w,
                                          dialogButtons: [
                                            ElevatedButton(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ElevatedButton(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .sign_in,
                                              ),
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const AuthenticationScreen(
                                                      popAfterFinish: true,
                                                    ),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                                if (UserSharedPreferences
                                                        .getAccessToken() !=
                                                    null) {
                                                  userToken =
                                                      UserSharedPreferences
                                                          .getAccessToken();
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
                                            unlikedObjectId: widget.estate.id!,
                                            likeType: LikeType.estate,
                                          ),
                                        );
                                      }
                                      if (likeAndUnlikeState is Unliked) {
                                        _likeAndUnlikeBloc.add(
                                          LikeStarted(
                                              token: userToken,
                                              likedObjectId: widget.estate.id!,
                                              likeType: LikeType.estate),
                                        );
                                      }
                                    },
                                    child: (likeAndUnlikeState
                                            is LikeAndUnlikeProgress)
                                        ? SpinKitWave(
                                            color: AppColors.white,
                                            size: 16.w,
                                          )
                                        : Icon(
                                            (likeAndUnlikeState is Liked)
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: AppColors.white,
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
