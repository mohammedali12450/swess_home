import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

import '../../../constants/design_constants.dart';
import '../../../core/functions/app_theme_information.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/reports_bloc/reports_bloc.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import '../../data/models/report.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/reports_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/authentication_screen.dart';

void showReportModalBottomSheet(context, int estateId) {
  List<Report> reports = BlocProvider.of<ReportBloc>(context).reports!;
  bool isDark =
      Provider.of<ThemeProvider>(context, listen: false).isDarkMode(context);
  String? userToken;
  if (BlocProvider.of<UserLoginBloc>(context).user != null) {
    userToken = UserSharedPreferences.getAccessToken();
  }
  TextEditingController reportController = TextEditingController();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(16), topLeft: Radius.circular(16)),
    ),
    backgroundColor: isDark ? AppColors.secondaryDark : Colors.white,
    builder: (_) {
      return Container(
        padding: kLargeSymHeight,
        // height: Res.height(350),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 1.sw,
                child: ResText(
                  AppLocalizations.of(context)!.report_estate,
                  textAlign: TextAlign.right,
                  textStyle: textStyling(S.s20, W.w6, isDark ? C.c1 : C.bl),
                ),
              ),
              kHe32,
              ListView.separated(
                itemCount: reports.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) => InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    index != 4
                        ? showWonderfulAlertDialog(
                            context,
                            AppLocalizations.of(context)!.caution,
                            AppLocalizations.of(context)!.question_reporting,
                            titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 20.sp),
                            removeDefaultButton: true,
                            dialogButtons: [
                                ElevatedButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.yes,
                                  ),
                                  onPressed: () async {
                                    if (userToken != null) {
                                      ReportsRepository reportRepository =
                                          ReportsRepository();
                                      if (await reportRepository.sendReport(
                                          userToken,
                                          reports.elementAt(index).id,
                                          estateId,
                                          null)) {
                                        Fluttertoast.showToast(
                                            msg: AppLocalizations.of(context)!
                                                .send_report);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: AppLocalizations.of(context)!
                                                .error_send_report);
                                      }
                                    } else {
                                      await showWonderfulAlertDialog(
                                          context,
                                          AppLocalizations.of(context)!
                                              .confirmation,
                                          AppLocalizations.of(context)!
                                              .this_features_require_login,
                                          removeDefaultButton: true,
                                          dialogButtons: [
                                            ElevatedButton(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .sign_in,
                                              ),
                                              onPressed: () async {
                                                await Navigator.pushNamed(
                                                    context,
                                                    AuthenticationScreen.id);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ElevatedButton(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                          width: 400.w);
                                    }
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
                              ])
                        : showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  elevation: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16.h, horizontal: 12.w),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.caution,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              fontSize: 20.sp),
                                        ),
                                        24.verticalSpace,
                                        Wrap(
                                            alignment: WrapAlignment.center,
                                            direction: Axis.horizontal,
                                            spacing: 12.h,
                                            runSpacing: 12.w,
                                            children: [
                                              Container(
                                                width: inf,
                                                padding: kSmallSymWidth,
                                                height: 150.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: TextField(
                                                  maxLength: 200,
                                                  controller: reportController,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    hintText: AppLocalizations
                                                            .of(context)!
                                                        .report_create_notes_descriptions,
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              ),
                                              ElevatedButton(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .send,
                                                ),
                                                onPressed: () async {
                                                  if (userToken != null) {
                                                    ReportsRepository
                                                        reportRepository =
                                                        ReportsRepository();
                                                    if (await reportRepository
                                                        .sendReport(
                                                            userToken,
                                                            reports
                                                                .elementAt(
                                                                    index)
                                                                .id,
                                                            estateId,
                                                            reportController
                                                                .text)) {
                                                      Fluttertoast.showToast(
                                                          msg: AppLocalizations
                                                                  .of(context)!
                                                              .send_report);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: AppLocalizations
                                                                  .of(context)!
                                                              .error_send_report);
                                                    }
                                                  } else {
                                                    await showWonderfulAlertDialog(
                                                        context,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .confirmation,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .this_features_require_login,
                                                        removeDefaultButton:
                                                            true,
                                                        dialogButtons: [
                                                          ElevatedButton(
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .sign_in,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await Navigator
                                                                  .pushNamed(
                                                                      context,
                                                                      AuthenticationScreen
                                                                          .id);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          ElevatedButton(
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .cancel,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                        width: 400.w);
                                                  }
                                                },
                                              ),
                                              ElevatedButton(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .cancel,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                                ));
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 8.w),
                    width: 1.sw,
                    height: 52.h,
                    child: ResText(
                      reports.elementAt(index).name,
                      textAlign: TextAlign.right,
                      textStyle: textStyling(S.s15, W.w5, isDark ? C.c1 : C.bl),
                    ),
                  ),
                ),
                separatorBuilder: (_, __) {
                  return const Divider();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
