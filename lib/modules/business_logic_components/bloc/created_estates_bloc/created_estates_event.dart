abstract class CreatedEstatesEvent {}

class CreatedEstatesFetchStarted extends CreatedEstatesEvent {
  String token;

  CreatedEstatesFetchStarted({required this.token});
}
