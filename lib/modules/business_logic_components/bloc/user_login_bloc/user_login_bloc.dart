import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_event.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
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
        if(user!.token!= null){
          UserSharedPreferences.setAccessToken(user!.token!);
        }
        emit(UserLoginComplete());
      } catch (e, stack) {
        if (e is FieldsException) {
          emit(
            UserLoginError(
                errorResponse: (e.jsonErrorFields["errors"] != null)
                    ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                    : null,
                errorMessage: e.jsonErrorFields["message"]),
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
}
