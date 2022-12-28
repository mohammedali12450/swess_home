import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class MessageProvider {
  Future sendMessage(String? token, String message) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response =
          await helper.post(sendMessageURL, {"subject": message}, token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future getMessages(String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.get(getMessagesURL, token: token);
    } catch (_) {
      rethrow;
    }
    return response;
  }
}
