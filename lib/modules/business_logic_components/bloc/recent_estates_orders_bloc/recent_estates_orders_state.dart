import 'package:swesshome/modules/data/models/estate_order.dart';

abstract class RecentEstatesOrdersState {}

class RecentEstatesOrdersFetchNone extends RecentEstatesOrdersState {}

class RecentEstatesOrdersFetchProgress extends RecentEstatesOrdersState {}

class RecentEstatesOrdersFetchComplete extends RecentEstatesOrdersState {
  List<EstateOrder> estateOrders;

  RecentEstatesOrdersFetchComplete({required this.estateOrders});
}

class RecentEstatesOrdersFetchError extends RecentEstatesOrdersState {
  final String error;
  final bool isConnectionError ;

  RecentEstatesOrdersFetchError({required this.error , this.isConnectionError = false});
}
