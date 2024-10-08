import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/modules/data/providers/estate_offices_provider.dart';

class EstateOfficesRepository {
  final EstateOfficeProvider _estateOfficeProvider = EstateOfficeProvider();

  Future<List<EstateOffice>> searchEstateOfficesByName(
      String? name, String? token, int page) async {
    Response response;

    try {
      response =
          await _estateOfficeProvider.getEstatesByName(name, token, page);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }

    var estateOfficesList = jsonDecode(response.toString())["data"] as List;
    List<EstateOffice> estateOffices = estateOfficesList
        .map<EstateOffice>((jsonOffice) => EstateOffice.fromJson(jsonOffice))
        .toList();

    return estateOffices;
  }

  Future<List<EstateOffice>> searchEstateOfficesByLocationId(
      int locationId, int page) async {
    Response response;

    try {
      response =
          await _estateOfficeProvider.getEstatesByLocationId(locationId, page);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }

    var estateOfficesList =
        jsonDecode(response.toString())["data"]as List;
    List<EstateOffice> estateOffices = estateOfficesList
        .map<EstateOffice>((jsonOffice) => EstateOffice.fromJson(jsonOffice))
        .toList();

    return estateOffices;
  }
}
