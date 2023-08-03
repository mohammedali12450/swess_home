import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_state.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';

import '../../../../core/storage/shared_preferences/application_shared_preferences.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  UserAuthenticationRepository? userAuthenticationRepository = UserAuthenticationRepository();
  // User? user;

  ForgetPasswordBloc({this.userAuthenticationRepository}) : super(ForgetPasswordNone()) {
    on<ForgetPasswordStarted>((event, emit) async {
      emit(ForgetPasswordProgress());
      try {
        final message = await userAuthenticationRepository!.forgetPassword(event.mobile);
        print(message);
        // if (user!.token != null) {
        //   UserSharedPreferences.setAccessToken(user!.token!);
        // }
        emit(ForgetPasswordComplete(successMessage: message));
      } catch (e, stack) {
        if (e is FieldsException) {
          print(e.jsonErrorFields["message"]);
          emit(ForgetPasswordError(
              errorMessage: e.jsonErrorFields["message"]));
        } else if (e is GeneralException) {
          emit(ForgetPasswordError(errorMessage: e.errorMessage));
        } else if (e is ConnectionException) {
           emit(ForgetPasswordError(errorMessage: e.errorMessage, isConnectionError: true));
        }else if (e is UnauthorizedException) {
          emit(ForgetPasswordError(errorMessage: e.message, isUnauthorizedError: true),);
        }
        print(e);
        print(stack);
      }
    });
    on<ForgetPasswordBeforeEndTimer>((event, emit) async {
      try {
        final message = await userAuthenticationRepository!.forgetPassword(event.mobile);
        emit(ForgetPasswordError(errorMessage: message));
      } catch (e, stack) {
        if (e is FieldsException) {
          print(e.jsonErrorFields["message"]);
          emit(ForgetPasswordError(
              errorMessage: e.jsonErrorFields["message"]));
        } else if (e is GeneralException) {
          emit(ForgetPasswordError(errorMessage: e.errorMessage));
        } else if (e is ConnectionException) {
          emit(ForgetPasswordError(
              errorMessage: e.errorMessage, isConnectionError: true));
        } else if (e is UnauthorizedException) {
          emit(ForgetPasswordError(
              errorMessage: e.message, isUnauthorizedError: true),);
        }
      }
    });
  }
}

