




import 'package:swesshome/modules/data/models/user.dart';

abstract class UserRegisterState{}


class UserRegisterNone extends UserRegisterState{}
class UserRegisterProgress extends UserRegisterState{}
class UserRegisterComplete extends UserRegisterState{
  User user ;
  UserRegisterComplete({required this.user});
}
class UserRegisterError extends UserRegisterState{
  final String? errorMessage ;
  Map<String , dynamic>? errorResponse;
  UserRegisterError({this.errorMessage, this.errorResponse});
}

