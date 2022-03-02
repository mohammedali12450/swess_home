abstract class SavedEstatesEvent {}

class SavedEstatesFetchStarted extends SavedEstatesEvent {
  String token;

  SavedEstatesFetchStarted({required this.token});
}
