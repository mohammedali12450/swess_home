class AreaUnit {
  int id;

  String name;

  AreaUnit({required this.id, required this.name});

  factory AreaUnit.fromJson(json) {
    return AreaUnit(
      id: json['id'],
      name: json['name'],
    );
  }
}
