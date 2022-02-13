class EstateOrder {
  int locationId;

  int estateTypeId;

  int estateOfferTypeId;

  int? priceDomainId;

  String? notes;

  EstateOrder(
      {required this.locationId,
      required this.estateTypeId,
      required this.estateOfferTypeId,
      this.priceDomainId,
      this.notes});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map["estate_type_id"] = estateTypeId;
    map['estate_offer_type_id'] = estateOfferTypeId;
    map["price_domain_id"] = priceDomainId;
    map["location_id"] = locationId;
    map["notes"] = notes;
    return map;
  }

  factory EstateOrder.fromJson(Map<String, dynamic> jsonMap) {
    return EstateOrder(
        locationId: jsonMap["location_id"],
        estateTypeId: jsonMap["estate_type_id"],
        estateOfferTypeId: jsonMap["estate_offer_type_id"],
        notes: jsonMap["notes"],
        priceDomainId: jsonMap["price_domain_id"]);
  }
}
