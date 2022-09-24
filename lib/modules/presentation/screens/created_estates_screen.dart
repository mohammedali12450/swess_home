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
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/estates_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../business_logic_components/bloc/delete_user_new_estate_bloc/delete_user_new_estate_bloc.dart';
import '../../business_logic_components/bloc/delete_user_new_estate_bloc/delete_user_new_estate_event.dart';
import '../../data/providers/theme_provider.dart';

class CreatedEstatesScreen extends StatefulWidget {
  static const String id = "CreatedEstatesScreen";

  String? estateId;

  CreatedEstatesScreen({Key? key, this.estateId}) : super(key: key);

  @override
  _CreatedEstatesScreenState createState() => _CreatedEstatesScreenState();
}

class _CreatedEstatesScreenState extends State<CreatedEstatesScreen>
    with TickerProviderStateMixin {
  late CreatedEstatesBloc _createdEstatesBloc;
  DeleteUserNewEstateBloc deleteUserNewEstateBloc =
      DeleteUserNewEstateBloc(EstateRepository());
  String? userToken;
  late ItemScrollController scrollController;
  late ItemPositionsListener itemPositionsListener;
  late AnimationController _animationController;
  late Animation _colorTween;
  List<Estate> estates = [];

  @override
  void initState() {
    super.initState();
    _createdEstatesBloc = CreatedEstatesBloc(EstateRepository());
    _onRefresh();
    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null && user.token != null) {
      userToken = user.token;
      print(userToken);
    }
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
      await Future.delayed(const Duration(milliseconds: 1500), () {
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
    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null && user.token != null) {
      _createdEstatesBloc.add(
        CreatedEstatesFetchStarted(
            token: BlocProvider.of<UserLoginBloc>(context).user!.token!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.estateId != null) {
      initAnimation(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.recent_created_estates,
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          _onRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: 1.sw,
            height: 1.sh - 100.h,
            child: BlocConsumer<CreatedEstatesBloc, CreatedEstatesState>(
              bloc: _createdEstatesBloc,
              listener: (_, createdEstatesFetchState) async {
                if (createdEstatesFetchState is CreatedEstatesFetchError) {
                  var error = createdEstatesFetchState.isConnectionError
                      ? AppLocalizations.of(context)!.no_internet_connection
                      : createdEstatesFetchState.error;
                  await showWonderfulAlertDialog(
                      context, AppLocalizations.of(context)!.error, error);
                }
              },
              builder: (_, createdEstatesFetchState) {
                if (createdEstatesFetchState is CreatedEstatesFetchNone) {
                  return FetchResult(
                      content: AppLocalizations.of(context)!
                          .have_not_created_estates);
                }

                if (createdEstatesFetchState is CreatedEstatesFetchProgress) {
                  return const PropertyShimmer();
                }
                if (createdEstatesFetchState is! CreatedEstatesFetchComplete) {
                  return FetchResult(
                      content: AppLocalizations.of(context)!
                          .error_happened_when_executing_operation);
                }

                estates = createdEstatesFetchState.createdEstates;

                if (estates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 0.5.sw,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.64),
                        ),
                        kHe24,
                        Text(
                          AppLocalizations.of(context)!
                              .have_not_created_estates,
                          textAlign: TextAlign.center,
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
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
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
                      return (widget.estateId != null && find)
                          ? AnimatedBuilder(
                              animation: _colorTween,
                              builder: (context, child) => EstateCard(
                                color: (int.parse(widget.estateId!) ==
                                        estates.elementAt(index).id)
                                    ? _colorTween.value
                                    : Theme.of(context).colorScheme.background,
                                estate: estates.elementAt(index),
                                onClosePressed: () async {
                                  await onClosePressed(index);
                                },
                                removeCloseButton: false,
                                removeBottomBar: true,
                              ),
                            )
                          : EstateCard(
                              color: Theme.of(context).colorScheme.background,
                              estate: estates.elementAt(index),
                              onClosePressed: () async {
                                await onClosePressed(index);
                              },
                              removeCloseButton: false,
                              removeBottomBar: true,
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

  onClosePressed(index) async {
    showWonderfulAlertDialog(context, AppLocalizations.of(context)!.caution,
        AppLocalizations.of(context)!.confirm_delete,
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
        removeDefaultButton: true,
        dialogButtons: [
          ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.yes,
            ),
            onPressed: () async {
              Navigator.pop(context);
              deleteUserNewEstateBloc.add(DeleteUserNewEstateFetchStarted(
                  token: userToken, orderId: estates.elementAt(index).id));
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
            index: index,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.bounceIn);
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
