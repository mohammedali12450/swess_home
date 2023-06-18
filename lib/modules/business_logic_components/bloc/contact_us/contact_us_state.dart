abstract class ContactUsState {}

class ContactUsNone extends ContactUsState {}

class ContactUsProgress extends ContactUsState {}

class ContactUsComplete extends ContactUsState {}

class ContactUsError extends ContactUsState {
  final String? errorMessage;

  final bool isConnectionError;

  ContactUsError({required this.errorMessage , this.isConnectionError = false});

}

