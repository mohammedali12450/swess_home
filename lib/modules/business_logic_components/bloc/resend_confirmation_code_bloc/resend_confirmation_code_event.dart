

abstract class ResendConfirmationCodeEvent{}
class ResendConfirmationCodeStarted extends ResendConfirmationCodeEvent{
  final String phoneNumber ;

  ResendConfirmationCodeStarted({required this.phoneNumber});
}





