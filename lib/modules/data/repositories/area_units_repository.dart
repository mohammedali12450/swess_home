import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/area_unit.dart';
import 'package:swesshome/modules/data/providers/area_units_provider.dart';

class AreaUnitsRepository {
  AreaUnitsProvider areaUnitsProvider = AreaUnitsProvider();

  Future<List<AreaUnit>> fetchData() async {
    Response response = await areaUnitsProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    var areaUnitsJson = jsonDecode(response.toString())['data'] as List;
    List<AreaUnit> areaUnits = areaUnitsJson
        .map<AreaUnit>((e) => AreaUnit.fromJson(e))
        .toList();
    return areaUnits;
  }
}
