class OwnershipType {

  int id;

  String name;


  OwnershipType({required this.id, required this.name});

  factory OwnershipType.fromJson(json){
    return OwnershipType(
      id: json['id'],
      name: json['name'],
    );
  }
}