class EstateImmediately {
  int? locationId;
  int? estateTypeId;
  int? space;
  int? floor;
  int? room;
  int? salon;
  int? bathroom;
  int? rentalTerm;
  int? price;
  bool? isFurniture;
  String? phoneNumber;

  EstateImmediately(
      {this.locationId,
      this.estateTypeId,
      this.space,
      this.floor,
      this.room,
      this.salon,
      this.bathroom,
      this.rentalTerm,
      this.price,
      this.isFurniture,
      this.phoneNumber});

  // Map<String, dynamic> toJson(bool isAdvanced) {
  //   return {
  //     "location_id": locationId,
  //     "estate_offer_type_id": estateOfferTypeId,
  //     "estate_type_id": estateTypeId,
  //     "min_price": priceMin,
  //     "max_price": priceMax,
  //     //"price_domain_id": priceDomainId,
  //     if (isAdvanced) "ownership_type_id": ownershipId,
  //     if (isAdvanced) "interior_status_id": interiorStatusId,
  //     if (isAdvanced)
  //       "swimming_pool":
  //           (hasSwimmingPool == null) ? null : ((hasSwimmingPool!) ? 1 : 0),
  //     if (isAdvanced)
  //       "is_furnished": (isFurnished == null) ? null : ((isFurnished!) ? 1 : 0),
  //     if (isAdvanced)
  //       "on_beach": (isOnBeach == null) ? null : ((isOnBeach!) ? 1 : 0)
  //   };
  // }
}
