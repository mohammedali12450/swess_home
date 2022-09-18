import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_order_card.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/clients_orders_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

import '../../../constants/colors.dart';
import '../../data/models/user.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class RecentEstateOrdersScreen extends StatefulWidget {
  static const String id = "RecentEstateOrdersScreen";

  String? estateId;

  RecentEstateOrdersScreen({Key? key, this.estateId}) : super(key: key);

  @override
  _RecentEstateOrdersScreenState createState() =>
      _RecentEstateOrdersScreenState();
}

class _RecentEstateOrdersScreenState extends State<RecentEstateOrdersScreen>
    with SingleTickerProviderStateMixin {
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
    if (user != null && user.token != null) {
      userToken = user.token;
    }
    _onRefresh();

    scrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    // timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
    //   setState(() {
    //     //change your colorProgress here
    //   });
    // });
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _colorTween = ColorTween(begin: AppColors.primaryDark, end: AppColors.white)
        .animate(_animationController);
    changeColors();
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
            token: BlocProvider.of<UserLoginBloc>(context).user!.token!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.recent_created_orders,
          ),
        ),
        body: BlocConsumer<RecentEstatesOrdersBloc, RecentEstatesOrdersState>(
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
                      AppLocalizations.of(context)!.have_not_recent_orders,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              );
            }

            if (widget.estateId != null) {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                jumpToOrder(orders);
              });
            }
            return RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              onRefresh: () async {
                _onRefresh();
              },
              child: ScrollablePositionedList.builder(
                  itemScrollController: scrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemCount: orders.length,
                  itemBuilder: (_, index) {
                    return AnimatedBuilder(
                      animation: _colorTween,
                      builder: (context, child) => EstateOrderCard(
                        estateOrder: orders.elementAt(index),
                        //color: Theme.of(context).colorScheme.background,
                        color: (widget.estateId != null)
                            ? (int.parse(widget.estateId!) ==
                                    orders.elementAt(index).id)
                                ? _colorTween.value
                                : AppColors.white
                            : AppColors.white,
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }

  jumpToOrder(List<EstateOrder> orders) {
    int index = getIndexFromId(orders);
    if (index != -1) {
      if (scrollController.isAttached) {
        scrollController.scrollTo(
            index: index,
            duration: const Duration(seconds: 2),
            curve: Curves.ease);
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
