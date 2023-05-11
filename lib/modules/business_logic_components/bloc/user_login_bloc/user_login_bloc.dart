import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/core/functions/setup_locator_app.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_event.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/data/services/google_sign_in_services.dart';
import '../../../../core/exceptions/general_exception.dart';
import 'user_login_state.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  UserAuthenticationRepository userAuthenticationRepository =
      UserAuthenticationRepository();
  User? user;

  UserLoginBloc(this.userAuthenticationRepository) : super(UserLoginNone()) {
    on<UserLoginStarted>((event, emit) async {
      emit(UserLoginProgress());
      try {
        user = await userAuthenticationRepository.login(
            event.authentication, event.password);

        emit(UserLoginComplete());
      } on ConnectionException catch (e) {
        emit(
          UserLoginError(errorMessage: e.errorMessage, isConnectionError: true),
        );
      } catch (e, stack) {
        if (e is FieldsException) {
          emit(
            UserLoginError(
                errorResponse: (e.jsonErrorFields["errors"] != null)
                    ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                    : null,
                errorMessage: (e.jsonErrorFields["message"] != null)
                    ? e.jsonErrorFields["message"]
                    : null),
          );
        }

        if (e is GeneralException) {
          emit(UserLoginError(errorMessage: e.errorMessage));
        }

        if (e is UnauthorizedException) {
          emit(
            UserLoginError(errorMessage: e.message, isUnauthorizedError: true),
          );
        }
        if (e is UnknownException) {
          emit(
            UserLoginError(errorMessage: "خطأ غير معروف"),
          );
        }
        print(e);
        print(stack);
      }
    });
  }

  Future<void> loginGoogle() async {
    final googleSignInService = locator.get<GoogleSignInService>();
    final isLogged = await googleSignInService.isSignedIn();

    if (isLogged) {
      log("You alrady login by google");
      return;
    }

    final token = await googleSignInService.login();

    if (token == null) {
      log("You Can't login by google");
      return;
    }

    userAuthenticationRepository.socialLogin("google", token);

    //some code here...
  }

  Future<void> loginFacebook() async {}
}
