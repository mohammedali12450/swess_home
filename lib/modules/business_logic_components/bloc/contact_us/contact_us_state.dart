abstract class ContactUsState {}

class ContactUsNone extends ContactUsState {}

class ContactUsProgress extends ContactUsState {}

class ContactUsComplete extends ContactUsState {
  final String? successsMessage;
  ContactUsComplete({required this.successsMessage});
}

class ContactUsError extends ContactUsState {
  final String? errorMessage;
  final Map<String,dynamic>? errorResponse;
  final bool isConnectionError;

  ContactUsError({this.errorMessage , this.errorResponse, this.isConnectionError = false});

}

