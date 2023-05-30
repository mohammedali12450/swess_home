import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/presentation/screens/create_order_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:swesshome/modules/presentation/widgets/estate_order_card.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/clients_orders_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_bloc.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_event.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_state.dart';
import '../../data/models/user.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../data/providers/theme_provider.dart';

class RecentEstateOrdersScreen extends StatefulWidget {
  static const String id = "RecentEstateOrdersScreen";

  final String? estateId;

  const RecentEstateOrdersScreen({Key? key, this.estateId}) : super(key: key);

  @override
  _RecentEstateOrdersScreenState createState() =>
      _RecentEstateOrdersScreenState();
}

class _RecentEstateOrdersScreenState extends State<RecentEstateOrdersScreen>
    with TickerProviderStateMixin {
  late RecentEstatesOrdersBloc _recentEstatesOrdersBloc;
  late ItemScrollController scrollController;
  late ItemPositionsListener itemPositionsListener;
  String? userToken;
  List<EstateOrder> orders = [];
  late AnimationController _animationController;
  late Animation _colorTween;

  //late Timer timer;

  @override
  void initState() {
    super.initState();
    _recentEstatesOrdersBloc = RecentEstatesOrdersBloc(EstateOrderRepository());

    User? user = BlocProvider.of<UserLoginBloc>(context).user;
    if (user != null) {
      userToken = UserSharedPreferences.getAccessToken();
    }
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
    if (userToken != null) {
      _recentEstatesOrdersBloc.add(
        RecentEstatesOrdersFetchStarted(
            token: UserSharedPreferences.getAccessToken()!),
      );
    }
  }

  initAnimation(context) {
    bool isDark =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode(context);

    if (widget.estateId != null) {
      _animationController = AnimationController(
          vsync: this, duration: const Duration(seconds: 2));
      _colorTween = ColorTween(
              begin: AppColors.primaryDark,
              end: isDark ? AppColors.secondaryDark : AppColors.white)
          .animate(_animationController);
      changeColors();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.estateId != null) {
      initAnimation(context);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.recent_created_orders,
          ),
        ),
        drawer: SizedBox(
          width: getScreenWidth(context) * (75 / 100),
          child: const Drawer(
            child: MyDrawer(),
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
              height: 1.sh - 75.h,
              child: BlocConsumer<RecentEstatesOrdersBloc,
                  RecentEstatesOrdersState>(
                bloc: _recentEstatesOrdersBloc,
                listener: (context, recentOrdersState) async {
                  if (recentOrdersState is RecentEstatesOrdersFetchError) {
                    var error = recentOrdersState.isConnectionError
                        ? AppLocalizations.of(context)!.no_internet_connection
                        : recentOrdersState.error;
                    await showWonderfulAlertDialog(
                        context, AppLocalizations.of(context)!.error, error);
                  }
                },
                builder: (BuildContext context, recentOrdersState) {
                  if (recentOrdersState is RecentEstatesOrdersFetchProgress) {
                    return const ClientsOrdersShimmer();
                  }
                  if (recentOrdersState is! RecentEstatesOrdersFetchComplete) {
                    return Container();
                  }

                  orders = recentOrdersState.estateOrders;
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            documentOutlineIconPath,
                            width: 0.5.sw,
                            height: 0.5.sw,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.42),
                          ),
                          48.verticalSpace,
                          Text(
                            AppLocalizations.of(context)!
                                .have_not_recent_orders,
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                          10.verticalSpace,
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(180.w, 60.h),
                                maximumSize: Size(200.w, 60.h),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.estate_order,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const CreateOrderScreen()));

                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  bool find = false;
                  if (widget.estateId != null) {
                    for (int i = 0; i < orders.length; i++) {
                      if (orders.elementAt(i).id ==
                          int.parse(widget.estateId!)) {
                        find = true;
                        break;
                      }
                    }
                    if (find) {
                      SchedulerBinding.instance!.addPostFrameCallback((_) {
                        jumpToOrder(orders);
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.delete_request);
                    }
                  }
                  return RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    onRefresh: () async {
                      _onRefresh();
                    },
                    child: BlocListener<DeleteEstatesBloc, DeleteEstatesState>(
                      listener: (_, deleteEstateOrderState) async {
                        if (deleteEstateOrderState
                        is DeleteEstatesFetchComplete) {
                          await _onRefresh();
                        } else if (deleteEstateOrderState
                        is DeleteEstatesFetchError) {}
                      },
                      child: ScrollablePositionedList.builder(
                          itemScrollController: scrollController,
                          itemPositionsListener: itemPositionsListener,
                          itemCount: orders.length,
                          itemBuilder: (_, index) {
                            return (widget.estateId != null && find)
                                ? AnimatedBuilder(
                              animation: _colorTween,
                              builder: (context, _) => EstateOrderCard(
                                estateOrder: orders.elementAt(index),
                                //color: Theme.of(context).colorScheme.background,
                                color: (int.parse(widget.estateId!) ==
                                    orders.elementAt(index).id)
                                    ? _colorTween.value
                                    : Theme.of(context)
                                    .colorScheme
                                    .background,
                                onTap: () async {
                                  await deleteEstateOrder(index);
                                },
                              ),
                            )
                                : EstateOrderCard(
                              estateOrder: orders.elementAt(index),
                              color: Theme.of(context)
                                  .colorScheme
                                  .background,
                              onTap: () async {
                                await deleteEstateOrder(index);
                              },
                            );
                          }),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteEstateOrder(index) async {
    DeleteEstatesBloc deleteEstatesBloc =
        DeleteEstatesBloc(EstateOrderRepository());
    deleteEstatesBloc.add(DeleteEstatesFetchStarted(
        token: UserSharedPreferences.getAccessToken(),
        orderId: orders.elementAt(index).id!));
    await _onRefresh();
  }

  jumpToOrder(List<EstateOrder> orders) {
    int index = getIndexFromId(orders);
    if (index != -1) {
      if (scrollController.isAttached) {
        scrollController.scrollTo(
            index: index, duration: const Duration(milliseconds: 1000));
      }
    }
  }

  getIndexFromId(List<EstateOrder> orders) {
    for (int i = 0; i < orders.length; i++) {
      if (orders.elementAt(i).id == int.parse(widget.estateId!)) {
        return i;
      }
    }
    return -1;
  }
}
