import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_veification_login_code/send_veification_login_code_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_veification_login_code/send_veification_login_code_state.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import '../../../../core/exceptions/fields_exception.dart';

class SendVerificationCodeLoginBloc extends Bloc<SendVerificationCodeLoginEvent,
    SendVerificationCodeLoginState> {
  final UserAuthenticationRepository _userAuthenticationRepository =
      UserAuthenticationRepository();

  SendVerificationCodeLoginBloc() : super(SendVerificationCodeLoginNone()) {
    on<VerificationCodeSendingLoginStarted>((event, emit) async {
      emit(SendVerificationCodeLoginProgress());
      try {
        User user = await _userAuthenticationRepository
            .sendVerificationLoginCode(event.phone, event.code);
        emit(SendVerificationCodeLoginComplete(user: user));
      } on ConnectionException catch (e) {
        emit(
          SendVerificationCodeLoginError(
              errorMessage: e.errorMessage, isConnectionError: true),
        );
      } on FieldsException catch (e) {
        emit(SendVerificationCodeLoginError(
            errorResponse: (e.jsonErrorFields["errors"] != null)
                ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                : null,
            errorMessage: e.jsonErrorFields["message"]));
      } catch (e, stack) {
        print(e);
        print(stack);
      }
    });
  }
}
