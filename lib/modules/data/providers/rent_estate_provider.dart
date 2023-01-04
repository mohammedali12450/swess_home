import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

import '../models/rent_estate.dart';

class RentEstateProviders {
  Future getRentEstates() async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(getRentEstatesURL);
    return response;
  }

  Future sendRentEstate(String? token, RentEstateRequest rentEstate) async {
    NetworkHelper helper = NetworkHelper();

    FormData data = FormData.fromMap(await rentEstate.toJson());

    Response response = await helper.post(addRentEstateURL, data, token: token);
    return response;
  }
}
