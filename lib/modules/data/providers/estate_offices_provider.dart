import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateOfficeProvider {
  Future<Response> getEstatesByName(String name, String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(
           searchEstateOfficeByNameUrl,
          queryParameters: {"name": name},
          token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }

  // Future getEstatesByLocationId(int locationId) async {
  //   NetworkHelper helper = NetworkHelper();
  //   Response response;
  //
  //   try {
  //     response = await helper.post(
  //         "http://swesshomerealestate.com/api/estate/searchEstateByregionsByestatefeatures",
  //         queryParameters: {"locationId": locationId});
  //   } catch (_) {
  //     rethrow;
  //   }
  //
  //   return response;
  // }

  Future getEstatesByLocationId(int locationId) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.post(
        searchByregionUrl,
        {"location_id": locationId},
      );
      print(response.statusCode);
      print(response);
    } catch (e) {
      rethrow;
    }

    return response;
  }
}
