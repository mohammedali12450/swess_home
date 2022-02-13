abstract class UserLoginEvent {}

class UserLoginStarted extends UserLoginEvent {
  String authentication;

  String password;

  UserLoginStarted({required this.authentication, required this.password});
}
