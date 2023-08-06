import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateTypesProvider {
  Future fetchData() async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(estateTypesURL);
    return response;
  }

  Future fetchDataByLocation(int location_id) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(estateTypeByLocation,
        queryParameters: {"location_id": location_id});
    return response;
  }
}
