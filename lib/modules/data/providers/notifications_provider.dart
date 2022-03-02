import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class NotificationsProvider {
  Future<Response> getNotificationTypes() async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(notificationTypesUrl);
    } catch (_) {
      rethrow;
    }
    return response;
  }

  Future<Response> getNotifications(String token) async {
    NetworkHelper helper = NetworkHelper();

    Response response;

    try {
      response = await helper.get(notificationsUrl, token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }
}
