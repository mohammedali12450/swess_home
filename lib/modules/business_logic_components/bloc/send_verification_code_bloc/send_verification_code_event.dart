abstract class SendVerificationCodeEvent {}

class VerificationCodeSendingStarted extends SendVerificationCodeEvent {
  final String phone;

  final String code;

  VerificationCodeSendingStarted({required this.phone, required this.code});
}
