import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';

import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  UserAuthenticationRepository userAuthenticationRepository;

  User? user;

  ChangePasswordBloc(this.userAuthenticationRepository)
      : super(ChangePasswordNone()) {
    on<ChangePasswordStarted>((event, emit) async {
      emit(ChangePasswordProgress());
      try {
        dynamic message = await userAuthenticationRepository.changePassword(
          event.oldPassword,
          event.newPassword,
          event.token,
        );
        // if (user!.token != null) {
        //   UserSharedPreferences.setAccessToken(user!.token!);
        // }
        emit(ChangePasswordComplete(successMessage: message));
      } on FieldsException catch (e) {
        emit(ChangePasswordError(
            errorResponse: (e.jsonErrorFields["errors"] != null)
                ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                : null,
            errorMessage: e.jsonErrorFields["message"]));
      } on GeneralException catch (e) {
        emit(ChangePasswordError(errorMessage: e.errorMessage));
      } on ConnectionException catch (e) {
        emit(ChangePasswordError(
            errorMessage: e.errorMessage, isConnectionError: true));
      }
    });
  }
}
