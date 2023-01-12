import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';

import 'estate_view_event.dart';
import 'estate_view_state.dart';

class EstateViewBloc extends Bloc<EstateViewEvent, EstateViewState> {
  EstateRepository estateRepository;
  List<Estate> mostViewEstates = [];

  EstateViewBloc(this.estateRepository) : super(EstateFetchNone()) {
    on<MostViewEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateMostViewFetchProgress());
        try {
          mostViewEstates = await estateRepository.getMostViewEstates();
          emit(EstateMostViewFetchComplete(estates: mostViewEstates));
        } on ConnectionException catch (e) {
          emit(
            EstateFetchError(
                errorMessage: e.errorMessage, isConnectionError: true),
          );
        } on GeneralException catch (e) {
          emit(
            EstateFetchError(errorMessage: e.errorMessage!),
          );
        }
      },
    );
  }
}
