import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
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
  bool isSell = true;
  bool isLands = true;

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

    if(widget.estate.estateType !=null || widget.estate.estateOfferType != null) {
      isSell = widget.estate.estateOfferType!.id == sellOfferTypeNumber;
      isLands = widget.estate.estateType!.id == landsPropertyTypeNumber;
    }
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
              borderRadius: lowBorderRadius,
            ),
            child: SizedBox(
              // height: 150.h,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: ClipRRect(
                        borderRadius: lowBorderRadius,
                        child: Container(
                          width: 1.sw * (65 / 100),
                          height: 150.h,
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
                          left: isArabic ? 0 : 5.w,
                          right: !isArabic ? 0 : 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: ResText(widget.estate.locationS!,
                                  maxLines: 2,
                                    textAlign: TextAlign.start,
                                    textStyle: Theme.of(context).textTheme.headline3!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                if (isSell)
                                  RowInformation(
                                    title: AppLocalizations.of(context)!.ownership_type + " :",
                                    content:  widget.estate.ownershipType == null ? "" : widget.estate.ownershipType!.name,
                                    onTap: () {},
                                  ),
                                // Estate interior status :
                                if (!isLands)
                                  RowInformation(
                                    title: "${AppLocalizations.of(context)!.interior_status} :",
                                    content: widget.estate.interiorStatus!.name,
                                    onTap: () {},
                                  ),
                                RowInformation(
                                  title: "${AppLocalizations.of(context)!.estate_area} :",
                                  widgetContent: Row(
                                    children: [
                                      ResText(
                                        widget.estate.area!,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10.sp),
                                      ),
                                      5.horizontalSpace,
                                      widget.estate.areaUnit == null ? const Center() :
                                      ResText(
                                        widget.estate.areaUnit!.name,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                                if (widget.estate.publishedAt != null)
                                RowInformation(
                                  title: "${AppLocalizations.of(context)!.adding_date} :",
                                  content: DateHelper.getDateByFormat(
                                      DateTime.parse(
                                        widget.estate.publishedAt.toString(),
                                      ),
                                      "yyyy/MM/dd"),

                                  onTap: () {},
                                ),
                                (BlocProvider.of<UserLoginBloc>(context).user == null) ?
                                Row(
                                  children: [
                                    Center(
                                      child: TextButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(80.w, 25.h),
                                          maximumSize: Size(80.w, 25.h),
                                          backgroundColor: AppColors.primaryColor
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!.sign_in,
                                            style: const TextStyle(fontSize: 10,color: AppColors.white),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await Navigator.pushNamed(context, AuthenticationScreen.id);
                                        },
                                      ),
                                    ),
                                    ResText(
                                      " ${AppLocalizations.of(context)!.first} ${AppLocalizations.of(context)!.get_price}",
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
                                RowInformation(
                                  title: "${AppLocalizations.of(context)!.estate_price} :",
                                  content: NumbersHelper.getMoneyFormat(intPrice) +
                                      " " +
                                      (isForStore
                                          ? "L.L"
                                          : AppLocalizations.of(context)!
                                          .syrian_bound),

                                  onTap: () {},
                                ),
                                // ResText(
                                //   "${widget.estate.estateType!.name.split("|").first}"
                                //   " ${isArabic ? "لل" : "for "}"
                                //   "${widget.estate.estateOfferType!.name.split("|").first}"
                                //   "${(widget.estate.periodType == null) ? " " : "/ ${widget.estate.periodType!.name}"}",
                                //   textStyle: Theme.of(context)
                                //       .textTheme
                                //       .headline3!
                                //       .copyWith(
                                //           fontWeight: FontWeight.w600,
                                //           fontSize: 12.sp),
                                // ),
                                // widget.estate.description == null ? const Center():
                                // ResText(
                                //    widget.estate.description!,
                                //   textAlign: TextAlign.start,
                                //   maxLines: 2,
                                //   minFontSize: 10,
                                //   textStyle:
                                //   Theme.of(context).textTheme.headline4,
                                // ),
                              ],
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

class RowInformation extends StatelessWidget {
  final Function() onTap;

  final String title;

  final String? content;

  final Widget? widgetContent;


  final bool withBottomDivider;

  const RowInformation({
    Key? key,
    required this.onTap,
    required this.title,
    this.widgetContent,
    this.withBottomDivider = true,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResText(
                    title,
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp),
                  ),
                  5.horizontalSpace,
                  (widgetContent != null)
                      ? widgetContent!
                      : Expanded(
                    child: ResText(
                      content ?? "",
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp),
                      textAlign: TextAlign.start,
                      maxLines: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
