class EstateType {
  final int id;

  final String name;

  factory EstateType.copy(EstateType estateType) {
    return EstateType(id: estateType.id, name: estateType.name);
  }

  factory EstateType.init(){
    return EstateType(id: -1, name: "default" ) ;
  }

  EstateType({required this.id, required this.name});

  factory EstateType.fromJson(json) {
    return EstateType(
      id: json['id'],
      name: json['name']
    );
  }
}
