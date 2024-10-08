import 'dart:convert';
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
import 'my_image.dart';

class Estate {
  int? id;
  OwnershipType? ownershipType;
  EstateType? estateType;
  InteriorStatus? interiorStatus;
  EstateOfferType? estateOfferType;
  String? price;
  EstateOffice? estateOffice;
  String? locationS;
  Location? location;
  AreaUnit? areaUnit;
  List<MyImage>? images;
  String? longitude;
  String? latitude;
  String? roomsCount;
  String? area;
  String? nearbyPlaces;
  String? description;
  bool? hasSwimmingPool;
  bool? isFurnished;
  bool? isOnBeach;
  String? period;
  String? floor;
  int? likesCount;
  int? visitCount;
  String? createdAt;
  String? publishedAt;
  String? videoUrl;

  bool? isLiked;
  bool? isSaved;
  int? contractId;

  List<File>? estateImages;
  int? officeId;
  List<File>? streetImages;
  List<File>? floorPlanImages;
  PeriodType? periodType;
  int? locationId;
  int? estateStatus;
  int? officeStatus;
  String? phone;
  String? viewer;
  String? firstImage;
  String? estateTypeName;
  String? estateOfferTypeName;
  String? periodTypeName;
  String? areaUnitName;
  String? ownershipTypeName;

  Estate(
      {this.price,
      this.estateImages,
      this.estateOfferType,
      this.estateType,
      this.location,
      this.area,
      this.areaUnit,
      this.images,
      this.locationId,
      this.officeId,
      this.id = -1,
      this.streetImages,
      this.floorPlanImages,
      this.ownershipType,
      this.period,
      this.longitude,
      this.latitude,
      this.roomsCount,
      this.nearbyPlaces,
      this.floor,
      this.description,
      this.isFurnished,
      this.hasSwimmingPool,
      this.isOnBeach,
      this.interiorStatus,
      this.periodType,
      this.estateOffice,
      this.contractId,
      this.createdAt,
      this.publishedAt,
      this.isLiked,
      this.isSaved,
      this.likesCount,
      this.visitCount,
      this.locationS,
      this.videoUrl,
      this.phone,
      this.viewer,
      this.firstImage,
      this.estateOfferTypeName,
      this.areaUnitName,
      this.estateTypeName,
      this.ownershipTypeName,
      this.periodTypeName,
      this.estateStatus,
      this.officeStatus});

  factory Estate.init() {
    // important : this constructor was built to pass estate object through multi screens :
    return Estate(
      estateOfferType: EstateOfferType.init(),
      estateType: EstateType.init(),
      areaUnit: AreaUnit.init(),
      //location: Location.init(),
      officeId: -1,
      locationId: -1,
      price: "default",
      area: "default",
      estateImages: [],
      images: [],
    );
  }

