class SystemVariables {
  final int? minimumCountOfStreetImages;

  final int minimumCountOfEstateImages;

  final String normalCompanyPhoneNumber;

  final String permanentCompanyPhoneNumber;

  final bool isVacationsAvailable;

  SystemVariables(
      {this.minimumCountOfStreetImages,
      required this.minimumCountOfEstateImages,
      required this.normalCompanyPhoneNumber,
      required this.permanentCompanyPhoneNumber,
      required this.isVacationsAvailable});

  factory SystemVariables.fromJson(Map<String, dynamic> json) {
    return SystemVariables(
      minimumCountOfEstateImages: json["minimum_count_of_estate_images_to_publish"],
      normalCompanyPhoneNumber: json["normal_company_phone_number"],
      permanentCompanyPhoneNumber: json["permanent_company_phone_number"],
      minimumCountOfStreetImages: json["minimum_count_of_street_images_to_publish"],
      isVacationsAvailable: ( json["summer_estates_status"] == 1 ),
    );
  }
}
