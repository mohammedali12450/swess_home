import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/presentation/widgets/estate_order_card.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/clients_orders_shimmer.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
          toolbarHeight: Res.height(75),
          backgroundColor: secondaryColor,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Res.width(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ),
          ],
          title: SizedBox(
            width: inf,
            child: ResText(
              "الطلبات العقارية السابقة",
              textStyle: textStyling(S.s18, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        body: Container(
          padding: kMediumSymWidth,
          child: BlocBuilder<RecentEstatesOrdersBloc, RecentEstatesOrdersState>(
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
                return const Center(child: ResText("Empty"));
              }

              return ListView.builder(

                  itemCount: orders.length ,
                  itemBuilder: (_, index) {

                return EstateOrderCard(estateOrder: orders.elementAt(index));
              });
            },
          ),
        ),
      ),
    );
  }
}
