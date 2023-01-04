import 'package:dio/dio.dart';

import '../../../constants/api_paths.dart';
import '../../../utils/services/network_helper.dart';

class LastVisitedProvider {
  Future getLastVisitedEstates(String token) async {
    NetworkHelper helper = NetworkHelper();

    Response response;
    try {
      response = await helper.get(lastVisitedEstateURL,token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }
}
