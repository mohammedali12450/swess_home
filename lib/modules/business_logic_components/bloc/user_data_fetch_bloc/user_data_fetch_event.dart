abstract class UserDataFetchEvent {}

class UserDataFetchStarted extends UserDataFetchEvent {
  String token;

  UserDataFetchStarted({required this.token});
}
