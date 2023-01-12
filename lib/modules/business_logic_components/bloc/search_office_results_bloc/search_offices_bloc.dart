import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/repositories/estate_offices_repository.dart';
import 'search_offices_event.dart';
import 'search_offices_state.dart';

class SearchOfficesBloc extends Bloc<SearchOfficesEvents, SearchOfficesStates> {
  EstateOfficesRepository estateOfficesRepository;

  bool isFetching = false;
  int pageName = 1;
  int pageLocation = 1;

  SearchOfficesBloc(this.estateOfficesRepository)
      : super(SearchOfficesFetchNone()) {
    on<SearchOfficesByNameStarted>((event, emit) async {
      emit(SearchOfficesFetchProgress());
      try {
        List<EstateOffice> results = await estateOfficesRepository
            .searchEstateOfficesByName(event.name, event.token, pageName);
        emit(
          SearchOfficesFetchComplete(results: results),
        );
        pageName++;
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
        List<EstateOffice> results = await estateOfficesRepository
            .searchEstateOfficesByLocationId(event.locationId, pageLocation);
        emit(
          SearchOfficesFetchComplete(results: results),
        );
        pageLocation++;
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
