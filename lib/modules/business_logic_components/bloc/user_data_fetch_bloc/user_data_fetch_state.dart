import 'package:swesshome/modules/data/models/user.dart';

abstract class UserDataFetchState {}

class UserDataFetchComplete extends UserDataFetchState {
  User user;

  UserDataFetchComplete({required this.user});
}

class UserDataFetchError extends UserDataFetchState {}

class UserDataFetchProgress extends UserDataFetchState {}

class UserDataFetchNone extends UserDataFetchState {}
