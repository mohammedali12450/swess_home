import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/providers/user_authentication_provider.dart';

class UserAuthenticationRepository {
  UserAuthenticationProvider userAuthenticationProvider = UserAuthenticationProvider();

  Future register(Register register) async {
    Response response;

    try {
      response = await userAuthenticationProvider.register(register);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }
    if (response.statusCode != 201) {
      throw UnknownException();
    }

    User user = User.fromJson(jsonDecode(response.toString())["data"]);
    return user;
  }

  Future<User> loginByToken(String token) async {
    Response response = await userAuthenticationProvider.loginByToken(token);
    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }
    if (response.statusCode != 200) {
      throw UnknownException();
    }
    User user = User.fromJson(jsonDecode(response.toString())["data"]);
    return user;
  }

  Future login(String authentication, String password) async {
    Response response;

    try {
      response = await userAuthenticationProvider.login(authentication, password);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }
    if (response.statusCode != 200) {
      throw UnknownException();
    }

    User user = User.fromJson(jsonDecode(response.toString())["data"]);
    return user;
  }

  Future logout(String token) async {
    Response response;

    try {
      response = await userAuthenticationProvider.logout(token);
    } catch (e) {
      rethrow;
    }
    if (response.statusCode != 200) {
      throw UnknownException();
    }
  }
}
