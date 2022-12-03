import 'package:swesshome/modules/data/models/register.dart';

import '../../../data/models/user.dart';

abstract class UserEditDataEvent {}

class UserEditDataStarted extends UserEditDataEvent {
  Register? user;
  String? token;

  UserEditDataStarted({this.user, this.token});
}
