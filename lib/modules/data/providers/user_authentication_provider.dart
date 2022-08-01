import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class UserAuthenticationProvider {
  Future register(Register register) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.post(userRegisterUrl, register.toJson());
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future loginByToken(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(userLoginByTokenUrl, token: token);
    return response;
  }

  Future login(String authentication, String password) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response =
          await helper.post(userLoginUrl, {"authentication": authentication, "password": password});
    } catch (_) {
      rethrow;
    }

    return response;
  }

  Future forgetPassword(String mobile) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.post(forgetPasswordUrl, {"authentication": mobile});
    } catch (e) {
      rethrow;
    }
    return response;
  }
  Future verificationCode(String mobile,String code) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.post(verificationUrl, {"authentication": mobile,"code":code});
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future resetPassword(String mobile,String password,String confirmPassword) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.post(resetPasswordUrl, {"authentication": mobile,"password":password,"password_confirmation":confirmPassword});
    } catch (e) {
      rethrow;
    }
    return response;
  }




  Future logout(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.delete(logoutUrl, token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future sendVerificationCode(String phone, String code) async {

    NetworkHelper helper = NetworkHelper();
    Response response =
    await helper.post(checkConfirmationCode, {"authentication": phone, "code": code});
    return response;
  }

  Future resendVerificationCode(String phone) async {

    NetworkHelper helper = NetworkHelper();
    Response response =
    await helper.post(resendConfirmationCode, {"authentication": phone});
    return response;
  }



  Future deleteUser(String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.delete(deleteUserUrl,token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }
}
