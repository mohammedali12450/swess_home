import 'package:bloc/bloc.dart';

import '../../../../core/exceptions/connection_exception.dart';
import '../../../../core/exceptions/fields_exception.dart';
import '../../../../core/exceptions/general_exception.dart';
import '../../../../core/exceptions/unauthorized_exception.dart';
import '../../../../core/exceptions/unknown_exception.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/user_authentication_repository.dart';
import 'edit_user_data_event.dart';
import 'edit_user_data_state.dart';

class UserEditDataBloc extends Bloc<UserEditDataEvent, UserEditDataState> {
  UserAuthenticationRepository userAuthenticationRepository =
      UserAuthenticationRepository();
  User? user;

  UserEditDataBloc(this.userAuthenticationRepository)
      : super(UserEditDataNone()) {
    on<UserEditDataStarted>((event, emit) async {
      emit(UserEditDataProgress());
      try {
        user = await userAuthenticationRepository.editUserData(
            event.token!, event.user!);
        emit(UserEditDataComplete(user: user));
      } on ConnectionException catch (e) {
        emit(
          UserEditDataError(
              errorMessage: e.errorMessage, isConnectionError: true),
        );
      } catch (e) {
        if (e is FieldsException) {
          emit(
            UserEditDataError(
                errorResponse: (e.jsonErrorFields["errors"] != null)
                    ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                    : null,
                errorMessage: (e.jsonErrorFields["message"] != null)
                    ? e.jsonErrorFields["message"]
                    : null),
          );
        }

        if (e is GeneralException) {
          emit(UserEditDataError(errorMessage: e.errorMessage));
        }

        if (e is UnauthorizedException) {
          emit(
            UserEditDataError(
                errorMessage: e.message, isUnauthorizedError: true),
          );
        }
        if (e is UnknownException) {
          emit(
            UserEditDataError(errorMessage: "خطأ غير معروف"),
          );
        }
      }
    });
  }
}
