import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_order_card.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/clients_orders_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentEstateOrdersScreen extends StatefulWidget {
  static const String id = "RecentEstateOrdersScreen";

  const RecentEstateOrdersScreen({Key? key}) : super(key: key);

  @override
  _RecentEstateOrdersScreenState createState() => _RecentEstateOrdersScreenState();
}

class _RecentEstateOrdersScreenState extends State<RecentEstateOrdersScreen> {
  late RecentEstatesOrdersBloc _recentEstatesOrdersBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recentEstatesOrdersBloc = RecentEstatesOrdersBloc(EstateOrderRepository());
    if (BlocProvider.of<UserLoginBloc>(context).user!.token != null) {
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
        body: BlocBuilder<RecentEstatesOrdersBloc, RecentEstatesOrdersState>(
          bloc: _recentEstatesOrdersBloc,
          builder: (BuildContext context, recentOrdersState) {
            if (recentOrdersState is RecentEstatesOrdersFetchProgress) {
              return const ClientsOrdersShimmer();
            }
            if (recentOrdersState is! RecentEstatesOrdersFetchComplete) {
              return Container();
            }

            List<EstateOrder> orders = recentOrdersState.estateOrders;
            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      documentOutlineIconPath,
                      width: 0.5.sw,
                      height: 0.5.sw,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.42),
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

            return ListView.builder(
                itemCount: orders.length ,
                itemBuilder: (_, index) {

              return EstateOrderCard(estateOrder: orders.elementAt(index));
            });
          },
        ),
      ),
    );
  }
}
