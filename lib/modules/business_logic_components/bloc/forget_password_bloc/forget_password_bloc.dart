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
      } on FieldsException catch (e) {
        emit(ForgetPasswordError(
            errorResponse: (e.jsonErrorFields["errors"] != null)
                ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                : null,
            errorMessage: e.jsonErrorFields["message"]));
      } on GeneralException catch (e) {
        emit(ForgetPasswordError(errorMessage: e.errorMessage));
      } on ConnectionException catch (e) {
        emit(ForgetPasswordError(errorMessage: e.errorMessage, isConnectionError: true));
      }
    });
  }
}