  factory Estate.fromJsonS(Map<String, dynamic> json) {
    // estate type :
    EstateType estateType = EstateType.fromJson(json["estate_type"]);
    // Offer type :
    EstateOfferType estateOfferType =
        EstateOfferType.fromJson(json["estate_offer_type"]);
    // estate location :

    String? locationS;
    if (json.containsKey("locationS") && json["locationS"] != null) {
      locationS = json["locationS"];
    }
    List<MyImage> images = [];
    dynamic jsonImages = json["images"];
    if (jsonImages is List) {
      images = jsonImages.map((e) => MyImage.fromJson(e)).toList();
    } else if (jsonImages is Map) {
      images = jsonImages.values.map((e) => MyImage.fromJson(e)).toList();
    }
    // area unit :
    AreaUnit? areaUnit;
    if (json.containsKey("area_unit") && json["area_unit"] != null) {
      areaUnit = AreaUnit.fromJson(json["area_unit"]);
    }

    // ownership type :
    OwnershipType? ownershipTypes;
    if (json.containsKey("ownership_type") && json["ownership_type"] != null) {
      ownershipTypes = OwnershipType.fromJson(json["ownership_type"]);
    }
    // interior status :
    InteriorStatus? interiorStatus;
    if (json.containsKey("interior_status") &&
        json["interior_status"] != null) {
      interiorStatus = InteriorStatus.fromJson(json["interior_status"]);
    }

    // Estate Office :
    EstateOffice? estateOffice;
    if (json.containsKey("office") && json["office"] != null) {
      estateOffice = EstateOffice.fromJson(json["office"]);
    }

    // swimming pool:
    bool? hasSwimmingPool;
    if (json.containsKey("swimming_pool") && json["swimming_pool"] != null) {
      hasSwimmingPool = (json["swimming_pool"] == 1);
    }
    // is furnished :
    bool? isFurnished;
    if (json.containsKey("is_furnished") && json["is_furnished"] != null) {
      isFurnished = (json["is_furnished"] == 1);
    }
    // is furnished :
    bool? isOnBeach;
    if (json.containsKey("on_beach") && json["on_beach"] != null) {
      isOnBeach = (json["on_beach"] == 1);
    }

    return Estate(
      id: json["id"] == null ? null : json["id"],
      price: json["price"] == null ? null : json["price"],
      area: json["area"] == null ? null : json["area"],
      estateType: estateType,
      estateOfferType: estateOfferType,
      locationS: locationS == null ? null : locationS,
      officeId: (estateOffice != null) ? estateOffice.id : null,
      estateOffice: estateOffice == null ? null : estateOffice,
      areaUnit: areaUnit == null ? null : areaUnit,
      images: images,
      estateImages: [],
      streetImages: [],
      longitude: json["longitude"] == null ? null : json["longitude"],
      latitude: json["latitude"] == null ? null : json["latitude"],
      locationId: json["location_id"] == null ? null : json["location_id"],
      contractId: json["contract_id"] == null ? null : json["contract_id"],
      floor: json['floor'] == null ? null : json['floor'],
      roomsCount: json["rooms_count"] == null ? null : json["rooms_count"],
      createdAt: json["created_at"] == null ? null : json["created_at"],
      publishedAt: json["published_at"] == null ? null : json["published_at"],
      nearbyPlaces:
          json["nearby_places"] == null ? null : json["nearby_places"],
      description: json["description"] == null ? null : json["description"],
      period: json["period_number"] == null ? null : json["period_number"],
      floorPlanImages: json["floor_plan"] == null ? null : json["floor_plan"],
      isLiked: json["is_liked"] == null ? null : json["is_liked"],
      isSaved: json['is_saved'] == null ? null : json['is_saved'],
      likesCount: json["likes_count"] == null ? null : json["likes_count"],
      visitCount: json["visits_count"] == null ? null : json["visits_count"],
      ownershipType: ownershipTypes == null ? null : ownershipTypes,
      interiorStatus: interiorStatus == null ? null : interiorStatus,
      hasSwimmingPool: hasSwimmingPool == null ? null : hasSwimmingPool,
      isFurnished: isFurnished == null ? null : isFurnished,
      isOnBeach: isOnBeach == null ? null : isOnBeach,
      videoUrl: json['video_url'] == null ? "" : json['video_url'],
      phone: json["phone"] == null ? "" : json["phone"],
      firstImage: json["first_image"] == null ? "" : json["firstImage"],
      viewer: json["viewer_count"] == null ? null : json["viewer_count"],
      estateStatus: json['system_estate_status'] == null
          ? null
          : json['system_estate_status']['id'],
      officeStatus: json['office_estate_status'] == null
          ? null
          : json['office_estate_status']['id'],
    );
  }

