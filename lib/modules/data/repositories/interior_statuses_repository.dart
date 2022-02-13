import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/interior_status.dart';
import 'package:swesshome/modules/data/providers/interior_statuses_provider.dart';

class InteriorStatusesRepository {
  InteriorStatusesProvider interiorStatusesProvider =
      InteriorStatusesProvider();

  Future<List<InteriorStatus>> fetchData() async {
    Response response = await interiorStatusesProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    var interiorStatusesJson = jsonDecode(response.toString())['data'] as List;
    List<InteriorStatus> interiorStatusesTypes = interiorStatusesJson
        .map<InteriorStatus>((e) => InteriorStatus.fromJson(e))
        .toList();

    return interiorStatusesTypes;
  }
}
