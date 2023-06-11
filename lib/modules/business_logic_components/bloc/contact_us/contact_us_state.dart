abstract class ContactUsState {}

class ContactUsNone extends ContactUsState {}

class ContactUsProgress extends ContactUsState {}

class ContactUsComplete extends ContactUsState {}

class ContactUsError extends ContactUsState {
  final String? errorMessage;
  dynamic errorResponse;
  final bool isConnectionError;

  ContactUsError({this.errorMessage, this.errorResponse, this.isConnectionError = false});
}

