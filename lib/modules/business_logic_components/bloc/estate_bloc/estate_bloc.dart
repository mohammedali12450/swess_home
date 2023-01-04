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

  List<Estate> newestEstates = [];
  List<Estate> specialEstates = [];
  List<Estate> mostViewEstates = [];
  int page = 1;
  bool isIdenticalFetching = false;
  bool isSimilarFetching = false;

  EstateBloc(this.estateRepository) : super(EstateFetchNone()) {
    on<EstateFetchStarted>(
      (event, emit) async {
        emit(EstateFetchProgress());
        try {
          estateSearch = await estateRepository.search(
              event.searchData, event.isAdvanced, page, event.token);
          emit(EstateFetchComplete(estateSearch: estateSearch!));
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

    on<OfficeEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateFetchProgress());
        try {
          List<Estate> estates =
              await estateRepository.getOfficeEstates(event.officeId);
          emit(EstateOfficeFetchComplete(
            estates: estates,
          ));
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

    on<NewestEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateNewestFetchProgress());
        try {
          newestEstates = await estateRepository.getNewestEstates();
          emit(EstateNewestFetchComplete(estates: newestEstates));
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

    on<MostViewEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateMostViewFetchProgress());
        try {
          mostViewEstates = await estateRepository.getMostViewEstates();
          emit(EstateMostViewFetchComplete(estates: mostViewEstates));
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

    on<SpacialEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateSpacialFetchProgress());
        try {
          specialEstates = await estateRepository.getSpecialEstates();
          emit(EstateSpacialFetchComplete(estates: specialEstates));
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
  }
}
