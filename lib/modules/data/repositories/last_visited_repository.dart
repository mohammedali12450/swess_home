import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/exceptions/general_exception.dart';
import '../models/estate.dart';
import '../providers/last_vsited_provider.dart';

class LastVisitedRepository {

  final LastVisitedProvider _lastVisitedProvider = LastVisitedProvider();

  Future getLastVisitedEstates(String token) async {
    Response response;

    try {
      response = await _lastVisitedProvider.getLastVisitedEstates(token);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "! لا يمكن الاتصال بالسيرفر");
    }

    dynamic jsonEstates = jsonDecode(response.toString())["data"];
    List<Estate> estates = [];
    estates = jsonEstates.map<Estate>((e) => Estate.fromJson(e)).toList();
    return estates;
  }
}
