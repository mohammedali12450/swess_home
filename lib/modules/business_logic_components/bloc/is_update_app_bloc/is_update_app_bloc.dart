import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';

import '../../../data/repositories/is_update_app_repository.dart';
import 'is_update_app_event.dart';
import 'is_update_app_state.dart';

class IsUpdateAppBloc extends Bloc<IsUpdateAppEvent, IsUpdateAppState> {
  IsUpdateAppRepository isUpdateAppRepository;

  IsUpdateAppBloc(this.isUpdateAppRepository) : super(IsUpdateAppNone()) {
    on<IsUpdateAppStarted>(
      (event, emit) async {
        emit(IsUpdateAppProgress());
        try {
          await isUpdateAppRepository.getIsUpdateApp(
              event.isAndroid, event.version);
          emit(IsUpdateAppComplete());
        } on ConnectionException catch (e) {
          emit(
              IsUpdateAppError(error: e.errorMessage, isConnectionError: true));
        } catch (e) {
          if (e is GeneralException) {
            emit(IsUpdateAppError(error: e.errorMessage!));
          }
        }
      },
    );
  }
}
