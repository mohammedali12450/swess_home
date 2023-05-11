import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/providers/user_authentication_provider.dart';

import '../../../core/storage/shared_preferences/user_shared_preferences.dart';

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
      throw UnauthorizedException(
          message: jsonDecode(response.toString())["message"]);
    }

    if (response.statusCode == 400) {
      throw GeneralException(
          errorMessage: jsonDecode(response.toString())["message"]);
    }

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    User user = User.fromJson(jsonDecode(response.toString())["data"]["user"]);

    UserSharedPreferences.setAccessToken(
        jsonDecode(response.toString())["data"]["token"]);

    return user;
  }

  Future socialLogin(String provider, String token) async {
    Response response;

    try {
      response = await userAuthenticationProvider.socialLogin(provider, token);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }

    if (response.statusCode == 403) {
      throw UnauthorizedException(
          message: jsonDecode(response.toString())["message"]);
    }

    if (response.statusCode == 400) {
      throw GeneralException(
          errorMessage: jsonDecode(response.toString())["message"]);
    }

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    User user = User.fromJson(jsonDecode(response.toString())["data"]["user"]);

    UserSharedPreferences.setAccessToken(
      jsonDecode(response.toString())["data"]["token"],
    );

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
      throw FieldsException(
          jsonErrorFields: jsonDecode(response.toString())["message"]);
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

  Future changePassword(
      String oldPassword, String newPassword, String token) async {
    Response response;

    try {
      response = await userAuthenticationProvider.changePassword(
          oldPassword, newPassword, token);
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
      throw GeneralException(errorMessage: jsonDecode(response.toString()));
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

  Future sendVerificationCode(String phone, String code) async {
    Response response;
    try {
      response =
          await userAuthenticationProvider.sendVerificationCode(phone, code);
    } catch (e) {
      rethrow;
    }
    if (response.statusCode == 403) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }
    User user = User.fromJson(jsonDecode(response.toString())["data"]);

    return user;
  }

  Future sendVerificationLoginCode(String phone, String code) async {
    Response response;
    try {
      response = await userAuthenticationProvider.sendVerificationLoginCode(
          phone, code);
      print(response);
    } catch (e) {
      rethrow;
    }
    if (response.statusCode == 403) {
      throw FieldsException(
          jsonErrorFields: jsonDecode(response.toString())["message"]);
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
    return response;
  }

  Future getUser(String token) async {
    Response response;

    try {
      response = await userAuthenticationProvider.getUser(token);
    } catch (e) {
      rethrow;
    }
    if (response.statusCode != 200) {
      throw UnauthorizedException(
          message: jsonDecode(response.toString())["message"]);
    }
    User user = User.fromJson(jsonDecode(response.toString())["data"]);
    return user;
  }

  Future editUserData(String token, Register user) async {
    Response response;

    try {
      response = await userAuthenticationProvider.editUserData(token, user);
    } catch (e) {
      rethrow;
    }
    if (response.statusCode != 200) {
      throw UnauthorizedException(
          message: jsonDecode(response.toString())["message"]);
    }

    User userr = User.fromJson(jsonDecode(response.toString())["data"]);

    return userr;
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
}
