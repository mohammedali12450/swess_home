import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reset_password_bloc/reset_password_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reset_password_bloc/reset_password_state.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  UserAuthenticationRepository userAuthenticationRepository;

  User? user;

  ResetPasswordBloc({required this.userAuthenticationRepository})
      : super(ResetPasswordNone()) {
    on<ResetPasswordStarted>((event, emit) async {
      emit(ResetPasswordProgress());
      try {
        user = await userAuthenticationRepository.resetPassword(event.mobile,event.newPassword,event.confirmPassword);
        // if (user!.token != null) {
        //   UserSharedPreferences.setAccessToken(user!.token!);
        // }
        emit(ResetPasswordComplete());
      } on FieldsException catch (e) {
        emit(ResetPasswordError(
            errorResponse: (e.jsonErrorFields["errors"] != null)
                ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                : null,
            errorMessage: e.jsonErrorFields["message"]));
      } on GeneralException catch (e) {
        emit(ResetPasswordError(errorMessage: e.errorMessage));
      } on ConnectionException catch (e) {
        emit(ResetPasswordError(errorMessage: e.errorMessage, isConnectionError: true));
      }
    });
  }
}
