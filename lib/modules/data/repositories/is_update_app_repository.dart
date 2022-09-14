import 'dart:convert';
import 'package:dio/dio.dart';

import '../providers/is_updated_app_provider.dart';

class IsUpdateAppRepository {
  final IsUpdateAppProvider _isUpdateAppProvider = IsUpdateAppProvider();

  Future<String> getIsUpdateApp(bool isAndroid, String version) async {
    Response response =
        await _isUpdateAppProvider.isUpdateApp(isAndroid, version);
    String isUpdateApp = jsonDecode(response.toString());
    print("response is update app $response");
    print("is update app $isUpdateApp");
    return isUpdateApp;
  }
}
