import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateOfficeProvider {
  Future<Response> getEstatesByName(String name) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper
        .get(searchEstateOfficeByNameUrl, queryParameters: {"name": name});

    return response;
  }
  Future<Response> getEstatesByLocationId(int locationId) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper
        .get(searchEstateOfficeByLocationIdUrl, queryParameters: {"location_id": locationId});
    return response;
  }
}
