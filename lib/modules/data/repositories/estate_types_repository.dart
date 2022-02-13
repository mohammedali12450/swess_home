import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/providers/estate_types_provider.dart';

class EstateTypesRepository {
  EstateTypesProvider estateTypesProvider = EstateTypesProvider();

  Future<List<EstateType>> fetchData() async {
    Response response = await estateTypesProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    var estateTypesJson = jsonDecode(response.toString())['data'] as List;
    List<EstateType> estateTypes = estateTypesJson
        .map<EstateType>((e) => EstateType.fromJson(e))
        .toList();
    return estateTypes;
  }
}
