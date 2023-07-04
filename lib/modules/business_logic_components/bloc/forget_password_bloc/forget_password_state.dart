abstract class ForgetPasswordState {}

class ForgetPasswordNone extends ForgetPasswordState {}

class ForgetPasswordError extends ForgetPasswordState {
  final String? errorMessage;
  Map<String, dynamic>? errorResponse;
  final bool isConnectionError;
  final bool isUnauthorizedError;

  ForgetPasswordError({this.errorMessage, this.errorResponse, this.isConnectionError = false,this.isUnauthorizedError = false,});
}

class ForgetPasswordProgress extends ForgetPasswordState {}

class ForgetPasswordComplete extends ForgetPasswordState {
  final String? successMessage;
  ForgetPasswordComplete({this.successMessage});

}
