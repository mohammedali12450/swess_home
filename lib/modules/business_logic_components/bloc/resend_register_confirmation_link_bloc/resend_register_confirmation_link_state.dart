abstract class ResendRegisterConfirmationLinkState {}

class ResendRegisterConfirmationLinkComplete extends ResendRegisterConfirmationLinkState {
  final String? successMessage;
  ResendRegisterConfirmationLinkComplete({this.successMessage});
}
class ResendRegisterConfirmationLinkError extends ResendRegisterConfirmationLinkState {
  final String message ;
  final bool isConnectionException ;

  ResendRegisterConfirmationLinkError({required this.message , this.isConnectionException = false});
}
class ResendRegisterConfirmationLinkProgress extends ResendRegisterConfirmationLinkState {}
class ResendRegisterConfirmationLinkNone extends ResendRegisterConfirmationLinkState {}
