import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate.dart';

import '../../../data/repositories/last_visited_repository.dart';
import 'last_visited_estates_event.dart';
import 'last_visited_estates_state.dart';

class LastVisitedEstatesBloc
    extends Bloc<LastVisitedEstatesEvent, LastVisitedEstatesState> {
  LastVisitedRepository lastVisitedRepository;

  LastVisitedEstatesBloc(this.lastVisitedRepository)
      : super(LastVisitedEstatesFetchNone()) {
    on<LastVisitedEstatesFetchStarted>(
      (event, emit) async {
        emit(LastVisitedEstatesFetchProgress());
        try {
          List<Estate> estates =
              await lastVisitedRepository.getLastVisitedEstates(event.token);
          emit(LastVisitedEstatesFetchComplete(lastVisitedEstates: estates));
        } on ConnectionException catch (e) {
          emit(LastVisitedEstatesFetchError(
              error: e.errorMessage, isConnectionError: true));
        } catch (e) {
          if (e is GeneralException) {
            emit(LastVisitedEstatesFetchError(error: e.errorMessage!));
          }
        }
      },
    );
  }
}
