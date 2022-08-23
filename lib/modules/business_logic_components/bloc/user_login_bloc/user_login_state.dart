abstract class UserLoginState {}

class UserLoginNone extends UserLoginState {}

class UserLoginComplete extends UserLoginState {}

class UserLoginProgress extends UserLoginState {}

class UserLoginError extends UserLoginState {
  final String? errorMessage;
  Map<String, dynamic>? errorResponse;
  final bool isConnectionError;

  final bool isUnauthorizedError;

  UserLoginError({
    this.errorMessage,
    this.errorResponse,
    this.isConnectionError = false,
    this.isUnauthorizedError = false,
  });
}
