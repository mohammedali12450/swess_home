import 'package:swesshome/modules/data/models/my_image.dart';


class Estate_new {
  Estate_new({
    this.id,
    this.ownershipType,
    this.estateType,
    this.interiorStatus,
    this.estateOfferType,
    this.price,
    this.office,
    this.areaUnit,
    this.images,
    this.longitude,
    this.latitude,
    this.roomsCount,
    this.area,
    this.nearbyPlaces,
    this.description,
    this.swimmingPool,
    this.isFurnished,
    this.onBeach,
    this.periodNumber,
    this.floor,
    this.createdAt,
    this.publishedAt,
    this.isDeleted,
    this.isHidden,
    this.distance,
    this.isPriceChanged,
  });

  int? id;
  String? ownershipType;
  String? estateType;
  String? interiorStatus;
  String? estateOfferType;
  String? price;
  String? office;
  String? areaUnit;
  List<MyImage>? images;
  String? longitude;
  String? latitude;
  String? roomsCount;
  String? area;
  String? nearbyPlaces;
  String? description;
  int? swimmingPool;
  int? isFurnished;
  int? onBeach;
  dynamic periodNumber;
  String? floor;
  String? createdAt;
  String? publishedAt;
  int? isDeleted;
  int? isHidden;
  dynamic distance;
  int? isPriceChanged;
  bool? isLiked;
  bool? isSaved;

  factory Estate_new.fromJson(Map<String, dynamic> json) {
    List<MyImage>? images = [];
    dynamic jsonImages = json["images"]["data"];
    if (jsonImages is List) {
      images = jsonImages.map((e) => MyImage.fromJson(e)).toList();
    } else if (jsonImages is Map) {
      images = jsonImages.values.map((e) => MyImage.fromJson(e)).toList();
    }
    return Estate_new(
      id: json["id"],
      ownershipType: json["ownership_type"],
      estateType:json["estate_type"],
      interiorStatus: json["interior_status"],
      estateOfferType: json["estate_offer_type"],
      price: json["price"],
      office: json["office"],
      areaUnit: json["area_unit"],
      images: images,
      longitude: json["longitude"],
      latitude: json["latitude"],
      roomsCount: json["rooms_count"],
      area: json["area"],
      nearbyPlaces: json["nearby_places"],
      description: json["description"],
      swimmingPool: json["swimming_pool"],
      isFurnished: json["is_furnished"],
      onBeach: json["on_beach"],
      periodNumber: json["period_number"],
      floor: json["floor"],
      createdAt:json["created_at"],
      publishedAt: json["published_at"],
      isDeleted: json["is_deleted"],
      isHidden: json["is_hidden"],
      distance: json["distance"],
      isPriceChanged: json["is_price_changed"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownership_type": ownershipType,
        "estate_type": estateType,
        "interior_status": interiorStatus,
        "estate_offer_type": estateOfferType,
        "price": price,
        "office": office,
        "area_unit": areaUnit,
        "images": images,
        "longitude": longitude,
        "latitude": latitude,
        "rooms_count": roomsCount,
        "area": area,
        "nearby_places": nearbyPlaces,
        "description": description,
        "swimming_pool": swimmingPool,
        "is_furnished": isFurnished,
        "on_beach": onBeach,
        "period_number": periodNumber,
        "floor": floor,
        "created_at": createdAt,
        "published_at": publishedAt,
        "is_deleted": isDeleted,
        "is_hidden": isHidden,
        "distance": distance,
        "is_price_changed": isPriceChanged,
      };
}
