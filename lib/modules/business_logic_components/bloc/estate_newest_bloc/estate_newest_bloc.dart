import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'estate_newest_event.dart';
import 'estate_newest_state.dart';

class EstateNewestBloc extends Bloc<EstateNewestEvent, EstateNewestState> {
  EstateRepository estateRepository;
  EstateSearch? estateSearch;

  List<Estate> newestEstates = [];

  EstateNewestBloc(this.estateRepository) : super(EstateFetchNone()) {
    on<NewestEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateNewestFetchProgress());
        try {
          newestEstates = await estateRepository.getNewestEstates();
          emit(EstateNewestFetchComplete(estates: newestEstates));
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
