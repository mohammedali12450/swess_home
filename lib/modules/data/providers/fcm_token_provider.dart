import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class FcmTokenProvider {
  Future sendFcmToken({required String userToken}) async {
    NetworkHelper helper = NetworkHelper();
    Map<String, dynamic> data = {
      "FCM_token": firebaseToken,
    };
    Response response =
        await helper.post(fcmTokenURL, data, token: userToken);
    return response;
  }
}
