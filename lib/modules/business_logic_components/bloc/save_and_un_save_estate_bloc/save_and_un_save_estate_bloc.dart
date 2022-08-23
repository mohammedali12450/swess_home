import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';

import 'save_and_un_save_estate_event.dart';
import 'save_and_un_save_estate_state.dart';

class SaveAndUnSaveEstateBloc extends Bloc<SaveAndUnSaveEstateEvent, SaveAndUnSaveEstateState> {
  EstateRepository estateRepository;

  SaveAndUnSaveEstateBloc(SaveAndUnSaveEstateState initialState, this.estateRepository)
      : super(initialState) {
    on<EstateSaveStarted>((event, emit) async {
      emit(EstateSaveAndUnSaveProgress());
      try {
        await estateRepository.saveEstate(event.token, event.estateId);
        emit(EstateSaved());
      } on ConnectionException catch (e) {
        emit(EstateSaveAndUnSaveError(error: e.errorMessage , isConnectionError: true));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(EstateSaveAndUnSaveError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });

    on<UnSaveEventStarted>((event, emit) async {
      emit(EstateSaveAndUnSaveProgress());
      try {
        await estateRepository.unSaveEstate(event.token, event.estateId);
        emit(EstateUnSaved());
      } on ConnectionException catch (e) {
        emit(EstateSaveAndUnSaveError(error: e.errorMessage));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(EstateSaveAndUnSaveError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });

    on<ReInitializeSaveState>((event, emit) {
      if (event.isSaved) {
        emit(EstateSaved());
      } else {
        emit(EstateUnSaved());
      }
    });
  }
}
