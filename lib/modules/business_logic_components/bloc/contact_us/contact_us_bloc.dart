import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/contact_us/contact_us_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/contact_us/contact_us_state.dart';
import 'package:swesshome/modules/data/repositories/contact_us_repository.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsRepository contactUsRepository;

  ContactUsBloc({required this.contactUsRepository}) : super(ContactUsNone()) {
    on<ContactUsStarted>((event, emit) async {
      emit(ContactUsProgress());
      try {
        final String message = await contactUsRepository.sendDirectMessage(
            event.email, event.subject, event.message);
        emit(ContactUsComplete(successsMessage: message));
      } on ConnectionException catch (e) {
        emit(
          ContactUsError(errorMessage: e.errorMessage, isConnectionError: true),
        );
      } catch (e) {
        if (e is FieldsException) {
          emit(
            ContactUsError(
              errorResponse: (e.jsonErrorFields["errors"] != null)
                  ? e.jsonErrorFields["errors"] as Map<String, dynamic>
                  : null,
              errorMessage: e.jsonErrorFields["message"],
            ),
          );
        }
        if (e is UnknownException) {
          emit(
            ContactUsError(errorMessage: "خطأ غير معروف"),
          );
        }
      }
      // on ConnectionException catch (e) {
      //   emit(ContactUsError(errorMessage: e.errorMessage , isConnectionError: true));
      // } catch (e) {
      //   if (e is GeneralException) {
      //     emit(ContactUsError(errorMessage: e.errorMessage!));
      //   }
      // }
    });
  }
}
