abstract class DeleteUserNewEstateEvent {}

class DeleteUserNewEstateFetchStarted extends DeleteUserNewEstateEvent {
  int? orderId;
  String? token;

  DeleteUserNewEstateFetchStarted({required this.orderId, required this.token});
}
