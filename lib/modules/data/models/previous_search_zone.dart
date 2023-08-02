
class Zone {
  int locationId;
  String locationFullName;
  int estateTypeId;
  int estateOfferTypeId;
  int? priceDomainId;
  int? priceMin;
  int? priceMax;

  Zone({
    required this.locationId,
    required this.locationFullName,
    required this.estateTypeId,
    required this.estateOfferTypeId,
    required this.priceDomainId,
    required this.priceMin,
    required this.priceMax,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      locationId: json['location_id'],
      locationFullName: json['location_full_name'],
      estateTypeId: json['estate_type_id'],
      estateOfferTypeId: json['estate_offer_type_id'],
      priceDomainId: json['price_domain_id']??1,
      priceMin: json['price_min'],
      priceMax: json['price_max'],
    );
  }
}

class SearchResults {
  List<Zone> zones;
  SearchResults({
    required this.zones,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      zones: List<Zone>.from(json['zones'].map((x) => Zone.fromJson(x))),
    );
  }
}
