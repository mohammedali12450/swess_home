import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class LoggingHistoryProvider {
  Future<Response> getLoggingHistory(String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.get(loggingHistoryURL,token: token);
    } catch (e) {
      rethrow;
    }
    return response;
  }
}
