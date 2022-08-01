abstract class ForgetPasswordEvent{}
class ForgetPasswordStarted extends ForgetPasswordEvent{
  final String mobile ;

  ForgetPasswordStarted({required this.mobile});
}