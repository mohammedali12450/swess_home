import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/providers/regions_provider.dart';

class RegionsRepository {

  final RegionsProvider _regionsProvider = RegionsProvider();

  Future<List<Location>> getRegions() async {
    Response response = await _regionsProvider.getRegions();
    var jsonLocations = jsonDecode(response.toString())["data"] as List ;
    List<Location> locations = jsonLocations.map<Location>((locationJson) =>
        Location.fromJson(locationJson)).toList();
    return locations ;
  }
}