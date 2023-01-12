import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';

import '../../../data/models/message.dart';
import '../../../data/repositories/send_message_repository.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessagesEvent, MessageState> {
  final MessageRepository _messageRepository;

  bool isFetching = false;
  bool? message;
  List<Message>? messages;
  int page = 1;

  MessageBloc(this._messageRepository) : super(MessageFetchNone()) {
    on<SendMessagesFetchStarted>((event, emit) async {
      emit(SendMessageFetchProgress());
      try {
        message =
            await _messageRepository.sendMessage(event.token, event.message);
        emit(SendMessageFetchComplete());
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(MessageFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
    on<GetMessagesFetchStarted>((event, emit) async {
      emit(GetMessageFetchProgress());
      try {
        messages = await _messageRepository.getMessages(event.token!,page);
        emit(GetMessageFetchComplete(messages: messages!));
        page ++;
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(MessageFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
  }
}
