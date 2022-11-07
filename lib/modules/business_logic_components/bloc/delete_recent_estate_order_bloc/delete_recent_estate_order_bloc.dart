import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';

import '../../../data/repositories/estate_order_repository.dart';
import 'delete_recent_estate_order_event.dart';
import 'delete_recent_estate_order_state.dart';

class DeleteEstatesBloc extends Bloc<DeleteEstatesEvent, DeleteEstatesState> {
  EstateOrderRepository estateOrderRepository;

  DeleteEstatesBloc(this.estateOrderRepository)
      : super(DeleteEstatesFetchNone()) {
    on<DeleteEstatesFetchStarted>(
      (event, emit) async {
        emit(DeleteEstatesFetchProgress());
        try {
          await estateOrderRepository.deleteRecentEstateOrders(event.token, event.orderId);
          emit(DeleteEstatesFetchComplete());
        } on ConnectionException catch (e) {
          emit(DeleteEstatesFetchError(
              error: e.errorMessage, isConnectionError: true));
        } catch (e) {
          if (e is GeneralException) {
            emit(DeleteEstatesFetchError(error: e.errorMessage!));
          }
        }
      },
    );
  }
}