  factory Estate.fromJson(Map<String, dynamic> json) {
    // estate type :
    EstateType estateType = EstateType.fromJson(json["estate_type"]);
    // Offer type :
    EstateOfferType estateOfferType =
        EstateOfferType.fromJson(json["estate_offer_type"]);
    // estate location :
    Location? location;
    if (json.containsKey("location") && json["location"] != null) {
      location = Location.fromJson(json["location"]);
    }
    String? locationS;
    if (json.containsKey("locationS") && json["locationS"] != null) {
      locationS = json["locationS"];
    }
    // area unit :
    AreaUnit? areaUnit;
    if (json.containsKey("area_unit") && json["area_unit"] != null) {
      areaUnit = AreaUnit.fromJson(json["area_unit"]);
    }
    // estate images :
    List<MyImage> images = [];
    dynamic jsonImages = json["images"]["data"];
    if (jsonImages is List) {
      images = jsonImages.map((e) => MyImage.fromJson(e)).toList();
    } else if (jsonImages is Map) {
      images = jsonImages.values.map((e) => MyImage.fromJson(e)).toList();
    }
    // ownership type :
    OwnershipType? ownershipTypes;
    if (json.containsKey("ownership_type") && json["ownership_type"] != null) {
      ownershipTypes = OwnershipType.fromJson(json["ownership_type"]);
    }
    // interior status :
    InteriorStatus? interiorStatus;
    if (json.containsKey("interior_status") &&
        json["interior_status"] != null) {
      interiorStatus = InteriorStatus.fromJson(json["interior_status"]);
    }
    // period type :
    PeriodType? periodType;
    if (json.containsKey("period_types") && json["period_types"] != null) {
      periodType = PeriodType.fromJson(json["period_types"]);
    }
    // Estate Office :
    EstateOffice? estateOffice;
    if (json.containsKey("office") && json["office"] != null) {
      estateOffice = EstateOffice.fromJson(json["office"]);
    }

    // swimming pool:
    bool? hasSwimmingPool;
    if (json.containsKey("swimming_pool") && json["swimming_pool"] != null) {
      hasSwimmingPool = (json["swimming_pool"] == 1);
    }
    // is furnished :
    bool? isFurnished;
    if (json.containsKey("is_furnished") && json["is_furnished"] != null) {
      isFurnished = (json["is_furnished"] == 1);
    }
    // is furnished :
    bool? isOnBeach;
    if (json.containsKey("on_beach") && json["on_beach"] != null) {
      isOnBeach = (json["on_beach"] == 1);
    }

    return Estate(
      id: json["id"],
      price: json["price"],
      area: json["area"],
      estateType: estateType,
      estateOfferType: estateOfferType,
      location: location,
      locationS: locationS,
      officeId: (estateOffice != null) ? estateOffice.id : null,
      estateOffice: estateOffice,
      areaUnit: areaUnit,
      estateImages: [],
      streetImages: [],
      images: images,
      longitude: json["longitude"],
      latitude: json["latitude"],
      locationId: json["location_id"],
      contractId: json["contract_id"],
      floor: json['floor'],
      roomsCount: json["rooms_count"],
      createdAt: json["created_at"],
      publishedAt: json["published_at"],
      nearbyPlaces: json["nearby_places"],
      description: json["description"],
      period: json["period_number"],
      floorPlanImages: json["floor_plan"],
      isLiked: json["is_liked"],
      isSaved: json['is_saved'],
      likesCount: json["likes_count"],
      visitCount: json["visits_count"],
      ownershipType: ownershipTypes,
      interiorStatus: interiorStatus,
      periodType: periodType,
      hasSwimmingPool: hasSwimmingPool,
      isFurnished: isFurnished,
      isOnBeach: isOnBeach,
      videoUrl: json['video_url'] ?? "",
      phone: json["phone"] ?? "",
      viewer: json["viewer_count"],
      estateStatus: json['system_estate_status'] == null
          ? null
          : json['system_estate_status']['id'],
      officeStatus: json['office_estate_status'] == null
          ? null
          : json['office_estate_status']['id'],
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> map = {};

    // ownership type id :
    int? ownershipTypeId = (ownershipType == null) ? null : ownershipType!.id;
    // interior status id :
    int? interiorStatusId =
        (interiorStatus == null) ? null : interiorStatus!.id;
    // period type id :
    int? periodTypeId = (periodType == null) ? null : periodType!.id;
    // is furnished:
    int? isFurnished =
        (this.isFurnished == null) ? null : ((this.isFurnished!) ? 1 : 0);
    // is on beach:
    int? isOnBeach =
        (this.isOnBeach == null) ? null : ((this.isOnBeach!) ? 1 : 0);
    // has swimming pool :
    int? hasSwimmingPool = (this.hasSwimmingPool == null)
        ? null
        : ((this.hasSwimmingPool!) ? 1 : 0);
    // floor plan image :
    List<MultipartFile>? floorPlanImages =
        await createImagesList(this.floorPlanImages);
    // estate images:
    List<MultipartFile>? estateImages =
        await createImagesList(this.estateImages);
    // street images:
    List<MultipartFile>? streetImages =
        await createImagesList(this.streetImages);

    map["estate_offer_type_id"] = estateOfferType!.id;
    map["estate_type_id"] = estateType!.id;
    map["area_unit_id"] = areaUnit!.id;
    map["ownership_type_id"] = ownershipTypeId;
    map["interior_status_id"] = interiorStatusId;
    map["estate_office_id"] = officeId;
    map["period_type_id"] = periodTypeId;
    map["location_id"] = locationId;
    map["longitude"] = longitude;
    map["latitude"] = latitude;
    map["rooms_count"] = roomsCount;
    map["area"] = area;
    map["nearby_places"] = nearbyPlaces;
    map["price"] = price;
    map["floor"] = floor;
    map["description"] = description;
    map["swimming_pool"] = hasSwimmingPool;
    map["is_furnished"] = isFurnished;
    map["on_beach"] = isOnBeach;
    map["period_number"] = period;
    //map["estate_office_id"] = estateOffice!.id;
    map["id"] = id;
    map["floor_plan"] = floorPlanImages;
    map["estate_images[]"] = estateImages;
    map["street_images[]"] = streetImages;
    return map;
  }

  static Map<String, dynamic> toMap(Estate estate) {
    return {
      "floor": estate.floor == null ? null : estate.floor!,
      "published_at": estate.publishedAt,
      'first_image': estate.firstImage,
      'id': estate.id,
      'locationS': estate.locationS,
      'office':
          estate.estateOffice == null ? null : estate.estateOffice!.toJson(),
      'images': estate.images!.isEmpty
          ? null
          : estate.images!.map((e) => e.toJson()).toList(),
      'is_saved': estate.isSaved,
      'estate_type': estate.estateType,
      'estate_offer_type': estate.estateOfferType == null
          ? null
          : estate.estateOfferType!.toJson(),

      'area': estate.area,
      'area_unit': estate.areaUnit!.toJson(),
      'ownership_type':
          estate.ownershipType == null ? null : estate.ownershipType!.toJson(),
      'price': estate.price,

      "nearby_places": estate.nearbyPlaces,


      "description": estate.description,
      "interior_status":
          estate.interiorStatus == null ? null : estate.interiorStatus!.toJson(),
      "is_furnished": estate.isFurnished,
      "rooms_count": estate.roomsCount == null ? null : estate.roomsCount!,
      "longitude": estate.longitude == null ? null : estate.longitude!,
      "latitude": estate.latitude == null ? null : estate.latitude!,
      "swimming_pool":
          estate.hasSwimmingPool == null ? null : estate.hasSwimmingPool!,

      //"location":estate.location == null ? "" : estate.location!.toJson(),
    };
  }

  static String encode(List<Estate> estates) => json.encode(
        estates
            .map<Map<String, dynamic>>((estate) => Estate.toMap(estate))
            .toList(),
      );

  static List<Estate> decode(String estate) =>
      (json.decode(estate) as List<dynamic>)
          .map<Estate>((item) => Estate.fromJsonS(item))
          .toList();

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

  String getEstateShareInformation() {
    String shareInformation = "";

    return shareInformation;
  }
}

class EstateSearch {
  List<Estate> identicalEstates;
  List<Estate> similarEstates;

  factory EstateSearch.init() {
    return EstateSearch(identicalEstates: [], similarEstates: []);
  }

  EstateSearch({required this.identicalEstates, required this.similarEstates});
}

class SpecialEstate {
  String? imageUrl;
  int? estateId;

  SpecialEstate({this.imageUrl, this.estateId});

  factory SpecialEstate.fromJson(Map<String, dynamic> json) {
    return SpecialEstate(imageUrl: json["images"], estateId: json["id"]);
  }
}
