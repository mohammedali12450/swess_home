




abstract class UserLoginState{}

class UserLoginNone extends UserLoginState{}
class UserLoginComplete extends UserLoginState{}
class UserLoginProgress extends UserLoginState{}
class UserLoginError extends UserLoginState{
  final String? errorMessage ;
  Map<String , dynamic>? errorResponse;
  UserLoginError({this.errorMessage, this.errorResponse});

}