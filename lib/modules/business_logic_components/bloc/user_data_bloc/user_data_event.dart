abstract class UserDataEvent {}

class UserDataStarted extends UserDataEvent {
  String? token;

  UserDataStarted({this.token});
}
