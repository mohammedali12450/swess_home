import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/models/zone_model.dart';
import '../providers/locations_provider.dart';

class LocationsRepository {

  final LocationsProvider _locationsProvider = LocationsProvider();

  Future<List<Location>> getLocations() async {
    Response response = await _locationsProvider.getLocations();
    var jsonLocations = jsonDecode(response.toString())["data"]["data"] as List ;
    List<Location> locations = jsonLocations.map<Location>((locationJson) =>
        Location.fromJson(locationJson)).toList();
    return locations ;
  }

  Future<List<Zone>> getZone() async {
    Response response = await _locationsProvider.getZone();
    var jsonZones = jsonDecode(response.data)['data'];
    List<Zone> zones = jsonZones.map<Zone>((e) => Zone.fromJson(e)).toList();
    return zones ;
  }
}