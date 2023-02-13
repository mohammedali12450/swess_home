
abstract class ShareEvent {}

class ShareStarted extends ShareEvent {
  int estateId;
  String? token;

  ShareStarted({required this.estateId, required this.token });
}
