abstract class SendEstateState {}

class SendEstateError extends SendEstateState {
  final String errorMessage;

  SendEstateError({required this.errorMessage});
}

class SendEstateComplete extends SendEstateState {}

class SendEstateProgress extends SendEstateState {}

class SendEstateNone extends SendEstateState {}
