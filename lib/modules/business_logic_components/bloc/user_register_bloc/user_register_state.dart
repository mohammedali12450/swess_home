abstract class UserRegisterState {}

class UserRegisterNone extends UserRegisterState {}

class UserRegisterProgress extends UserRegisterState {}

class UserRegisterComplete extends UserRegisterState {
  // User user ;
  final String? successsMessage;
  UserRegisterComplete({required this.successsMessage});
}

class UserRegisterError extends UserRegisterState {
  final String? errorMessage;
  Map<String, dynamic>? errorResponse;
  final bool isConnectionError;

  UserRegisterError(
      {this.errorMessage, this.errorResponse, this.isConnectionError = false});
}
