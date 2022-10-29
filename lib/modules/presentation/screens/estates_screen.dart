import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/report_estate.dart';

class EstatesScreen extends StatefulWidget {
  static const String id = "EstatesScreen";

  final EstateEvent searchData;

  const EstatesScreen({Key? key, required this.searchData}) : super(key: key);

  @override
  _EstatesScreenState createState() => _EstatesScreenState();
}

class _EstatesScreenState extends State<EstatesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Estate> estates = [];
  final ScrollController _scrollController = ScrollController();
  bool isEstatesFinished = false;
  String? userToken;

  @override
  void initState() {
    super.initState();
    isEstatesFinished = false;
    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      userToken = BlocProvider.of<UserLoginBloc>(context).user!.token;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.search_results,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: AppColors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            kWi8,
          ],
        ),
        body: BlocProvider<EstateBloc>(
          create: (_) => EstateBloc(
            EstateRepository(),
          )..add(widget.searchData),
          child: BlocConsumer<EstateBloc, EstateState>(
            listener: (_, estateFetchState) async {
              if (estateFetchState is EstateFetchComplete) {
                if (estateFetchState.estates.isEmpty && estates.isNotEmpty) {
                  isEstatesFinished = true;
                }
              }
              if (estateFetchState is EstateFetchError) {
                var error = estateFetchState.isConnectionError
                    ? AppLocalizations.of(context)!.no_internet_connection
                    : estateFetchState.errorMessage;
                await showWonderfulAlertDialog(
                    context, AppLocalizations.of(context)!.error, error);
              }
            },
            builder: (context, estatesFetchState) {
              if (estatesFetchState is EstateFetchNone ||
                  (estatesFetchState is EstateFetchProgress &&
                      estates.isEmpty)) {
                return const PropertyShimmer();
              } else if (estatesFetchState is EstateFetchComplete) {
                estates.addAll(estatesFetchState.estates);
               // sortEstateByDate();
                BlocProvider.of<EstateBloc>(context).isFetching = false;
              } else if (estatesFetchState is EstateFetchError &&
                  estates.isEmpty) {
                BlocProvider.of<EstateBloc>(context).isFetching = false;
                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  onRefresh: () async {
                    BlocProvider.of<EstateBloc>(context).add(widget.searchData);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                        width: 1.sw,
                        height: 1.sh - 75.h,
                        child: FetchResult(
                            content: AppLocalizations.of(context)!
                                .error_happened_when_executing_operation)),
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.24),
                        size: 120,
                      ),
                      kHe24,
                      Text(
                        AppLocalizations.of(context)!.no_results_body,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      kHe12,
                      Text(
                        AppLocalizations.of(context)!.no_results_hint,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      kHe40,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(220.w, 64.h),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.search_again,
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
                          color: Theme.of(context).colorScheme.background,
                          estate: estates.elementAt(index),
                          onClosePressed: () {
                            showReportModalBottomSheet(
                                context, estates.elementAt(index).id);
                          },
                          removeCloseButton: false,
                        );
                      },
                    ),
                    if (BlocProvider.of<EstateBloc>(context).isFetching)
                      Container(
                        margin: EdgeInsets.only(
                          top: 12.h,
                        ),
                        child: SpinKitWave(
                          color: Theme.of(context).colorScheme.primary,
                          size: 50,
                        ),
                      ),
                    if (isEstatesFinished)
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 50.h,
                        ),
                        width: 1.sw,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            kWi16,
                            Expanded(
                              flex: 2,
                              child: Divider(
                                color: Theme.of(context).colorScheme.primary,
                                thickness: 1,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ResText(
                                AppLocalizations.of(context)!.no_more_results,
                                textAlign: TextAlign.center,
                                textStyle: textStyling(S.s18, W.w5, C.bl),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Divider(
                                color: Theme.of(context).colorScheme.primary,
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
    );
  }

  sortEstateByDate() {
    estates.sort((a, b) {
      //sorting in descending order
      return DateTime.parse(b.createdAt!)
          .compareTo(DateTime.parse(a.createdAt!));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
