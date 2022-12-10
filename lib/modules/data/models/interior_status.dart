class InteriorStatus {
  final int id;

  final String name;

  InteriorStatus({required this.id, required this.name});

  factory InteriorStatus.copy(InteriorStatus interiorStatus) {
    return InteriorStatus(
      id: interiorStatus.id,
      name: interiorStatus.name
    );
  }

  factory InteriorStatus.fromJson(json) {
    return InteriorStatus(id: json['id'], name: json['name']);
  }
}
