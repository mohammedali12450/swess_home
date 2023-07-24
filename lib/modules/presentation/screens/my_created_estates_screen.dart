import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/screens/create_property_screens/create_property_introduction_screen.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/will-pop-scope.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/delete_user_new_estate_bloc/delete_user_new_estate_bloc.dart';
import '../../business_logic_components/bloc/delete_user_new_estate_bloc/delete_user_new_estate_event.dart';
import '../../business_logic_components/cubits/notifications_cubit.dart';
import '../../data/providers/theme_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/estate_horizon_card.dart';

class CreatedEstatesScreen extends StatefulWidget {
  static const String id = "CreatedEstatesScreen";

  final String? estateId;

  const CreatedEstatesScreen({Key? key, this.estateId}) : super(key: key);

  @override
  _CreatedEstatesScreenState createState() => _CreatedEstatesScreenState();
}

class _CreatedEstatesScreenState extends State<CreatedEstatesScreen>
    with TickerProviderStateMixin {
  late CreatedEstatesBloc _createdEstatesBloc;
  DeleteUserNewEstateBloc deleteUserNewEstateBloc =
      DeleteUserNewEstateBloc(EstateRepository());
  late ItemScrollController scrollController;
  late ItemPositionsListener itemPositionsListener;
  late AnimationController _animationController;
  late Animation _colorTween;
  List<Estate> estates = [];
  late bool isDark;

  /// added now
  OfficeDetails? results;

  @override
  void initState() {
    super.initState();
    _createdEstatesBloc = CreatedEstatesBloc(EstateRepository());
    _onRefresh();

    scrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
  }

  @override
  void dispose() {
    if (widget.estateId != null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  initAnimation(context) {
    bool isDark =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode(context);

    if (widget.estateId != null) {
      _animationController = AnimationController(
          vsync: this, duration: const Duration(seconds: 1));
      _colorTween = ColorTween(
              begin: AppColors.primaryDark,
              end: isDark ? AppColors.secondaryDark : AppColors.white)
          .animate(_animationController);
      changeColors();
    }
  }

  Future changeColors() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2), () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      });
      break;
    }
  }

  _onRefresh() {
    if (UserSharedPreferences.getAccessToken() != null) {
      _createdEstatesBloc.add(
        CreatedEstatesFetchStarted(
            token: UserSharedPreferences.getAccessToken()!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    if (widget.estateId != null) {
      initAnimation(context);
    }
    return SafeArea(
      child: BackHomeScreen(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(46.0),
            child: AppBar(
              iconTheme:
              IconThemeData(color: isDark ? Colors.white : AppColors.black),
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.recent_created_estates,
                style:
                TextStyle(color: isDark ? Colors.white : AppColors.black),
              ),
              backgroundColor:
              isDark ? const Color(0xff26282B) : AppColors.white,

                estates = createdEstatesFetchState.createdEstates;

                if (estates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 0.3.sw,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        kHe24,
                        Text(
                          AppLocalizations.of(context)!
                              .have_not_created_estates,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        kHe24,
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(180.w, 50.h),
                              maximumSize: Size(200.w, 50.h),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.post_estate,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreatePropertyIntroductionScreen(
                                              officeId: estates[0]
                                                  .estateOffice!
                                                  .id)));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                bool find = false;
                if (widget.estateId != null) {
                  for (int i = 0; i < estates.length; i++) {
                    if (estates.elementAt(i).id ==
                        int.parse(widget.estateId!)) {
                      find = true;
                      break;
                    }
                  }

                  if (find) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      jumpToOrder(estates);
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.delete_estate_order);
                  }
                }

                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  onRefresh: () async {
                    _onRefresh();
                  },
                  child: ScrollablePositionedList.builder(
                    itemScrollController: scrollController,
                    itemPositionsListener: itemPositionsListener,
                    physics: const ClampingScrollPhysics(),
                    // shrinkWrap: true,
                    itemCount: estates.length,
                    itemBuilder: (_, index) {
                      int estateStatusId =
                          estates.elementAt(index).estateStatus! == 3
                              ? 1
                              : estates.elementAt(index).estateStatus! == 1
                                  ? 3
                                  : 2;
                      return (widget.estateId != null && find)
                          ? AnimatedBuilder(
                              animation: _colorTween,
                              builder: (context, child) => Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      kHe12,
                                      EstateHorizonCard(
                                        color: (int.parse(widget.estateId!) ==
                                                estates.elementAt(index).id)
                                            ? _colorTween.value
                                            : Theme.of(context)
                                                .colorScheme
                                                .background,
                                        estate: estates.elementAt(index),
                                        onClosePressed: () async {
                                          await onClosePressed(index);
                                        },
                                        closeButton: true,
                                      ),
                                      buildEstateStatus(index),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: [
                                    kHe12,
                                    EstateHorizonCard(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      estate: estates.elementAt(index),
                                      onClosePressed: () async {
                                        await onClosePressed(index);
                                      },
                                      closeButton: true,
                                    ),
                                    buildEstateStatus(index),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //       bottom: 8.h, left: 8.w, right: 8.w),
                                    //   child: SizedBox(
                                    //       height: 70.h,
                                    //       width: getScreenWidth(context),
                                    //       child: ProcessTimelinePage(
                                    //         estateStatusId: estateStatusId,
                                    //       )),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEstateStatus(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          estates.elementAt(index).estateStatus! == 1
              ? Text(
                  AppLocalizations.of(context)!.accepted_from_company,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                )
              : estates.elementAt(index).estateStatus! == 2
                  ? Text(
                      AppLocalizations.of(context)!.rejected_from_company,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    )
                  : Text(
                      AppLocalizations.of(context)!.on_progress_from_company,
                      style: TextStyle(
                          color: AppColors.yellowDarkColor, fontSize: 12),
                    ),
          const Text(" | "),
          estates.elementAt(index).officeStatus! == 1
              ? Text(
                  AppLocalizations.of(context)!.accepted_from_office,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                )
              : estates.elementAt(index).officeStatus! == 2
                  ? Text(
                      AppLocalizations.of(context)!.rejected_from_office,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    )
                  : Text(
                      AppLocalizations.of(context)!.on_progress_from_office,
                      style: TextStyle(
                          color: AppColors.yellowDarkColor, fontSize: 12),
                    ),
        ],
      ),
    );
  }

  onClosePressed(index) async {
    showWonderfulAlertDialog(context, AppLocalizations.of(context)!.caution,
        AppLocalizations.of(context)!.confirm_delete,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20.sp),
        removeDefaultButton: true,
        dialogButtons: [
          ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.yes,
            ),
            onPressed: () async {
              Navigator.pop(context);
              deleteUserNewEstateBloc.add(DeleteUserNewEstateFetchStarted(
                  token: UserSharedPreferences.getAccessToken(),
                  orderId: estates.elementAt(index).id));
              await _onRefresh();
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
        ]);
  }

  jumpToOrder(List<Estate> estates) {
    int index = getIndexFromId(estates);
    if (index != -1) {
      if (scrollController.isAttached) {
        scrollController.scrollTo(
            index: index, duration: const Duration(milliseconds: 1000));
      }
    }
  }

  getIndexFromId(List<Estate> estates) {
    for (int i = 0; i < estates.length; i++) {
      if (estates.elementAt(i).id == int.parse(widget.estateId!)) {
        return i;
      }
    }
    return -1;
  }
}
