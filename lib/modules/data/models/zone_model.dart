import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Zone> zonesFromJson(String str) =>
    List<Zone>.from(json.decode(str).map((x) => Zone.fromJson(x)));

class Zone {
  int? id;
  String? name;
  int? status;
  String? color;
  int? locationId;
  List<LatLng>? coordinates;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  LocationZone? location;

  Zone({
    this.id,
    this.name,
    this.status,
    this.color,
    this.locationId,
    this.coordinates,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.location,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        color: json["color"],
        coordinates: json["coordinates"] == null
            ? null
            : List<LatLng>.from(
                jsonDecode(json["coordinates"]).map((x) => LatLng(x[1], x[0]))),
        locationId: json["location_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        location: json["location"] == null
            ? null
            : LocationZone.fromJson(json["location"]),
      );
}

class LocationZone {
  int? id;
  String? name;
  String? longitude;
  String? latitude;
  String? locationFullName;
  LocationZone? parent;

  LocationZone({
    this.id,
    this.name,
    this.longitude,
    this.latitude,
    this.locationFullName,
    this.parent,
  });

  factory LocationZone.fromJson(Map<String, dynamic> json) => LocationZone(
        id: json["id"],
        name: json["name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        locationFullName: json["location_full_name"],
        parent: json["parent"] == null
            ? null
            : LocationZone.fromJson(json["parent"]),
      );
}
