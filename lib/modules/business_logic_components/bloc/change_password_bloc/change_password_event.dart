abstract class ChangePasswordEvent {}

class ChangePasswordStarted extends ChangePasswordEvent {
  final String token;

  final String oldPassword;

  final String newPassword;

  ChangePasswordStarted(
      {required this.oldPassword,
      required this.newPassword,
      required this.token});
}
