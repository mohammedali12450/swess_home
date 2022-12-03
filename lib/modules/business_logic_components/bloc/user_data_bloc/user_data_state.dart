import '../../../data/models/user.dart';

abstract class UserDataState {}

class UserDataNone extends UserDataState {}

class UserDataComplete extends UserDataState {
  User? user;

  UserDataComplete({required this.user});
}

class UserDataProgress extends UserDataState {}

class UserDataError extends UserDataState {
  final String? errorMessage;
  Map<String, dynamic>? errorResponse;
  final bool isConnectionError;

  final bool isUnauthorizedError;

  UserDataError({
    this.errorMessage,
    this.errorResponse,
    this.isConnectionError = false,
    this.isUnauthorizedError = false,
  });
}
