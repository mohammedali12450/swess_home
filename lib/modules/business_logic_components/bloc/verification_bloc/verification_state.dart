import 'package:swesshome/modules/data/models/user.dart';

abstract class VerificationCodeState {}

class VerificationCodeNone extends VerificationCodeState {}

class VerificationCodeError extends VerificationCodeState {
  final String? errorMessage;

  dynamic errorResponse;
  final bool isConnectionError;

  VerificationCodeError({this.errorMessage, this.errorResponse, this.isConnectionError = false});
}

class VerificationCodeProgress extends VerificationCodeState {}

class VerificationCodeComplete extends VerificationCodeState {
  final User? user;

  VerificationCodeComplete({this.user});

}
