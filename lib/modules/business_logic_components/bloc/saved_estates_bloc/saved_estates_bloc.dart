import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/saved_estates_bloc/saved_estates_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';

class SavedEstatesBloc extends Bloc<SavedEstatesEvent, SavedEstatesState> {
  EstateRepository estateRepository;

  SavedEstatesBloc(this.estateRepository) : super(SavedEstatesFetchNone()) {
    on<SavedEstatesFetchStarted>((event, emit) async {
      emit(SavedEstatesFetchProgress());
      try {
        List<Estate> savedEstates = await estateRepository.getSavedEstates(event.token);
        emit(SavedEstatesFetchComplete(savedEstates: savedEstates));
      } on ConnectionException catch (e) {
        emit(SavedEstatesFetchError(error: e.errorMessage , isConnectionError: true));
      } catch (e) {
        if (e is GeneralException) {
          emit(SavedEstatesFetchError(error: e.errorMessage));
        }
      }
    });
  }
}
