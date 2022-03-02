import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateOfficeProvider {
  Future<Response> getEstatesByName(String name, String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(searchEstateOfficeByNameUrl,
          queryParameters: {"name": name}, token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future<Response> getEstatesByLocationId(int locationId, String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(searchEstateOfficeByLocationIdUrl,
          queryParameters: {"location_id": locationId}, token: token);
    } catch (_) {
      rethrow;
    }

    return response;
  }
}
