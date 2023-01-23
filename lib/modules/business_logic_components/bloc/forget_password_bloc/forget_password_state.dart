abstract class ForgetPasswordState {}

class ForgetPasswordNone extends ForgetPasswordState {}

class ForgetPasswordError extends ForgetPasswordState {
  final String? errorMessage;

  Map<String, dynamic>? errorResponse;
  final bool isConnectionError;

  ForgetPasswordError({this.errorMessage, this.errorResponse, this.isConnectionError = false});
}

class ForgetPasswordProgress extends ForgetPasswordState {}

class ForgetPasswordComplete extends ForgetPasswordState {}
