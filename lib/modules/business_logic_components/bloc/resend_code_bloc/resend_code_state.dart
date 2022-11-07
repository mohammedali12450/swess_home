abstract class ResendVerificationCodeState {}

class ResendVerificationCodeNone extends ResendVerificationCodeState {}

class ResendVerificationCodeError extends ResendVerificationCodeState {
  final String? errorMessage;

  dynamic errorResponse;
  final bool isConnectionError;

  ResendVerificationCodeError({this.errorMessage, this.errorResponse, this.isConnectionError = false});
}

class ResendVerificationCodeProgress extends ResendVerificationCodeState {}

class ResendVerificationCodeComplete extends ResendVerificationCodeState {}
