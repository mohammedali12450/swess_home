import 'package:swesshome/modules/data/models/location.dart';

class EstateOffice {
  int id;
  String? name;

  String? logo;

  String? longitude;

  String? latitude;

  String? telephone;

  String? mobile;
  Location? location;

  String? rating;

  int? contractId;

  bool? isLiked;

  EstateOffice(
      {required this.id,
      required this.isLiked,
      this.name,
      this.logo,
      this.longitude,
      this.contractId,
      this.latitude,
      this.telephone,
      this.mobile,
      this.rating,
      this.location});

  factory EstateOffice.fromJson(Map<String, dynamic> jsonMap) {
    return EstateOffice(
      latitude: jsonMap["latitude"],
      longitude: jsonMap["longitude"],
      logo: jsonMap["logo"],
      name: jsonMap['name'],
      id: jsonMap["id"],
      isLiked: jsonMap["is_liked"],
      contractId: jsonMap["contract_id"],
      mobile: jsonMap["mobile"],
      location: jsonMap["location"] == null
          ? null
          : Location.fromJson(jsonMap["location"]),
      telephone: jsonMap["telephone"],
      rating: jsonMap["rating"],
    );
  }
}
//
// class EstateOfficeSearch {
//   int id;
//   String? name;
//
//   String? logo;
//   Location? location;
//
//   EstateOfficeSearch({required this.id, this.name, this.logo, this.location});
//
//   factory EstateOfficeSearch.fromJson(Map<String, dynamic> jsonMap) {
//     return EstateOfficeSearch(
//       logo: jsonMap["logo"],
//       name: jsonMap['name'],
//       id: jsonMap["id"],
//       location: Location.fromJson(jsonMap["location"]),
//     );
//   }
// }
