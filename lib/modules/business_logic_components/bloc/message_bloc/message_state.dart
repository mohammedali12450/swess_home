import 'package:swesshome/modules/data/models/message.dart';

abstract class MessageState {}

class SendMessageFetchComplete extends MessageState {}

class MessageFetchNone extends MessageState {}

class SendMessageFetchProgress extends MessageState {}

class MessageFetchError extends MessageState {
  String error;

  MessageFetchError({required this.error});
}

class GetMessageFetchComplete extends MessageState {
  List<Message> messages;

  GetMessageFetchComplete({required this.messages});
}

class GetMessageFetchProgress extends MessageState {}
