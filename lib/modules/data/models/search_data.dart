class SearchData {
  int? estateOfferTypeId;

  int? estateTypeId;

  int? locationId;

  int? ownershipId;

  int? interiorStatusId;

  bool? hasSwimmingPool;

  bool? isFurnished;

  bool? isOnBeach;

  int? priceMin;
  int? priceMax;

  String? sortBy;
  String? sortType;
  String? notes;
  String? description;

  SearchData(
      {this.estateOfferTypeId,
      this.locationId,
      this.estateTypeId,
      this.ownershipId,
      this.interiorStatusId,
      this.priceMin,
      this.priceMax,
      this.sortBy,
      this.sortType,
      this.description});

  factory SearchData.init() {
    return SearchData(locationId: 0, estateTypeId: 0, estateOfferTypeId: 1);
  }

  Map<String, dynamic> toJson(bool isAdvanced) {
    return {
      "location_id": locationId,
      "estate_offer_type_id": estateOfferTypeId,
      "estate_type_id": estateTypeId,
      "min_price": priceMin,
      "max_price": priceMax,
      "sort_by": sortBy,
      "notes": description,
      "sort_type": sortType,
      if (isAdvanced) "ownership_type_id": ownershipId,
      if (isAdvanced) "interior_status_id": interiorStatusId,
      if (isAdvanced)
        "swimming_pool":
            (hasSwimmingPool == null) ? null : ((hasSwimmingPool!) ? 1 : 0),
      if (isAdvanced)
        "is_furnished": (isFurnished == null) ? null : ((isFurnished!) ? 1 : 0),
      if (isAdvanced)
        "on_beach": (isOnBeach == null) ? null : ((isOnBeach!) ? 1 : 0)
    };
  }
}
