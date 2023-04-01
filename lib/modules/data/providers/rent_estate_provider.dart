import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

import '../models/rent_estate.dart';

class RentEstateProviders {
  Future getRentEstates(RentEstateFilter rentEstateFilter, int page) async {
    NetworkHelper helper = NetworkHelper();

    FormData data = FormData.fromMap(await rentEstateFilter.toJson());

    Response response = await helper.post(
      filterRentEstateURL,
      data,
      queryParameters: {"page": page},
    );
    return response;
  }

  Future sendRentEstate(String token, RentEstateRequest rentEstate) async {
    NetworkHelper helper = NetworkHelper();

    FormData data = FormData.fromMap(await rentEstate.toJson());

    Response response = await helper.post(addRentEstateURL, data, token: token);
    return response;
  }

  Future getMyRentEstates(String token) async {
    NetworkHelper helper = NetworkHelper();

    Response response = await helper.get(getMyRentEstatesURL, token: token);
    return response;
  }

  Future deleteMyRentEstates(String token) async {
    NetworkHelper helper = NetworkHelper();

    Response response =
        await helper.delete(deleteMyRentEstatesURL, token: token);
    return response;
  }
}
