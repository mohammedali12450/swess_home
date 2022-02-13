import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/modules/data/providers/estate_provider.dart';

class EstateRepository {
  final EstateProvider _estateProvider = EstateProvider();

  Future sendEstate(Estate estate, String token,
      {Function(int)? onSendProgress}) async {
    Response response = await _estateProvider.sendEstate(estate, token,
        onSendProgress: onSendProgress);

    if (response.statusCode != 201) {
      throw UnknownException();
    }
    return response;
  }

  Future search(SearchData searchData, bool isAdvanced, int page) async {
    Response response =
        await _estateProvider.search(searchData, isAdvanced, page);

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ");
    }

    dynamic jsonEstates = jsonDecode(response.toString())["data"];
    List<Estate> estates = [];
    // check if result estates is list :
    if (jsonEstates is List) {
      estates = jsonEstates.map<Estate>((e) => Estate.fromJson(e)).toList();
      return estates;
    }
    // check if result estates is map :
    else if (jsonEstates is Map) {
      estates = jsonEstates.values.map((e) => Estate.fromJson(e)).toList();
      return estates;
    }
    return estates;
  }

  Future getOfficeEstates(int officeId) async {
    Response response = await _estateProvider.getOfficeEstates(officeId);

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "! لا يمكن الاتصال بالسيرفر");
    }

    dynamic jsonEstates = jsonDecode(response.toString())["data"];
    List<Estate> estates = [];
    estates = jsonEstates.map<Estate>((e) => Estate.fromJson(e)).toList();
    return estates;
  }
}
