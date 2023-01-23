import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_state.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  UserAuthenticationRepository? userAuthenticationRepository = UserAuthenticationRepository();

  User? user;

  ForgetPasswordBloc({this.userAuthenticationRepository}) : super(ForgetPasswordNone()) {
    on<ForgetPasswordStarted>((event, emit) async {
      emit(ForgetPasswordProgress());
      try {
        user = await userAuthenticationRepository!.forgetPassword(event.mobile);
        // if (user!.token != null) {
        //   UserSharedPreferences.setAccessToken(user!.token!);
        // }
        emit(ForgetPasswordComplete());
      } catch (e, stack) {
        if (e is FieldsException) {
          print(e.jsonErrorFields["message"]);
          emit(ForgetPasswordError(
              errorMessage: e.jsonErrorFields["message"]));
        } else if (e is GeneralException) {
          emit(ForgetPasswordError(errorMessage: e.errorMessage));
        } else if (e is ConnectionException) {
           emit(ForgetPasswordError(errorMessage: e.errorMessage, isConnectionError: true));
        }
        print(e);
        print(stack);
      }
    });
  }
}
