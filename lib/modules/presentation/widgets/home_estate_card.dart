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
import '../../business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_bloc.dart';
import '../../business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_event.dart';
import '../../business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_state.dart';
import '../../data/models/estate.dart';
import '../../data/providers/locale_provider.dart';
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
  late SaveAndUnSaveEstateBloc _saveAndUnSaveEstateBloc;
  String? userToken;
  late bool isArabic;
  late bool isDark;

  @override
  void initState() {
    super.initState();

    _saveAndUnSaveEstateBloc = SaveAndUnSaveEstateBloc(
      (widget.estate.isSaved!) ? EstateSaved() : EstateUnSaved(),
      EstateRepository(),
    );

    if (UserSharedPreferences.getAccessToken() != null) {
      userToken = UserSharedPreferences.getAccessToken()!;
    }
  }

  @override
  Widget build(BuildContext context) {
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    int intPrice = int.tryParse(widget.estate.price!)!;
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
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
              offset: const Offset(0, 2),
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
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
                      child: widget.estate.firstImage!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl:
                                  imagesBaseUrl + widget.estate.firstImage!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(swessHomeIconPath),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: BlocConsumer<SaveAndUnSaveEstateBloc,
                        SaveAndUnSaveEstateState>(
                      bloc: _saveAndUnSaveEstateBloc,
                      listener: (_, saveAndUnSaveState) async {
                        if (saveAndUnSaveState is EstateSaveAndUnSaveError) {
                          var error = saveAndUnSaveState.isConnectionError
                              ? AppLocalizations.of(context)!
                                  .no_internet_connection
                              : saveAndUnSaveState.error;
                          await showWonderfulAlertDialog(context,
                              AppLocalizations.of(context)!.error, error);
                          _saveAndUnSaveEstateBloc.add(
                            ReInitializeSaveState(
                                isSaved: widget.estate.isSaved!),
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
                        return SizedBox(
                          height: 35.h,
                          width: 35.w,
                          child: FloatingActionButton(
                            heroTag: widget.estate.id.toString(),
                            elevation: 5,
                            backgroundColor: AppColors.white,
                            shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            onPressed: () {
                              if (userToken == null) {
                                showWonderfulAlertDialog(
                                  context,
                                  AppLocalizations.of(context)!.confirmation,
                                  AppLocalizations.of(context)!
                                      .this_features_require_login,
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
                              if (saveAndUnSaveState is EstateSaved) {
                                _saveAndUnSaveEstateBloc.add(UnSaveEventStarted(
                                    token: userToken,
                                    estateId: widget.estate.id!));
                              }
                              if (saveAndUnSaveState is EstateUnSaved) {
                                _saveAndUnSaveEstateBloc.add(EstateSaveStarted(
                                    token: userToken,
                                    estateId: widget.estate.id!));
                              }
                            },
                            child: (saveAndUnSaveState
                                    is EstateSaveAndUnSaveProgress)
                                ? SpinKitWave(
                                    color: AppColors.primaryColor,
                                    size: 16.w,
                                  )
                                : Icon(
                                    (saveAndUnSaveState is EstateSaved)
                                        ? Icons.bookmark
                                        : Icons.bookmark_border_outlined,
                                    color: AppColors.primaryColor,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                            "${widget.estate.estateTypeName!}"
                            " ${isArabic ? "لل" : "for "}"
                            "${widget.estate.estateOfferTypeName}"
                            "${(widget.estate.periodTypeName!.isEmpty) ? " " : "/ ${widget.estate.periodTypeName!}"}",
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
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                ResText(
                                  widget.estate.area! +
                                      " " +
                                      widget.estate.areaUnitName!,
                                  textStyle:
                                      Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ),
                          if (widget.estate.periodType == null)
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  ResText(
                                    widget.estate.ownershipTypeName!,
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
