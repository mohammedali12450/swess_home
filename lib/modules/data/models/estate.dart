import 'dart:io';
import 'package:dio/dio.dart';
import 'package:swesshome/modules/data/models/area_unit.dart';
import 'package:swesshome/modules/data/models/estate_offer_type.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/models/interior_status.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/models/period_type.dart';

import 'estate_office.dart';
import 'image.dart';

class Estate {
  int? id;

  OwnershipType? ownershipType;

  EstateType? estateType;

  InteriorStatus? interiorStatus;

  EstateOfferType? estateOfferType;

  String? price;

  PeriodType? periodType;
  String? period;

  Location? location;
  int? locationId;

  AreaUnit? areaUnit;

  String? longitude;

  String? latitude;

  String? roomsCount;

  String? area;

  String? nearbyPlaces;

  String? description;

  bool? swimmingPool;

  bool? isFurnished;

  bool? onBeach;

  String? periodNumber;

  File? floorPlanImage;

  List<Image>? images;

  List<File>? estateImages;

  List<File>? streetImages;

  EstateOffice? estateOffice;

  int? contractId;

  String? createdAt;

  String? publishedAt;

  int? officeId;

  Estate(
      {this.id,
      this.ownershipType,
      this.estateType,
      this.interiorStatus,
      this.estateOfferType,
      this.price,
      this.periodType,
      this.location,
      this.areaUnit,
      this.officeId,
      this.images,
      this.publishedAt,
      this.longitude,
      this.latitude,
      this.roomsCount,
      this.area,
      this.nearbyPlaces,
      this.description,
      this.contractId,
      this.swimmingPool,
      this.isFurnished,
      this.onBeach,
      this.periodNumber,
      this.floorPlanImage,
      this.estateImages,
      this.streetImages,
      this.estateOffice,
      this.period,
      this.createdAt});

  factory Estate.fromJson(Map<String, dynamic> json) {
    var jsonImages = json.containsKey("images") ? json["images"] as List : null;
    List<Image>? images;
    if (jsonImages != null) {
      images = jsonImages.map((e) => Image.fromJson(e)).toList();
    }
    return Estate(
      id: json.containsKey("id") ? json["id"] : null,
      ownershipType:
          json.containsKey("ownership_type") && json["ownership_type"] != null
              ? OwnershipType.fromJson(json["ownership_type"])
              : null,
      estateType: json.containsKey("estate_type") && json["estate_type"] != null
          ? EstateType.fromJson(json["estate_type"])
          : null,
      interiorStatus:
          json.containsKey("interior_status") && json["interior_status"] != null
              ? InteriorStatus.fromJson(json["interior_status"])
              : null,
      estateOfferType: json.containsKey("estate_offer_type") &&
              json["estate_offer_type"] != null
          ? EstateOfferType.fromJson(json["estate_offer_type"])
          : null,
      price: json["price"],
      periodType: json.containsKey("period_type") && json["period_type"] != null
          ? PeriodType.fromJson(json["period_type"])
          : null,
      location: json.containsKey("location") && json["location"] != null
          ? Location.fromJson(json["location"])
          : null,
      areaUnit: json.containsKey("area_unit") && json["area_unit"] != null
          ? AreaUnit.fromJson(json["area_unit"])
          : null,
      estateOffice: EstateOffice.fromJson(json["office"]),
      images: images,
      longitude: json["longitude"],
      latitude: json["latitude"],
      contractId: json["contract_id"],
      period: json["period_number"],
      roomsCount: json["rooms_count"],
      createdAt: json["created_at"],
      publishedAt: json["published_at"],
      area: json["area"],
      nearbyPlaces: json["nearby_places"],
      description: json["description"],
      swimmingPool: json.containsKey("swimming_pool")
          ? (json["swimming_pool"] == 1)
          : null,
      isFurnished:
          json.containsKey("is_furnished") ? (json["is_furnished"] == 1) : null,
      onBeach: json.containsKey("on_beach") ? (json["on_beach"] == 1) : null,
      periodNumber: json["period_number"],
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> map = {};

    map["ownership_type_id"] = (ownershipType==null)?null:ownershipType!.id;
    map["estate_type_id"] = (estateType == null) ? null : estateType!.id;
    map["interior_status_id"] =
        (interiorStatus == null) ? null : interiorStatus!.id;
    map["estate_offer_type_id"] =
        (estateOfferType == null) ? null : estateOfferType!.id;
    map["period_type_id"] = (periodType == null) ? null : periodType!.id;
    map["period_number"] = periodNumber;
    map["area_unit_id"] = (areaUnit == null) ? null : areaUnit!.id;
    map["longitude"] = longitude;
    map["latitude"] = latitude;
    map["rooms_count"] = roomsCount;
    map["area"] = area;
    map["nearby_places"] = nearbyPlaces;
    map["location_id"] = locationId;
    map["estate_office_id"] = officeId;
    map["price"] = price;
    map["description"] = description;
    map["created_at"] = createdAt;
    map["is_furnished"] =
        (isFurnished != null) ? ((isFurnished!) ? 1 : 0) : null;
    map["swimming_pool"] =
        (swimmingPool != null) ? ((swimmingPool!) ? 1 : 0) : null;
    map["on_beach"] = (onBeach != null) ? ((onBeach!) ? 1 : 0) : null;
    map["floor_plan"] = (floorPlanImage == null)
        ? null
        : await MultipartFile.fromFile(floorPlanImage!.path);
    map["estate_images[]"] = await createImagesList(estateImages);
    map["street_images[]"] = await createImagesList(streetImages);
    return map;
  }

  Future<List<MultipartFile>> createImagesList(List<File>? files) async {
    if (files == null) return [];
    List<MultipartFile> results = [];
    for (var file in files) {
      MultipartFile multipartFile = await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last);
      results.add(multipartFile);
    }
    return results;
  }
}
