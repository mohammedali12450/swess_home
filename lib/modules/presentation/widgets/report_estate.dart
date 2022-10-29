import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

import '../../../constants/design_constants.dart';
import '../../../core/functions/app_theme_information.dart';
import '../../business_logic_components/bloc/reports_bloc/reports_bloc.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import '../../data/models/report.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/reports_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/authentication_screen.dart';

void showReportModalBottomSheet(context ,int estateId) {
  List<Report> reports = BlocProvider.of<ReportBloc>(context).reports!;
  bool isArabic =
  Provider.of<LocaleProvider>(context, listen: false).isArabic();
  String? userToken;
  if (BlocProvider.of<UserLoginBloc>(context).user != null) {
    userToken = BlocProvider.of<UserLoginBloc>(context).user!.token;
  }


  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(16), topLeft: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
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
                  textStyle: textStyling(S.s18, W.w6, C.bl),
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
                    if (userToken != null) {
                      ReportsRepository reportRepository =
                      ReportsRepository();
                      if (await reportRepository.sendReport(
                          userToken, reports.elementAt(index).id, estateId)) {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.send_report);
                      } else {
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!
                                .error_send_report);
                      }
                    } else {
                      await showWonderfulAlertDialog(
                          context,
                          AppLocalizations.of(context)!.confirmation,
                          AppLocalizations.of(context)!
                              .this_features_require_login,
                          removeDefaultButton: true,
                          dialogButtons: [
                            ElevatedButton(
                              child: Text(
                                AppLocalizations.of(context)!.sign_in,
                              ),
                              onPressed: () async {
                                await Navigator.pushNamed(
                                    context, AuthenticationScreen.id);
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
                          width: 400.w);
                    }
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 8.w),
                    width: 1.sw,
                    height: 52.h,
                    child: ResText(
                      reports.elementAt(index).getName(isArabic),
                      textAlign: TextAlign.right,
                      textStyle: textStyling(S.s15, W.w5, C.bl),
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