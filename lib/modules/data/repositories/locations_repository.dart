import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/providers/locations_provider.dart';

class LocationsRepository {

  final LocationsProvider _locationsProvider = LocationsProvider();

  Future<List<Location>> getLocations() async {
    Response response = await _locationsProvider.getLocations();
    var jsonLocations = jsonDecode(response.toString())["data"]["data"] as List ;
    List<Location> locations = jsonLocations.map<Location>((locationJson) =>
        Location.fromJson(locationJson)).toList();
    return locations ;
  }
}