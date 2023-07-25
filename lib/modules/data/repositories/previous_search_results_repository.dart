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

  Future<SearchResults> fetchData() async {
    Response response = await previousSearchResultsProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }


    SearchResults searchResults=SearchResults.fromJson(response.data);
    return searchResults;
  }
}
