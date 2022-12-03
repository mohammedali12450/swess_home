class Governorate {
  int id;
  String name;
  String longitude;
  String latitude;
  //List<Governorate>? governorates;


  factory Governorate.init() {
    return Governorate(
      id: -1,
      name: "default",
      latitude: "default",
      longitude: "default",
    );
  }

  // String getGovernorateName() {
  //   return name + ', ' + ((governorates != null) ? governorates!.first.name : "");
  // }

  Governorate({
    required this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    //this.governorates,
  });

  factory Governorate.fromJson(dynamic json) {
    List<Governorate>? childLocations;
    if (json['locations'] != null) {
      var jsonChildLocations = json['locations'] as List;
      childLocations = jsonChildLocations
          .map<Governorate>((e) => Governorate.fromJson(e))
          .toList();
    }
    return Governorate(
      id: json['id'],
      name: json['name'],
      longitude: json['longitude'],
      latitude: json['latitude'],
     // governorates: childLocations,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    // if (governorates != null) {
    //   map['locations'] = governorates?.map((v) => v.toJson()).toList();
    // }
    return map;
  }
}
