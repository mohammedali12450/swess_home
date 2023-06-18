import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class ContactUsProvider {

  Future sendDirectMessage(String email,String subject,String message) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.post(sendDirectMessageURL, {
        "sender_email": email,
        "subject": subject,
        "message": message
      });
    } catch (_) {
      rethrow;
    }
    return response;
  }

}
