import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/area_unit.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/modules/data/providers/area_units_provider.dart';

import '../models/previous_search_zone.dart';
import '../providers/previous_search_results_provider.dart';

class PreviousSearchResultsRepository {
  PreviousSearchResultsProvider previousSearchResultsProvider = PreviousSearchResultsProvider();

  Future<List<Zone>> fetchData() async {
    Response response = await previousSearchResultsProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }


    List<Zone> zones=List<Zone>.from(response.data.map((x) => Zone.fromJson(x)));
    return zones;
  }
}
