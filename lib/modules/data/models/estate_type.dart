class EstateType {
  int id;

  String name;

  EstateType({required this.id, required this.name});

  factory EstateType.init(){
    return EstateType(id: -1, name: "default") ;
  }

  factory EstateType.fromJson(json) {
    return EstateType(
      id: json['id'],
      name: json['name'],
    );
  }
}
