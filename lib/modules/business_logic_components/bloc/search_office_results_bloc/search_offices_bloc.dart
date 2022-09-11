import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/repositories/estate_offices_repository.dart';
import 'search_offices_event.dart';
import 'search_offices_state.dart';

class SearchOfficesBloc extends Bloc<SearchOfficesEvents, SearchOfficesStates> {
  EstateOfficesRepository estateOfficesRepository;

  SearchOfficesBloc(this.estateOfficesRepository) : super(SearchOfficesFetchNone()) {
    on<SearchOfficesByNameStarted>((event, emit) async {
      emit(SearchOfficesFetchProgress());

      try {
        List<EstateOffice> results =
            await estateOfficesRepository.searchEstateOfficesByName(event.name, event.token);
        emit(
          SearchOfficesFetchComplete(results: results),
        );
      } on ConnectionException catch (e) {
        emit(SearchOfficesFetchError(errorMessage: e.errorMessage));
      } catch (e) {
        if (e is GeneralException) {
          emit(SearchOfficesFetchError(errorMessage: e.errorMessage!));
        }
      }
    });

    on<SearchOfficesByLocationStarted>((event, emit) async {
      emit(SearchOfficesFetchProgress());

      try {
        List<EstateOffice> results = await estateOfficesRepository.searchEstateOfficesByLocationId(
            event.locationId);
        emit(
          SearchOfficesFetchComplete(results: results),
        );
      } on ConnectionException catch (e) {
        emit(SearchOfficesFetchError(errorMessage: e.errorMessage));
      } catch (e) {
        if (e is GeneralException) {}
      }
    });

    on<SearchOfficesCleared>((event, emit) {
      emit(
        SearchOfficesFetchNone(),
      );
    });
  }
}
