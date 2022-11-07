import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/verification_bloc/verifiaction_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/verification_bloc/verification_state.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';

class VerificationCodeBloc extends Bloc<VerificationCodeEvent, VerificationCodeState> {
  UserAuthenticationRepository userAuthenticationRepository;

  User? user;

  VerificationCodeBloc({required this.userAuthenticationRepository})
      : super(VerificationCodeNone()) {
    on<VerificationCodeStarted>((event, emit) async {
      emit(VerificationCodeProgress());
      try {
        user = await userAuthenticationRepository.verificationCode(event.mobile,event.verificationCode);
        // if (user!.token != null) {
        //   UserSharedPreferences.setAccessToken(user!.token!);
        // }
        emit(VerificationCodeComplete(user: user));
      } on FieldsException catch (e) {
        emit(VerificationCodeError(
            errorResponse: (e.jsonErrorFields["errors"] != null)
                ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                : null,
            errorMessage: e.jsonErrorFields["message"]));
      } on GeneralException catch (e) {
        emit(VerificationCodeError(errorMessage: e.errorMessage));
      } on ConnectionException catch (e) {
        emit(VerificationCodeError(errorMessage: e.errorMessage, isConnectionError: true));
      }
    });
  }
}
