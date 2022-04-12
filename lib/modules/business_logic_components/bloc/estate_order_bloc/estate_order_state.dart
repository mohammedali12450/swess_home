abstract class EstateOrderState {}

class SendEstateOrderNone extends EstateOrderState {}

class SendEstateOrderProgress extends EstateOrderState {}

class SendEstateOrderComplete extends EstateOrderState {}

class SendEstateOrderError extends EstateOrderState {
  String error;

  bool isAuthorizationError;

  final bool isConnectionError;

  SendEstateOrderError(
      {required this.error, this.isAuthorizationError = false, this.isConnectionError = false});
}
