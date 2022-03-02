import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/providers/fcm_token_provider.dart';

class FcmTokenRepository {
  FcmTokenProvider sendFcmTokenProvider = FcmTokenProvider();

  Future sendFcmToken({required String token}) async {
    Response response =
        await sendFcmTokenProvider.sendFcmToken(userToken: token);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw UnknownException();
    }
    return response;
  }
}
