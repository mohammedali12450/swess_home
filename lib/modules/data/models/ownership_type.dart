class OwnershipType {
  int id;
  String name;


  OwnershipType(
      {required this.id, required this.name});

  factory OwnershipType.copy(OwnershipType ownershipType) {
    return OwnershipType(
        id: ownershipType.id,
        name: ownershipType.name);
  }

  factory OwnershipType.fromJson(json) {
    return OwnershipType(
      id: json['id'],
      name: json['name'],
    );
  }
}
