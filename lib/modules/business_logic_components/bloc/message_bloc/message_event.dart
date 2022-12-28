abstract class MessagesEvent{}
class SendMessagesFetchStarted extends MessagesEvent{
  String? token;
  String? message;

  SendMessagesFetchStarted({this.token, this.message});
}

class GetMessagesFetchStarted extends MessagesEvent{
  String? token;

  GetMessagesFetchStarted({this.token});
}