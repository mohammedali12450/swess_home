abstract class ChangePasswordState {}

class ChangePasswordNone extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String? errorMessage;

  dynamic errorResponse;
  final bool isConnectionError;

  ChangePasswordError({this.errorMessage, this.errorResponse, this.isConnectionError = false});
}

class ChangePasswordProgress extends ChangePasswordState {}

class ChangePasswordComplete extends ChangePasswordState {}
