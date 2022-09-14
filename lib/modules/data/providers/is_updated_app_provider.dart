import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class IsUpdateAppProvider {
  Future isUpdateApp(bool isAndroid, String version) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.post(
          isAndroid ? isUpdatedForAndroidUrl : isUpdatedForIosUrl,
          {"version1": version});
    } catch (_) {
      rethrow;
    }
    return response;
  }
}
