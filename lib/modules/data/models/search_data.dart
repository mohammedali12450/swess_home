class SearchData {
  int? estateOfferTypeId;

  int? estateTypeId;

  int? locationId;

  int? priceDomainId;
  int? ownershipId;

  int? interiorStatusId;

  bool? hasSwimmingPool;

  bool? isFurnished ;

  bool? isOnBeach;


  SearchData(
      {this.estateOfferTypeId,
      this.locationId,
      this.estateTypeId,
      this.priceDomainId});

  Map<String, dynamic> toJson(bool isAdvanced) {
    return {
      "location_id": locationId,
      "estate_offer_type_id": estateOfferTypeId,
      "estate_type_id": estateTypeId,
      "price_domain_id": priceDomainId,
      if (isAdvanced) "ownership_type_id": ownershipId,
      if (isAdvanced) "interior_status_id": interiorStatusId,
      if (isAdvanced) "swimming_pool": hasSwimmingPool,
      if (isAdvanced) "is_furnished": isFurnished,
      if (isAdvanced) "on_beach": isOnBeach
    };
  }
}
