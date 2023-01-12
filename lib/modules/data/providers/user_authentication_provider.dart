import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class UserAuthenticationProvider {
  Future register(Register register) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.post(userRegisterURL, register.toJson());
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future login(String authentication, String password) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.post(userLoginURL,
          {"authentication": authentication, "password": password});
    } catch (_) {
      rethrow;
    }

    return response;
  }

  Future forgetPassword(String mobile) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response =
          await helper.post(sendCodeURL, {"authentication": mobile});
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future verificationCode(String mobile, String code) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper
          .post(verificationCodeURL, {"authentication": mobile, "code": code});
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future resetPassword(
      String mobile, String password, String confirmPassword) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.post(resetPasswordURL, {
        "authentication": mobile,
        "password": password,
        "password_confirmation": confirmPassword
      });
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future logout(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.delete(logoutURL, token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future sendVerificationCode(String phone, String code) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper
        .post(checkCodeURL, {"authentication": phone, "code": code});
    return response;
  }

  Future sendVerificationLoginCode(String phone, String code) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper
        .post(multiLoginURL, {"authentication": phone, "code": code});
    return response;
  }

  Future resendVerificationCode(String phone) async {
    NetworkHelper helper = NetworkHelper();
    Response response =
        await helper.post(resendCodeURL, {"authentication": phone});
    return response;
  }

  Future getUser(String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(userDataURL, token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future editUserData(String? token, Register user) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    print(user.toJsonEdit());
    try {
      response =
          await helper.post(userEditDataURL, user.toJsonEdit(), token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future deleteUser(String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.delete(deleteUserURL, token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }
}
