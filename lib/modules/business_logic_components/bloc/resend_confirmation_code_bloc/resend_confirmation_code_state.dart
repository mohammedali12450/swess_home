abstract class ResendConfirmationCodeState {}

class ResendConfirmationCodeComplete extends ResendConfirmationCodeState {}
class ResendConfirmationCodeError extends ResendConfirmationCodeState {
  final String message ;
  final bool isConnectionException ;

  ResendConfirmationCodeError({required this.message , this.isConnectionException = false});
}
class ResendConfirmationCodeProgress extends ResendConfirmationCodeState {}
class ResendConfirmationCodeNone extends ResendConfirmationCodeState {}
