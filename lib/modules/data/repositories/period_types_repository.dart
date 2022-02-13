import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/period_type.dart';
import 'package:swesshome/modules/data/providers/period_types_provider.dart';

class PeriodTypeRepository {
  PeriodTypesProvider periodTypesProvider = PeriodTypesProvider();

  Future<List<PeriodType>> fetchData() async {
    Response response = await periodTypesProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    var periodTypesJson = jsonDecode(response.toString())['data'] as List;
    List<PeriodType> periodTypes =
        periodTypesJson.map<PeriodType>((e) => PeriodType.fromJson(e)).toList();

    return periodTypes;
  }
}
