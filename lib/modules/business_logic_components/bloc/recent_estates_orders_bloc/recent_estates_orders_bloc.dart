import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/recent_estates_orders_bloc/recent_estates_orders_state.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';

class RecentEstatesOrdersBloc extends Bloc<RecentEstatesOrdersEvent, RecentEstatesOrdersState> {
  EstateOrderRepository estateOrderRepository;

  RecentEstatesOrdersBloc(this.estateOrderRepository) : super(RecentEstatesOrdersFetchNone()) {
    on<RecentEstatesOrdersFetchStarted>((event, emit) async {
      emit(RecentEstatesOrdersFetchProgress()) ;
      try {
        List<EstateOrder> orders = await estateOrderRepository.getRecentEstateOrders(event.token);
        emit(RecentEstatesOrdersFetchComplete(estateOrders: orders));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(RecentEstatesOrdersFetchError(error: e.errorMessage));
        }
        print(e);
        print(stack);
      }
    });
  }
}
