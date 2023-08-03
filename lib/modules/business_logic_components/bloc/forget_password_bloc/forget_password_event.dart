abstract class ForgetPasswordEvent{}
class ForgetPasswordStarted extends ForgetPasswordEvent{
  final String mobile ;

  ForgetPasswordStarted({required this.mobile});
}
class ForgetPasswordBeforeEndTimer extends ForgetPasswordEvent{
  final String mobile ;
  ForgetPasswordBeforeEndTimer({required this.mobile});
}