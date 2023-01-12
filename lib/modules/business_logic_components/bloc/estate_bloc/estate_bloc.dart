import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'estate_event.dart';

class EstateBloc extends Bloc<EstateEvent, EstateState> {
  EstateRepository estateRepository;
  EstateSearch? estateSearch;
  Estate? estate;

  int page = 1;
  int filterPage = 1;
  bool isFetching = false;

  EstateBloc(this.estateRepository) : super(EstateFetchNone()) {
    on<EstatesFetchStarted>(
      (event, emit) async {
        emit(EstatesFetchProgress());
        try {
          estateSearch = await estateRepository.search(
              event.searchData, event.isAdvanced, page, event.token);
          emit(EstatesFetchComplete(estateSearch: estateSearch!));
          page++;
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

    on<FilterEstateFetchStarted>(
      (event, emit) async {
        emit(FilterEstateFetchProgress());
        try {
          estateSearch = await estateRepository.search(
              event.searchData, event.isAdvanced, filterPage, event.token);
          emit(FilterEstateFetchComplete(estateSearch: estateSearch!));
          filterPage++;
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

    on<EstateFetchStarted>(
      (event, emit) async {
        emit(EstateFetchProgress());
        try {
          estate = await estateRepository.getEstate(event.estateId);
          emit(EstateFetchComplete(estate: estate!));
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
