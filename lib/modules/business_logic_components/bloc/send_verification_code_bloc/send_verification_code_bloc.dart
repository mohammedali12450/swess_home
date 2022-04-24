import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'send_verification_code_event.dart';
import 'send_verification_code_state.dart';

class SendVerificationCodeBloc extends Bloc<SendVerificationCodeEvent, SendVerificationCodeState> {
  final UserAuthenticationRepository _userAuthenticationRepository = UserAuthenticationRepository();

  SendVerificationCodeBloc() : super(SendVerificationCodeNone()) {
    on<VerificationCodeSendingStarted>((event, emit) async {
      emit(SendVerificationCodeProgress());
      try {
        User user =
            await _userAuthenticationRepository.sendVerificationCode(event.phone, event.code);
        emit(SendVerificationCodeComplete(user: user));
      } on ConnectionException catch (e) {
        emit(
          SendVerificationCodeError(error: e.errorMessage, isConnectionError: true),
        );
      } catch (e, stack) {
        print(e);
        print(stack);
      }
    });
  }
}
