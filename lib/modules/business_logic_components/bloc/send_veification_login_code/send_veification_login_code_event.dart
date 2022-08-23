abstract class SendVerificationCodeLoginEvent {}

class VerificationCodeSendingLoginStarted extends SendVerificationCodeLoginEvent {
  final String phone;

  final String code;

  VerificationCodeSendingLoginStarted({required this.phone, required this.code});
}
