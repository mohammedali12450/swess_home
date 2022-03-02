
// Event
abstract class FcmEvent {}

class SendFcmTokenProcessStarted extends FcmEvent {
  String userToken ;
  SendFcmTokenProcessStarted({required this.userToken});
}
