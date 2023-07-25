class Location {
  String locationFullName;

  Location({
    required this.locationFullName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationFullName: json['location_full_name'],
    );
  }
}

class Zone {
  int locationId;
  int estateTypeId;
  int estateOfferTypeId;
  Location location;
  dynamic priceDomain;

  Zone({
    required this.locationId,
    required this.estateTypeId,
    required this.estateOfferTypeId,
    required this.location,
    required this.priceDomain,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      locationId: json['location_id'],
      estateTypeId: json['estate_type_id'],
      estateOfferTypeId: json['estate_offer_type_id'],
      location: Location.fromJson(json['location']),
      priceDomain: json['price_domain'],
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
