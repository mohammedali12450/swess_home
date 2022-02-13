import 'package:swesshome/modules/data/models/register.dart';

abstract class UserRegisterEvent{}

class UserRegisterStarted extends UserRegisterEvent{
  Register register ;
  UserRegisterStarted({required this.register});
}


