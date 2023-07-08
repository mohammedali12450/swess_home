import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_state.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  UserAuthenticationRepository userAuthenticationRepository;

  UserRegisterBloc(this.userAuthenticationRepository)
      : super(UserRegisterNone()) {
    on<UserRegisterStarted>((event, emit) async {
      emit(UserRegisterProgress());

      try {
        final String message =
            await userAuthenticationRepository.register(event.register);

        emit(UserRegisterComplete(successsMessage: message));
      } on ConnectionException catch (e) {
        emit(
          UserRegisterError(
              errorMessage: e.errorMessage, isConnectionError: true),
        );
      } catch (e) {
        if (e is FieldsException) {
          emit(
            UserRegisterError(
              errorResponse: (e.jsonErrorFields["errors"] != null)
                  ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                  : null,
              errorMessage: e.jsonErrorFields["message"],
            ),
          );
        }
        if (e is UnknownException) {
          emit(
            UserRegisterError(errorMessage: "خطأ غير معروف"),
          );
        }
      }
    });
  }
}
