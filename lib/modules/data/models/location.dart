class Location {
  int id;
  String name;
  String longitude;
  String latitude;
  List<Location>? locations;


  factory Location.init() {
    return Location(
      id: -1,
      name: "default",
      latitude: "default",
      longitude: "default",
    );
  }

  String getLocationName() {
    return name + ', ' + ((locations != null) ? locations!.first.name : "");
  }

  Location({
    required this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    this.locations,
  });

  factory Location.fromJson(dynamic json) {
    List<Location>? childLocations;
    if (json['locations'] != null) {
      var jsonChildLocations = json['locations'] as List;
      childLocations = jsonChildLocations
          .map<Location>((e) => Location.fromJson(e))
          .toList();
    }
    return Location(
      id: json['id'],
      name: json['name'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      locations: childLocations,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    if (locations != null) {
      map['locations'] = locations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
