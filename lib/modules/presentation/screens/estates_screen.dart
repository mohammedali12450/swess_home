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

import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
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

  final ChannelCubit _priceSelected = ChannelCubit(false);
  final ChannelCubit _dateSelected = ChannelCubit(true);

  EstateSearch estateSearch = EstateSearch.init();
  final List<Estate> identicalEstates = [];
  final List<Estate> similarEstates = [];
  final ScrollController _scrollController = ScrollController();
  bool isEstatesFinished = false;
  String? userToken;

  @override
  void initState() {
    super.initState();
    isEstatesFinished = false;
    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      userToken = UserSharedPreferences.getAccessToken();
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
              icon: const Icon(Icons.search),
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
                if (estateFetchState.estateSearch.identicalEstates.isEmpty &&
                    estateSearch.identicalEstates.isNotEmpty) {
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
            builder: (context, EstateState estatesFetchState) {
              if (estatesFetchState is EstateFetchNone ||
                  (estatesFetchState is EstateFetchProgress &&
                      estateSearch.identicalEstates.isEmpty)) {
                return const PropertyShimmer();
              } else if (estatesFetchState is EstateFetchComplete) {
                if (estatesFetchState
                    .estateSearch.identicalEstates.isNotEmpty) {
                  estateSearch.identicalEstates
                      .addAll(estatesFetchState.estateSearch.identicalEstates);
                }
                if (estatesFetchState.estateSearch.similarEstates.isNotEmpty) {
                  estateSearch.similarEstates
                      .addAll(estatesFetchState.estateSearch.similarEstates);
                }
                BlocProvider.of<EstateBloc>(context).isFetching = false;
              } else if (estatesFetchState is EstateFetchError &&
                  estateSearch.identicalEstates.isEmpty) {
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

              if (estateSearch.identicalEstates.isEmpty) {
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 12.w, 8.w, 7.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<ChannelCubit, dynamic>(
                                bloc: _priceSelected,
                                builder: (_, isPriceSelected) {
                                  return InkWell(
                                    onTap: () {
                                      _priceSelected.setState(!isPriceSelected);
                                      if (_dateSelected.state) {
                                        _dateSelected.setState(false);
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: isPriceSelected
                                            ? AppColors.primaryColor
                                            : AppColors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            color: AppColors.primaryColor),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .by_price,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    color: isPriceSelected
                                                        ? AppColors.white
                                                        : AppColors
                                                            .primaryColor),
                                          ),
                                          !isPriceSelected
                                              ? const Icon(
                                                  Icons.arrow_downward,
                                                  color: AppColors.primaryColor,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.arrow_upward,
                                                  color: AppColors.white,
                                                  size: 16,
                                                )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          kWi12,
                          Expanded(
                            child: BlocBuilder<ChannelCubit, dynamic>(
                                bloc: _dateSelected,
                                builder: (_, isDateSelected) {
                                  return InkWell(
                                    onTap: () {
                                      _dateSelected.setState(!isDateSelected);
                                      if (_priceSelected.state) {
                                        _priceSelected.setState(false);
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: isDateSelected
                                            ? AppColors.primaryColor
                                            : AppColors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            color: AppColors.primaryColor),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .by_date,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    color: isDateSelected
                                                        ? AppColors.white
                                                        : AppColors
                                                            .primaryColor),
                                          ),
                                          !isDateSelected
                                              ? const Icon(
                                                  Icons.arrow_downward,
                                                  color: AppColors.primaryColor,
                                                  size: 16,
                                                )
                                              : const Icon(
                                                  Icons.arrow_upward,
                                                  color: AppColors.white,
                                                  size: 16,
                                                )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.identical_estates),
                        ],
                      ),
                    ),
                    if(estateSearch.identicalEstates.isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: estateSearch.identicalEstates.length,
                      itemBuilder: (_, index) {
                        return EstateCard(
                          color: Theme.of(context).colorScheme.background,
                          estate:
                              estateSearch.identicalEstates.elementAt(index),
                          onClosePressed: () {
                            showReportModalBottomSheet(
                                context,
                                estateSearch.identicalEstates
                                    .elementAt(index)
                                    .id!);
                          },
                          removeCloseButton: false,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.similar_estates),
                        ],
                      ),
                    ),
                    if(estateSearch.similarEstates.isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: estateSearch.similarEstates.length,
                      itemBuilder: (_, index) {
                        return EstateCard(
                          color: Theme.of(context).colorScheme.background,
                          estate:
                              estateSearch.similarEstates.elementAt(index),
                          onClosePressed: () {
                            showReportModalBottomSheet(
                                context,
                                estateSearch.similarEstates
                                    .elementAt(index)
                                    .id!);
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
    estateSearch.identicalEstates.sort((a, b) {
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
