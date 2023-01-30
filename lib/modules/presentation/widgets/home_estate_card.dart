import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/assets_paths.dart';
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
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(0, 4),
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: Container(
                height: 200,
                width: 262,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: AppColors.white,
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: widget.estate.images!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imagesBaseUrl + widget.estate.images![1].url,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(swessHomeIconPath),
              ),
            ),
            Container(
              width: 262,
              padding: kSmallSymWidth,
              child: Column(
                children: [
                  kHe12,
                  Row(
                    children: [
                      Text(
                        "${widget.estate.estateType!.name.split("|")[1]} "
                        "${widget.estate.estateOfferType!.name}"
                        "${(widget.estate.periodType == null) ? " " : "/ ${widget.estate.periodType!.name}"}",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 25),
                      ),
                    ],
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(widget.estate.locationS!),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                DateHelper.getDateByFormat(
                                    DateTime.parse(widget.estate.publishedAt!),
                                    "yyyy/MM/dd"),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: AppColors.lastColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  kHe20,
                  SizedBox(
                    width: 240,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            NumbersHelper.getMoneyFormat(intPrice) +
                                " " +
                                AppLocalizations.of(context)!.syrian_bound,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        BlocConsumer<LikeAndUnlikeBloc, LikeAndUnlikeState>(
                          bloc: _likeAndUnlikeBloc,
                          listener: (_, likeAndUnlikeState) async {
                            if (likeAndUnlikeState is LikeAndUnlikeError) {
                              var error = likeAndUnlikeState.isConnectionError
                                  ? AppLocalizations.of(context)!
                                      .no_internet_connection
                                  : likeAndUnlikeState.error;
                              await showWonderfulAlertDialog(context,
                                  AppLocalizations.of(context)!.error, error);
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
                              height: 45,
                              width: 45,
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
                                              userToken = UserSharedPreferences
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
                                        size: 27,
                                        color: AppColors.white,
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
