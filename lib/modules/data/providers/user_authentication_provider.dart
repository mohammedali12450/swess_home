import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class UserAuthenticationProvider {
  Future register(Register register) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.post(userRegisterUrl, register.toJson());
    return response;
  }

  Future loginByToken(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper
        .get(userLoginByTokenUrl , token: token);
    return response ;
  }



  Future login(String authentication, String password) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.post(
        userLoginUrl, {"authentication": authentication, "password": password});
    return response;
  }

  Future logout(String token)async{
    NetworkHelper helper = NetworkHelper();
    Response response = await helper
        .delete(logoutUrl , token: token);
    return response ;
  }



}
