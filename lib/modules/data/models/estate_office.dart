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

  bool isLiked;

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
      isLiked : jsonMap["is_liked"] ,
      contractId: jsonMap["contract_id"],
      mobile: jsonMap["mobile"],
      location: Location.fromJson(jsonMap["location"]),
      telephone: jsonMap["telephone"],
      rating: jsonMap["rating"],
    );
  }
}
