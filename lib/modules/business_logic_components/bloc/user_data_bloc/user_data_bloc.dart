import 'package:bloc/bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_bloc/user_data_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_bloc/user_data_state.dart';

import '../../../../core/exceptions/connection_exception.dart';
import '../../../../core/exceptions/fields_exception.dart';
import '../../../../core/exceptions/general_exception.dart';
import '../../../../core/exceptions/unauthorized_exception.dart';
import '../../../../core/exceptions/unknown_exception.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/user_authentication_repository.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  UserAuthenticationRepository userAuthenticationRepository =
  UserAuthenticationRepository();
  User? user;

  UserDataBloc(this.userAuthenticationRepository) : super(UserDataNone()) {
    on<UserDataStarted>((event, emit) async {
      emit(UserDataProgress());
      try {
        user = await userAuthenticationRepository.getUser(event.token!);

        emit(UserDataComplete(user: user));
      } on ConnectionException catch (e) {
        emit(
          UserDataError(
              errorMessage: e.errorMessage, isConnectionError: true),
        );
      } catch (e) {
        if (e is FieldsException) {
          emit(
            UserDataError(
                errorResponse: (e.jsonErrorFields["errors"] != null)
                    ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                    : null,
                errorMessage: (e.jsonErrorFields["message"] != null)
                    ? e.jsonErrorFields["message"]
                    : null),
          );
        }

        if (e is GeneralException) {
          emit(UserDataError(errorMessage: e.errorMessage));
        }

        if (e is UnauthorizedException) {
          emit(
            UserDataError(errorMessage: e.message, isUnauthorizedError: true),
          );
        }
        if (e is UnknownException) {
          emit(
            UserDataError(errorMessage: "خطأ غير معروف"),
          );
        }
      }
    });
  }
}
