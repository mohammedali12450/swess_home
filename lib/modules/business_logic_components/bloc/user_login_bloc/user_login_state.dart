abstract class UserLoginState {}

class UserLoginNone extends UserLoginState {}

class UserLoginComplete extends UserLoginState {
  final String? successMessage;
  UserLoginComplete({this.successMessage});
}

class UserLoginProgress extends UserLoginState {}

class UserLoginError extends UserLoginState {
  final String? errorMessage;
  final int? statusCode;
  Map<String, dynamic>? errorResponse;
  final bool isConnectionError;

  final bool isUnauthorizedError;

  UserLoginError({
    this.errorMessage,
    this.errorResponse,
    this.statusCode,
    this.isConnectionError = false,
    this.isUnauthorizedError = false,
  });
}
