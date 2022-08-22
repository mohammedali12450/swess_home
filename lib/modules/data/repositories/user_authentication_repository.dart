import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/providers/user_authentication_provider.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class UserAuthenticationRepository {
  UserAuthenticationProvider userAuthenticationProvider =
      UserAuthenticationProvider();

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

  Future verificationCode(String mobile, String code) async {
    Response response;

    try {
      response =
          await userAuthenticationProvider.verificationCode(mobile, code);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }
    if (response.statusCode != 200) {
      throw GeneralException(
          errorMessage: jsonDecode(response.toString())["message"]);
    }
    // User user = User.fromJson(jsonDecode(response.toString())["data"]);
    // return user;
  }

  Future resetPassword(
      String mobile, String password, String confirmPassword) async {
    Response response;

    try {
      response = await userAuthenticationProvider.resetPassword(
          mobile, password, confirmPassword);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }
    if (response.statusCode != 200) {
      throw GeneralException(
          errorMessage: jsonDecode(response.toString())["message"]);
    }
    // User user = User.fromJson(jsonDecode(response.toString())["data"]);
    // return user;
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
      response =
          await userAuthenticationProvider.login(authentication, password);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }

    if (response.statusCode == 403) {
      throw UnauthorizedException(message: "Unauthorized error !");
    }

    if (response.statusCode == 401) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    User user = User.fromJson(jsonDecode(response.toString())["data"]);
    return user;
  }

  Future forgetPassword(String mobile) async {
    Response response;

    try {
      response = await userAuthenticationProvider.forgetPassword(mobile);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }
    if (response.statusCode != 200) {
      throw GeneralException(
          errorMessage: jsonDecode(response.toString())["message"]);
    }
    // User user = User.fromJson(jsonDecode(response.toString())["data"]);
    // return user;
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

  Future deleteUser(String token) async {
    Response response;

    try {
      response = await userAuthenticationProvider.deleteUser(token);
    } catch (e) {
      rethrow;
    }
    if (response.statusCode != 200) {
      throw UnauthorizedException(message: "Unauthorized error !");
    }
  }

  Future sendVerificationCode(String phone, String code) async {
    Response response;
    try {
      response =
          await userAuthenticationProvider.sendVerificationCode(phone, code);
    } catch (e) {
      rethrow;
    }
    User user = User.fromJson(jsonDecode(response.toString())["data"]);

    return user;
  }

  Future resendVerificationCode(String phone) async {
    Response response;
    try {
      response = await userAuthenticationProvider.resendVerificationCode(phone);
    } catch (e) {
      rethrow;
    }
  }
}
