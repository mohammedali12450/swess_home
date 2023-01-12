import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';

import 'estate_spacial_event.dart';
import 'estate_spacial_state.dart';

class EstateSpacialBloc extends Bloc<EstateSpacialEvent, EstateSpacialState> {
  EstateRepository estateRepository;
  List<SpecialEstate> spacialEstates = [];

  EstateSpacialBloc(this.estateRepository) : super(EstateFetchNone()) {
    on<SpacialEstatesFetchStarted>(
      (event, emit) async {
        emit(EstateSpacialFetchProgress());
        try {
          spacialEstates = await estateRepository.getSpecialEstates();
          emit(EstateSpacialFetchComplete(estates: spacialEstates));
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
