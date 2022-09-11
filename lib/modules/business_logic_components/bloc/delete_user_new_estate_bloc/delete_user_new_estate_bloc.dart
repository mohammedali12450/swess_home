import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';

import '../../../data/repositories/estate_repository.dart';
import 'delete_user_new_estate_event.dart';
import 'delete_user_new_estate_state.dart';

class DeleteUserNewEstateBloc
    extends Bloc<DeleteUserNewEstateEvent, DeleteUserNewEstateState> {
  EstateRepository estateRepository;

  DeleteUserNewEstateBloc(this.estateRepository)
      : super(DeleteUserNewEstateFetchNone()) {
    on<DeleteUserNewEstateFetchStarted>(
      (event, emit) async {
        emit(DeleteUserNewEstateFetchProgress());
        try {
          await estateRepository.deleteUserNewEstate(event.token, event.orderId);
          emit(DeleteUserNewEstateFetchComplete());
        } on ConnectionException catch (e) {
          emit(DeleteUserNewEstateFetchError(
              error: e.errorMessage, isConnectionError: true));
        } catch (e) {
          if (e is GeneralException) {
            emit(DeleteUserNewEstateFetchError(error: e.errorMessage!));
          }
        }
      },
    );
  }
}
