class EstateOfferType {
  int id;

  String name;

  EstateOfferType({required this.id, required this.name});

  factory EstateOfferType.init(){
    return EstateOfferType(id: -1, name: "default") ;
  }

  factory EstateOfferType.fromJson(json) {
    return EstateOfferType(
      id: json['id'],
      name: json['name'],
    );
  }
}
