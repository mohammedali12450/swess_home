import '../../../data/models/user.dart';

abstract class UserEditDataState {}

class UserEditDataNone extends UserEditDataState {}

class UserEditDataComplete extends UserEditDataState {
  User? user;

  UserEditDataComplete({required this.user});
}

class UserEditDataProgress extends UserEditDataState {}

class UserEditDataError extends UserEditDataState {
  final String? errorMessage;
  Map<String, dynamic>? errorResponse;
  final bool isConnectionError;

  final bool isUnauthorizedError;

  UserEditDataError({
    this.errorMessage,
    this.errorResponse,
    this.isConnectionError = false,
    this.isUnauthorizedError = false,
  });
}
