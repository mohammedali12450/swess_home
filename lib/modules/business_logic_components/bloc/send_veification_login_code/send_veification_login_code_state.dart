import 'package:swesshome/modules/data/models/user.dart';

abstract class SendVerificationCodeLoginState {}

class SendVerificationCodeLoginNone extends SendVerificationCodeLoginState {}

class SendVerificationCodeLoginProgress extends SendVerificationCodeLoginState {}

class SendVerificationCodeLoginError extends SendVerificationCodeLoginState {
  final String? errorMessage;

  dynamic errorResponse;
  final bool? isConnectionError;

  SendVerificationCodeLoginError({ this.errorMessage, this.errorResponse,  this.isConnectionError});
}

class SendVerificationCodeLoginComplete extends SendVerificationCodeLoginState {
  final User user;

  SendVerificationCodeLoginComplete({required this.user});
}
