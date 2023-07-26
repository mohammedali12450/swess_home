import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/notifications_cubit.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/create_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/notifications_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:swesshome/modules/presentation/widgets/estate_order_card.dart';
import 'package:swesshome/modules/presentation/widgets/icone_badge.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/clients_orders_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

import '../../../constants/colors.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_bloc.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_event.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../data/providers/theme_provider.dart';
import '../widgets/app/global_app_bar.dart';
import '../widgets/will-pop-scope.dart';

class RecentEstateOrdersScreenNavBar extends StatefulWidget {
  static const String id = "RecentEstateOrdersScreen";

  final String? estateId;

  const RecentEstateOrdersScreenNavBar({Key? key, this.estateId})
      : super(key: key);

  @override
  _RecentEstateOrdersScreenNavBarState createState() =>
      _RecentEstateOrdersScreenNavBarState();
}

class _RecentEstateOrdersScreenNavBarState
    extends State<RecentEstateOrdersScreenNavBar>
    with TickerProviderStateMixin {
  late RecentEstatesOrdersBloc _recentEstatesOrdersBloc;
  late ItemScrollController scrollController;
  late ItemPositionsListener itemPositionsListener;
  // String? userToken;
  List<EstateOrder> orders = [];
  late AnimationController _animationController;
  late Animation _colorTween;
  late bool isDark;

  //late Timer timer;

  @override
  void initState() {
    super.initState();
    _recentEstatesOrdersBloc = RecentEstatesOrdersBloc(EstateOrderRepository());
    // User? user = BlocProvider.of<UserLoginBloc>(context).user;
    // if (user != null) {
    //   userToken = UserSharedPreferences.getAccessToken();
    // }
    // _onRefresh();
    if (UserSharedPreferences.getAccessToken() != null) {
      _recentEstatesOrdersBloc.add(
        RecentEstatesOrdersFetchStarted(
            token: UserSharedPreferences.getAccessToken()!),
      );
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

  // _onRefresh() {
  //   if (userToken != null) {
  //     _recentEstatesOrdersBloc.add(
  //       RecentEstatesOrdersFetchStarted(
  //           token: UserSharedPreferences.getAccessToken()!),
  //     );
  //   }else {
  //       print('+++++++++++++++++++++++');
  //   }
  // }

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
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    if (widget.estateId != null) {
      initAnimation(context);
    }
    return BackHomeScreen(
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: UserSharedPreferences.getAccessToken() == null
              ? null
              : BlocBuilder<RecentEstatesOrdersBloc, RecentEstatesOrdersState>(
                  bloc: _recentEstatesOrdersBloc,
                  builder: (context, state) {
                    if (state is RecentEstatesOrdersFetchComplete) {
                      if (state.estateOrders.isNotEmpty) {
                        return AddOfferButton();
                      }
                    }
                    return SizedBox();
                  },
                ),
          backgroundColor: isDark
              ? const Color(0xff26282B)
              : AppColors.white, // Color(0xffF2F2F6),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(46.0),
            child: GlobalAppbarWidget(
                isDark: isDark,
                title: AppLocalizations.of(context)!.estate_offers),
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
              // _onRefresh();
              if (UserSharedPreferences.getAccessToken() != null) {
                _recentEstatesOrdersBloc.add(
                  RecentEstatesOrdersFetchStarted(
                      token: UserSharedPreferences.getAccessToken()!),
                );
              }
            },
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
                    return buildSignInRequired(context);
                  }
                  orders = recentOrdersState.estateOrders;
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            documentOutlineIconPath,
                            width: 0.2.sw,
                            height: 0.2.sw,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          kHe24,
                          Text(
                            AppLocalizations.of(context)!
                                .have_not_recent_orders,
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
                                  AppLocalizations.of(context)!.estate_order,
                                  style: const TextStyle(fontSize: 18),
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
                      SchedulerBinding.instance.addPostFrameCallback((_) {
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
                      // _onRefresh();

                      if (UserSharedPreferences.getAccessToken() != null) {
                        _recentEstatesOrdersBloc.add(
                          RecentEstatesOrdersFetchStarted(
                              token: UserSharedPreferences.getAccessToken()!),
                        );
                      }
                    },
                    child: BlocListener<DeleteEstatesBloc, DeleteEstatesState>(
                      listener: (_, deleteEstateOrderState) async {
                        if (deleteEstateOrderState
                            is DeleteEstatesFetchComplete) {
                          // await _onRefresh();
                          if (UserSharedPreferences.getAccessToken() != null) {
                            _recentEstatesOrdersBloc.add(
                              RecentEstatesOrdersFetchStarted(
                                  token:
                                      UserSharedPreferences.getAccessToken()!),
                            );
                          }
                        } else if (deleteEstateOrderState
                            is DeleteEstatesFetchError) {}
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ScrollablePositionedList.builder(
                                  itemScrollController: scrollController,
                                  itemPositionsListener: itemPositionsListener,
                                  itemCount: orders.length,
                                  itemBuilder: (_, index) {
                                    return (widget.estateId != null && find)
                                        ? AnimatedBuilder(
                                            animation: _colorTween,
                                            builder: (context, _) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, bottom: 10),
                                              child: EstateOrderCard(
                                                estateOrder:
                                                    orders.elementAt(index),
                                                //color: Theme.of(context).colorScheme.background,
                                                color: (int.parse(
                                                            widget.estateId!) ==
                                                        orders
                                                            .elementAt(index)
                                                            .id)
                                                    ? _colorTween.value
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                onTap: () async {
                                                  await deleteEstateOrder(
                                                      index);
                                                },
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: EstateOrderCard(
                                              estateOrder:
                                                  orders.elementAt(index),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              onTap: () async {
                                                await deleteEstateOrder(index);
                                              },
                                            ),
                                          );
                                  }),
                            ),
                          ],
                        ),
                      ),
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
    // await _onRefresh();
    if (UserSharedPreferences.getAccessToken() != null) {
      _recentEstatesOrdersBloc.add(
        RecentEstatesOrdersFetchStarted(
            token: UserSharedPreferences.getAccessToken()!),
      );
    }
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

  Widget buildSignInRequired(context) {
    return SizedBox(
      height: 20,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.this_features_require_login,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(180.w, 50.h),
                ),
                child: Text(
                  AppLocalizations.of(context)!.sign_in,
                ),
                onPressed: () async {
                  await Navigator.pushNamed(context, AuthenticationScreen.id)
                      .then((value) {});
                  Navigator.pop(context);
                  // _onRefresh();
                  if (UserSharedPreferences.getAccessToken() != null) {
                    _recentEstatesOrdersBloc.add(
                      RecentEstatesOrdersFetchStarted(
                          token: UserSharedPreferences.getAccessToken()!),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddOfferButton extends StatelessWidget {
  const AddOfferButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CreateOrderScreen()));
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        width: 108,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xff2A84D1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            SvgPicture.asset(material_symbols_searchPath,
                width: 19, height: 25, color: Colors.white),
            SizedBox(width: 10.0),
            Text(
              AppLocalizations.of(context)!.add_offer,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
