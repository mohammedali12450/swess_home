abstract class ResetPasswordState {}

class ResetPasswordNone extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String? errorMessage;

  dynamic errorResponse;
  final bool isConnectionError;

  ResetPasswordError({this.errorMessage, this.errorResponse, this.isConnectionError = false});
}

class ResetPasswordProgress extends ResetPasswordState {}

class ResetPasswordComplete extends ResetPasswordState {}
