import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';

import '../models/rent_estate.dart';
import '../providers/rent_estate_provider.dart';

class RentEstateRepository {
  final RentEstateProviders _estateProviders = RentEstateProviders();

  Future<List<RentEstate>> getRentEstates(
      RentEstateFilter rentEstateFilter, int page) async {
    Response response =
        await _estateProviders.getRentEstates(rentEstateFilter, page);
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    var jsonReports = jsonDecode(response.toString())["data"] as List;
    List<RentEstate> reports =
        jsonReports.map((e) => RentEstate.fromJson(e)).toList();
    return reports;
  }

  Future<bool> sendRentEstate(
      String token, RentEstateRequest rentEstate) async {
    Response response =
        await _estateProviders.sendRentEstate(token, rentEstate);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<List<RentEstate>> getMyRentEstates(
     String token) async {
    Response response =
    await _estateProviders.getMyRentEstates(token);
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    var jsonReports = jsonDecode(response.toString())["data"] as List;
    List<RentEstate> reports =
    jsonReports.map((e) => RentEstate.fromJson(e)).toList();
    return reports;
  }
}
