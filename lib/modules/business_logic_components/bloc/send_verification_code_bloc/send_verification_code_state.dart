import 'package:swesshome/modules/data/models/user.dart';

abstract class SendVerificationCodeState {}

class SendVerificationCodeNone extends SendVerificationCodeState {}

class SendVerificationCodeProgress extends SendVerificationCodeState {}

class SendVerificationCodeError extends SendVerificationCodeState {
  final String? errorMessage;

  dynamic errorResponse;
  final bool? isConnectionError;

  SendVerificationCodeError({ this.errorMessage, this.errorResponse,  this.isConnectionError});
}

class SendVerificationCodeComplete extends SendVerificationCodeState {
  final User user;

  SendVerificationCodeComplete({required this.user});
}
