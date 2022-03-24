import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/report.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/data/repositories/reports_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'package:swesshome/utils/helpers/show_my_snack_bar.dart';

class EstatesScreen extends StatefulWidget {
  static const String id = "EstatesScreen";

  final EstateEvent searchData;

  const EstatesScreen({Key? key, required this.searchData}) : super(key: key);

  @override
  _EstatesScreenState createState() => _EstatesScreenState();
}

class _EstatesScreenState extends State<EstatesScreen> {
  final List<Estate> estates = [];
  final ScrollController _scrollController = ScrollController();
  bool isEstatesFinished = false;
  String? userToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEstatesFinished = false;
    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      userToken = BlocProvider.of<UserLoginBloc>(context).user!.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryColor,
          toolbarHeight: Res.height(75),
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: AppColors.white,
                ),
                onPressed: () {
                  // TODO : Process this state
                },
              ),
              kWi4,
              IconButton(
                icon: const Icon(
                  Icons.public,
                  color: AppColors.white,
                ),
                onPressed: () {
                  // TODO : Process this state
                },
              ),
              const Spacer(),
              ResText(
                "نتائج البحث",
                textStyle: textStyling(
                  S.s20,
                  W.w5,
                  C.wh,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Res.width(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: Res.width(4)),
          child: BlocProvider<EstateBloc>(
            create: (_) => EstateBloc(
              EstateRepository(),
            )..add(widget.searchData),
            child: BlocConsumer<EstateBloc, EstateState>(
              listener: (_, estateFetchState) {
                if (estateFetchState is EstateFetchComplete) {
                  if (estateFetchState.estates.isEmpty && estates.isNotEmpty) {
                    if (!isEstatesFinished) {
                      showMySnackBar(context, "! انتهت النتائج المطابقة لبحثك");
                    }
                    isEstatesFinished = true;
                  }
                }
                if (estateFetchState is EstateFetchError) {
                  showWonderfulAlertDialog(context, "خطأ", estateFetchState.errorMessage);
                }
              },
              builder: (context, estatesFetchState) {
                if (estatesFetchState is EstateFetchNone ||
                    (estatesFetchState is EstateFetchProgress && estates.isEmpty)) {
                  return const EstatesShimmer();
                } else if (estatesFetchState is EstateFetchComplete) {
                  estates.addAll(estatesFetchState.estates);
                  BlocProvider.of<EstateBloc>(context).isFetching = false;
                } else if (estatesFetchState is EstateFetchError && estates.isEmpty) {
                  BlocProvider.of<EstateBloc>(context).isFetching = false;
                  return RefreshIndicator(
                    color: AppColors.secondaryColor,
                    onRefresh: () async {
                      BlocProvider.of<EstateBloc>(context).add(widget.searchData);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                          width: screenWidth,
                          height: screenHeight - Res.height(75),
                          child: const FetchResult(content: "حدث خطأ أثناء تنفيذ العملية")),
                    ),
                  );
                }

                if (estates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.secondaryColor.withOpacity(0.24),
                          size: 120,
                        ),
                        kHe24,
                        ResText(
                          "! عذرا, لا يوجد عقارات مناسبة لبحثك",
                          textStyle: textStyling(S.s18, W.w6, C.bl),
                        ),
                        kHe12,
                        ResText(
                          "قم بتغيير فلتر البحث ثم حاول مجدداً",
                          textStyle: textStyling(S.s14, W.w5, C.bl),
                        ),
                        kHe40,
                        MyButton(
                          color: AppColors.secondaryColor,
                          width: Res.width(200),
                          child: ResText(
                            "ابحث مجدداً",
                            textStyle: textStyling(S.s18, W.w6, C.wh),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  controller: _scrollController
                    ..addListener(
                      () {
                        if (_scrollController.offset ==
                                _scrollController.position.maxScrollExtent &&
                            !BlocProvider.of<EstateBloc>(context).isFetching &&
                            !isEstatesFinished) {
                          BlocProvider.of<EstateBloc>(context)
                            ..isFetching = true
                            ..add(widget.searchData);
                        }
                      },
                    ),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: estates.length,
                        itemBuilder: (_, index) {
                          return EstateCard(
                            estate: estates.elementAt(index),
                            onClosePressed: () {
                              showReportModalBottomSheet(estates.elementAt(index).id);
                            },
                          );
                        },
                      ),
                      if (BlocProvider.of<EstateBloc>(context).isFetching)
                        Container(
                          margin: EdgeInsets.only(
                            top: Res.height(12),
                          ),
                          child: const SpinKitWave(
                            color: AppColors.secondaryColor,
                            size: 50,
                          ),
                        ),
                      if (isEstatesFinished)
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: Res.height(50),
                          ),
                          width: screenWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              kWi16,
                              const Expanded(
                                flex: 2,
                                child: Divider(
                                  color: AppColors.secondaryColor,
                                  thickness: 1,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: ResText(
                                  "انتهت النتائج",
                                  textAlign: TextAlign.center,
                                  textStyle: textStyling(S.s18, W.w5, C.bl),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Divider(
                                  color: AppColors.secondaryColor,
                                  thickness: 1,
                                ),
                              ),
                              kWi16,
                            ],
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showReportModalBottomSheet(int estateId) {
    List<Report> reports = BlocProvider.of<ReportBloc>(context).reports!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
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
                  width: screenWidth,
                  child: ResText(
                    "ما الذي تراه غير مناسب في هذا العقار؟",
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
                      ReportsRepository reportRepository = ReportsRepository();
                      if (await reportRepository.sendReport(
                          userToken, reports.elementAt(index).id, estateId)) {
                        Fluttertoast.showToast(msg: "تم إرسال الإبلاغ");
                      } else {
                        Fluttertoast.showToast(msg: "حدث خطأ أثناء إرسال البلاغ!");
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: Res.width(8)),
                      width: screenWidth,
                      height: Res.height(52),
                      child: ResText(
                        reports.elementAt(index).getName(true),
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
}
