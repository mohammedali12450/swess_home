abstract class VerificationCodeEvent{}
class VerificationCodeStarted extends VerificationCodeEvent{
  final String mobile ;
  final String verificationCode ;

  VerificationCodeStarted( {required this.verificationCode,required this.mobile});
}