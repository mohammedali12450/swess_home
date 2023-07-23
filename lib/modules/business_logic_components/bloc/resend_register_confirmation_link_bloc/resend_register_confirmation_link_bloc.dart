import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_register_confirmation_link_bloc/resend_register_confirmation_link_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_register_confirmation_link_bloc/resend_register_confirmation_link_state.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';


class ResendRegisterConfirmationLinkBloc
    extends Bloc<ResendRegisterConfirmationLinkEvent, ResendRegisterConfirmationLinkState> {
  final UserAuthenticationRepository _userAuthenticationRepository = UserAuthenticationRepository();

  ResendRegisterConfirmationLinkBloc() : super(ResendRegisterConfirmationLinkNone()) {
    on<ResendRegisterConfirmationLinkStarted>((event, emit) async {
      emit(ResendRegisterConfirmationLinkProgress());
      try {
        final String message = await _userAuthenticationRepository.resendRegisterConfirmationLink(event.phoneNumber);
        emit(ResendRegisterConfirmationLinkComplete(successMessage: message));
      } on ConnectionException {
        emit(ResendRegisterConfirmationLinkError(message: "Error", isConnectionException: true));
      } catch (e) {
        emit(ResendRegisterConfirmationLinkError(message: "حدث خطأ غير معروف"));
      }
    });
  }
}
