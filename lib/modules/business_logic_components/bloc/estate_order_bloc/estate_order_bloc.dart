import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_state.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';

class EstateOrderBloc extends Bloc<EstateOrderEvent, EstateOrderState> {
  EstateOrderRepository estateOrderRepository;

  EstateOrderBloc(this.estateOrderRepository) : super(SendEstateOrderNone()) {
    on<SendEstateOrderStarted>((event, emit) async {
      emit(SendEstateOrderProgress());

      try {
        await estateOrderRepository.sendEstateOrder(event.order , event.token);
        emit(SendEstateOrderComplete());
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(SendEstateOrderError(error: e.errorMessage));
        } else if (e is UnauthorizedException) {
          emit(SendEstateOrderError(error: e.message , isAuthorizationError: true));
        }
        print(e);
        print(stack);
      }
    });
  }
}
