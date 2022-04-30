import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';

import 'resend_confirmation_code_event.dart';
import 'resend_confirmation_code_state.dart';

class ResendConfirmationCodeBloc
    extends Bloc<ResendConfirmationCodeEvent, ResendConfirmationCodeState> {
  final UserAuthenticationRepository _userAuthenticationRepository = UserAuthenticationRepository();

  ResendConfirmationCodeBloc() : super(ResendConfirmationCodeNone()) {
    on<ResendConfirmationCodeStarted>((event, emit) async {
      emit(ResendConfirmationCodeProgress());
      try {
        await _userAuthenticationRepository.resendVerificationCode(event.phoneNumber);
        emit(ResendConfirmationCodeComplete());
      } on ConnectionException catch (e) {
        emit(ResendConfirmationCodeError(message: "Error", isConnectionException: true));
      } catch (e, stack) {
        emit(ResendConfirmationCodeError(message: "حدث خطأ غير معروف"));
      }
    });
  }
}
