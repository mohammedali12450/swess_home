import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_code_bloc/resend_code_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_code_bloc/resend_code_state.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';

class ResendVerificationCodeBloc extends Bloc<ResendVerificationCodeEvent, ResendVerificationCodeState> {
  UserAuthenticationRepository userAuthenticationRepository;

  User? user;

  ResendVerificationCodeBloc({required this.userAuthenticationRepository})
      : super(ResendVerificationCodeNone()) {
    on<ResendVerificationCodeStarted>((event, emit) async {
      emit(ResendVerificationCodeProgress());
      try {
        user = await userAuthenticationRepository.forgetPassword(event.mobile);
        // if (user!.token != null) {
        //   UserSharedPreferences.setAccessToken(user!.token!);
        // }
        emit(ResendVerificationCodeComplete());
      } on FieldsException catch (e) {
        emit(ResendVerificationCodeError(
            errorResponse: (e.jsonErrorFields["errors"] != null)
                ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                : null,
            errorMessage: e.jsonErrorFields["message"]));
      } on GeneralException catch (e) {
        emit(ResendVerificationCodeError(errorMessage: e.errorMessage));
      } on ConnectionException catch (e) {
        emit(ResendVerificationCodeError(errorMessage: e.errorMessage, isConnectionError: true));
      }
    });
  }
}
