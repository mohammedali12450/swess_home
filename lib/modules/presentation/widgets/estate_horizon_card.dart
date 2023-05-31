import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/api_paths.dart';
import '../../../constants/colors.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_bloc.dart';
import '../../business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_event.dart';
import '../../business_logic_components/bloc/save_and_un_save_estate_bloc/save_and_un_save_estate_state.dart';
import '../../business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/estate_repository.dart';
import '../screens/estate_details_screen.dart';

class EstateHorizonCard extends StatefulWidget {
  final Estate estate;
  final Function? onClosePressed;
  final bool closeButton;
  final Color? color;

  const EstateHorizonCard(
      {Key? key,
      required this.estate,
      this.onClosePressed,
      required this.closeButton,
      this.color})
      : super(key: key);

  @override
  State<EstateHorizonCard> createState() => _EstateHorizonCardState();
}

class _EstateHorizonCardState extends State<EstateHorizonCard> {
  late String? userToken;
  late bool isArabic;
  late bool isForStore;
  late SaveAndUnSaveEstateBloc _saveAndUnSaveEstateBloc;

  @override
  void initState() {
    userToken = UserSharedPreferences.getAccessToken();
    _saveAndUnSaveEstateBloc = SaveAndUnSaveEstateBloc(
      (widget.estate.isSaved!) ? EstateSaved() : EstateUnSaved(),
      EstateRepository(),
    );
    isForStore = BlocProvider.of<SystemVariablesBloc>(context)
        .systemVariables!
        .isForStore;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    int intPrice = int.tryParse(widget.estate.price!)!;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EstateDetailsScreen(estate: widget.estate,),
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            elevation: 8,
            color: widget.color ?? Theme.of(context).colorScheme.background,
            shape: const RoundedRectangleBorder(
              borderRadius: smallBorderRadius,
            ),
            child: SizedBox(
              height: 140.h,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: ClipRRect(
                        borderRadius: smallBorderRadius,
                        child: Container(
                          width: 1.sw * (65 / 100),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.white,
                            ),
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: widget.estate.images!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: imagesBaseUrl +
                                      widget.estate.images![0].url,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(swessHomeIconPath),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: isArabic ? 0 : 16.w,
                          right: !isArabic ? 0 : 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResText(
                                  "${widget.estate.estateType!.name.split("|").first}"
                                  " ${isArabic ? "لل" : "for "}"
                                  "${widget.estate.estateOfferType!.name.split("|").first}"
                                  "${(widget.estate.periodType == null) ? " " : "/ ${widget.estate.periodType!.name}"}",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 23.sp),
                                ),
                                ResText(
                                  widget.estate.locationS!,
                                  textStyle:
                                      Theme.of(context).textTheme.headline5,
                                ),
                                widget.estate.description == null ? const Center():
                                ResText(
                                   widget.estate.description!,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  minFontSize: 10,
                                  textStyle:
                                  Theme.of(context).textTheme.headline4,
                                ),
                              ],
                            ),
                          ),
                          (BlocProvider.of<UserLoginBloc>(context).user == null) ?
                          Row(
                            children: [
                              InkWell(
                                onTap: () async{
                                  await Navigator.pushNamed(context, AuthenticationScreen.id);
                                },
                                child: ResText(
                                  AppLocalizations.of(context)!.sign_in,
                                  textAlign: TextAlign.start,
                                  textStyle: GoogleFonts.libreFranklin(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                              ResText(
                                " " +  AppLocalizations.of(context)!.first + " " +  AppLocalizations.of(context)!.get_price,
                                textAlign: TextAlign.start,
                                textStyle: GoogleFonts.libreFranklin(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    height: 1.3.h
                                ),
                              ),
                            ],
                          ) :
                          ResText(
                            NumbersHelper.getMoneyFormat(intPrice) +
                                " " +
                                (isForStore
                                    ? "L.L"
                                    : AppLocalizations.of(context)!
                                        .syrian_bound),
                            textStyle: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
            child: !widget.closeButton
                ? BlocConsumer<SaveAndUnSaveEstateBloc,
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
                      return IconButton(
                        onPressed: () {
                          if (saveAndUnSaveState is EstateSaved) {
                            _saveAndUnSaveEstateBloc.add(UnSaveEventStarted(
                                token: userToken, estateId: widget.estate.id!));
                          }
                          if (saveAndUnSaveState is EstateUnSaved) {
                            _saveAndUnSaveEstateBloc.add(EstateSaveStarted(
                                token: userToken, estateId: widget.estate.id!));
                          }
                        },
                        icon: (saveAndUnSaveState
                                is EstateSaveAndUnSaveProgress)
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
                  )
                : Padding(
                  padding: kTinyAllPadding,
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
                        icon: Icon(
                          Icons.close,
                          size: 22.w,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          if (widget.onClosePressed != null) {
                            widget.onClosePressed!();
                          }
                        },
                      ),
                    ),
                ),
          ),
        ],
      ),
    );
  }
}
