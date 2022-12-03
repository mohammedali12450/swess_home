import 'package:swesshome/modules/data/models/location.dart';

import 'estate.dart';

class OfficeDetails {
  EstateOffice estateOffice;
  CommunicationMedias? communicationMedias;
  List<Estate> estates;

  OfficeDetails(
      {required this.estateOffice,
      required this.communicationMedias,
      required this.estates});
}

class EstateOffice {
  int id;
  String? name;
  String? logo;
  String? longitude;
  String? latitude;
  String? telephone;
  String? mobile;
  Location? location;
  String? locationS;
  String? rating;
  int? contractId;
  bool? isLiked;
  String? workHours;
  int? estateLength;

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
      this.location,
      this.locationS,
      this.workHours,
      this.estateLength});

  factory EstateOffice.fromJson(Map<String, dynamic> jsonMap) {
    return EstateOffice(
      latitude: jsonMap["latitude"] == null ? null : jsonMap["latitude"],
      longitude: jsonMap["longitude"] == null ? null : jsonMap["longitude"],
      logo: jsonMap["logo"],
      name: jsonMap['name'],
      id: jsonMap["id"],
      isLiked: jsonMap["is_liked"] == null ? null : jsonMap["is_liked"],
      contractId:
          jsonMap["contract_id"] == null ? null : jsonMap["contract_id"],
      mobile: jsonMap["mobile"] == null ? null : jsonMap["mobile"],
      location: jsonMap["location"] == null
          ? null
          : Location.fromJson(jsonMap["location"]),
      locationS: jsonMap["locationS"] == null ? null : jsonMap["locationS"],
      telephone: jsonMap["telephone"] == null ? null : jsonMap["telephone"],
      rating: jsonMap["rating"] == null ? null : jsonMap["rating"],
      workHours: jsonMap["work_hours"] == null ? null : jsonMap["work_hours"],
      estateLength:
          jsonMap["estates_count"] == null ? null : jsonMap["estates_count"],
    );
  }
}

class CommunicationMedias {
  List<Media>? facebook;
  List<Media>? whatsApp;
  List<Media>? phone;

  CommunicationMedias({this.facebook, this.whatsApp, this.phone});

  factory CommunicationMedias.fromJson(Map<String, dynamic> json) =>
      CommunicationMedias(
        facebook:
            List<Media>.from(json["facebook"].map((x) => Media.fromJson(x))),
        whatsApp:
            List<Media>.from(json["whatsapp"].map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "facebook": List<dynamic>.from(facebook!.map((x) => x.toJson())),
        "whatsapp": List<dynamic>.from(whatsApp!.map((x) => x.toJson())),
      };
}

class Media {
  int? id;
  int? officeId;
  String? communicationType;
  String? value;

  Media({this.id, this.officeId, this.communicationType, this.value});

  factory Media.fromJson(Map<String, dynamic> jsonMap) {
    return Media(
        id: jsonMap["id"] == null ? null : jsonMap["id"],
        officeId:
            jsonMap["estate_office"] == null ? null : jsonMap["estate_office"],
        communicationType: jsonMap["communication_type"] == null
            ? null
            : jsonMap["communication_type"],
        value: jsonMap["value"] == null ? null : jsonMap["value"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "estate_office": officeId,
        "communication_type": communicationType,
        "value": value,
      };
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
