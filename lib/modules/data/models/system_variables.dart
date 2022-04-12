class SystemVariables {
  final int? minimumCountOfStreetImages;

  final int minimumCountOfEstateImages;

  final String normalCompanyPhoneNumber;

  final String permanentCompanyPhoneNumber;

  final bool isVacationsAvailable;

  final String maximumCountOfEstateImages;
  final String maximumCountOfStreetImages;
  final String maximumCountOfFloorPlanImages;
  final String maximumCountOfNearbyPlaces;
  final bool isForStore ;

  SystemVariables({
    this.minimumCountOfStreetImages,
    required this.minimumCountOfEstateImages,
    required this.normalCompanyPhoneNumber,
    required this.permanentCompanyPhoneNumber,
    required this.isVacationsAvailable,
    required this.maximumCountOfEstateImages,
    required this.maximumCountOfFloorPlanImages,
    required this.maximumCountOfNearbyPlaces,
    required this.maximumCountOfStreetImages,
    required this.isForStore
  });

  factory SystemVariables.fromJson(Map<String, dynamic> json) {
    return SystemVariables(
      minimumCountOfEstateImages: json["minimum_count_of_estate_images_to_publish"],
      normalCompanyPhoneNumber: json["normal_company_phone_number"],
      permanentCompanyPhoneNumber: json["permanent_company_phone_number"],
      minimumCountOfStreetImages: json["minimum_count_of_street_images_to_publish"],
      isVacationsAvailable: (json["summer_estates_status"] == 1),
      maximumCountOfEstateImages: json["maximum_count_of_estate_images"],
      maximumCountOfStreetImages: json["maximum_count_of_street_images"],
      maximumCountOfNearbyPlaces: json["maximum_count_of_nearby_places"],
      maximumCountOfFloorPlanImages: json["maximum_count_of_floor_plan_images"],
      isForStore: (json['is_for_store'] == 1) ? true : false ,
    );
  }
}
