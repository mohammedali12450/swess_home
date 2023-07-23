
abstract class ResendRegisterConfirmationLinkEvent{}

class ResendRegisterConfirmationLinkStarted extends ResendRegisterConfirmationLinkEvent{
  final String phoneNumber ;

  ResendRegisterConfirmationLinkStarted({required this.phoneNumber});
}





