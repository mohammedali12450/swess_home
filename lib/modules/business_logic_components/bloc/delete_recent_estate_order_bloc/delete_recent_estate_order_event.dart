abstract class DeleteEstatesEvent {}

class DeleteEstatesFetchStarted extends DeleteEstatesEvent {
  int? orderId;
  String? token;

  DeleteEstatesFetchStarted({required this.token, required this.orderId});
}
