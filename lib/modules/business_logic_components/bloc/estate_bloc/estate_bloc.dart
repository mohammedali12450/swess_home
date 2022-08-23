import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'estate_event.dart';

class EstateBloc extends Bloc<EstateEvent, EstateState> {
  EstateRepository estateRepository;
  List<Estate>? estates;
  int page = 1;
  bool isFetching = false;

  EstateBloc(this.estateRepository) : super(EstateFetchNone()) {
    on<EstateFetchStarted>(
      (event, emit) async {
        emit(EstateFetchProgress());
        try {
          estates =
              await estateRepository.search(event.searchData, event.isAdvanced, page, event.token);
          emit(EstateFetchComplete(estates: estates ?? []));
          page++;
        } on ConnectionException catch (e) {
          emit(
            EstateFetchError(errorMessage: e.errorMessage , isConnectionError: true),
          );
        } on GeneralException catch (e) {
          emit(
            EstateFetchError(errorMessage: e.errorMessage!),
          );
        }
      },
    );

    on<OfficeEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateFetchProgress());
        try {
          List<Estate> estates = await estateRepository.getOfficeEstates(event.officeId);
          emit(EstateFetchComplete(estates: estates,));
        } on ConnectionException catch (e) {
          emit(
            EstateFetchError(errorMessage: e.errorMessage),
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
