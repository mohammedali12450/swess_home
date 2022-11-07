abstract class ResendVerificationCodeEvent{}
class ResendVerificationCodeStarted extends ResendVerificationCodeEvent{
  final String mobile ;
  final String verificationCode ;

  ResendVerificationCodeStarted( {required this.verificationCode,required this.mobile});
}