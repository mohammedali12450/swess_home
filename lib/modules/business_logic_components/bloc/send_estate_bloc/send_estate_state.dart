abstract class SendEstateState {}

class SendEstateError extends SendEstateState {
  final String errorMessage;
  final bool isConnectionError ;


  SendEstateError({required this.errorMessage , this.isConnectionError =false});
}

class SendEstateComplete extends SendEstateState {}

class SendEstateProgress extends SendEstateState {}

class SendEstateNone extends SendEstateState {}
