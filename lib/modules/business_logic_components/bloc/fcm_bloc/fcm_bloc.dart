import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/repositories/fcm_token_repository.dart';
import 'fcm_event.dart';
import 'fcm_state.dart';



class FcmBloc extends Bloc<FcmEvent, FcmState> {
  FcmTokenRepository fcmTokenRepository;

  FcmBloc({required this.fcmTokenRepository})
      : super(SendFcmTokenProcessNone()) {
    on<SendFcmTokenProcessStarted>((event, emit) async {
      emit(SendFcmTokenProcessProgress());
      try {
        await fcmTokenRepository.sendFcmToken(token: event.userToken);
        emit(SendFcmTokenProcessComplete());
      } catch (e, stack) {
        print(e);
        print(stack);
      }
    });
  }
}
