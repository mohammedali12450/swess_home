abstract class ResetPasswordEvent{}
class ResetPasswordStarted extends ResetPasswordEvent{
  final String mobile ;
  final String newPassword ;
  final String confirmPassword ;

  ResetPasswordStarted({required this.newPassword,required this.confirmPassword, required this.mobile});
}