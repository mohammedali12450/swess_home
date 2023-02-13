
class RentEstate {
  int id;
  String location;
  String estateType;
  String periodType;
  String interiorStatuses;
  int floor;
  int room;
  int salon;
  int bathroom;
  int price;
  int space;
  bool isFurnished;
  String? whatsAppNumber;
  String phoneNumber;
  String publishedAt;

  RentEstate(
      {required this.id,
      required this.location,
      required this.estateType,
      required this.periodType,
      required this.interiorStatuses,
      required this.floor,
      required this.room,
      required this.salon,
      required this.bathroom,
      required this.price,
      required this.space,
      required this.isFurnished,
      this.whatsAppNumber,
      required this.phoneNumber,
      required this.publishedAt});

  factory RentEstate.fromJson(Map<String, dynamic> json) {
    return RentEstate(
        id: json["id"],
        location: json["location"],
        estateType: json["estate_type"],
        periodType: json["period_type"],
        interiorStatuses: json["interior_status"] == null ? "" : json["interior_status"],
        floor: json["floors_count"],
        room: json["rooms_count"],
        salon: json["salons_count"],
        bathroom: json["bathrooms_count"],
        price: json["price"],
        space: json["area"],
        isFurnished: json["is_furnished"],
        whatsAppNumber:
            json["whatsapp_number"] == null ? null : json["whatsapp_number"],
        phoneNumber: json["customer_phone"] == null ? "" : json["customer_phone"],
        publishedAt: json["published_at"] == null ? "" : json["published_at"]);
  }
}

class RentEstateRequest {
  int? locationId;
  int estateTypeId;
  int periodTypeId;
  int interiorStatusesId;
  int floor;
  int room;
  int salon;
  int bathroom;
  int price;
  int space;
  int isFurnished;
  String? whatsAppNumber;

  RentEstateRequest(
      {required this.locationId,
      required this.estateTypeId,
      required this.periodTypeId,
      required this.interiorStatusesId,
      required this.floor,
      required this.room,
      required this.salon,
      required this.bathroom,
      required this.price,
      required this.space,
      required this.isFurnished,
      this.whatsAppNumber});

  factory RentEstateRequest.init() {
    return RentEstateRequest(
        locationId: 0,
        estateTypeId: 0,
        periodTypeId: 0,
        interiorStatusesId: 0,
        floor: 0,
        room: 0,
        salon: 0,
        bathroom: 0,
        price: 0,
        space: 0,
        isFurnished: 0);
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> map = {};
    map["location"] = locationId;
    map["estate_type"] = estateTypeId;
    map["period_type"] = periodTypeId;
    map["interior_status"] = interiorStatusesId;
    map["floors"] = floor;
    map["rooms"] = room;
    map["salons"] = salon;
    map["bathrooms"] = bathroom;
    map["price"] = price;
    map["space"] = space;
    map["is_furnished"] = isFurnished;
    map["whatsapp_number"] = whatsAppNumber;
    return map;
  }
}

class RentEstateFilter {
  int? locationId;
  int? estateTypeId;
  int? periodTypeId;
  String? price;

  RentEstateFilter({
    this.locationId,
    this.estateTypeId,
    this.periodTypeId,
    this.price,
  });

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> map = {};
    map["location_id"] = locationId;
    map["estate_type_id"] = estateTypeId;
    map["period_type_id"] = periodTypeId;
    map["price"] = price;
    return map;
  }

  factory RentEstateFilter.init() {
    return RentEstateFilter(
        locationId: null,
        estateTypeId: null,
        periodTypeId: null,
        price: "desc",);
  }
}
