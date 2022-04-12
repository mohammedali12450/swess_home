import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/created_estates_bloc/created_estates_state.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';

class CreatedEstatesBloc extends Bloc<CreatedEstatesEvent, CreatedEstatesState> {
  EstateRepository estateRepository;

  CreatedEstatesBloc(this.estateRepository) : super(CreatedEstatesFetchNone()) {
    on<CreatedEstatesFetchStarted>(
      (event, emit) async {
        emit(CreatedEstatesFetchProgress());
        try {
          List<Estate> estates = await estateRepository.getCreatedEstates(event.token);
          emit(CreatedEstatesFetchComplete(createdEstates: estates));
        } on ConnectionException catch (e) {
          emit(CreatedEstatesFetchError(error: e.errorMessage , isConnectionError: true));
        } catch (e) {
          if (e is GeneralException) {
            emit(CreatedEstatesFetchError(error: e.errorMessage));
          }
        }
      },
    );
  }
}
