import 'package:swesshome/modules/data/models/user.dart';

abstract class SendVerificationCodeState {}

class SendVerificationCodeNone extends SendVerificationCodeState {}

class SendVerificationCodeProgress extends SendVerificationCodeState {}

class SendVerificationCodeError extends SendVerificationCodeState {
  final String error;

  final bool isConnectionError;

  SendVerificationCodeError({required this.error, required this.isConnectionError});
}

class SendVerificationCodeComplete extends SendVerificationCodeState {
  final User user;

  SendVerificationCodeComplete({required this.user});
}
