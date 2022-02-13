class InteriorStatus {
  int id;

  String name;

  InteriorStatus({required this.id, required this.name});

  factory InteriorStatus.fromJson(json) {
    return InteriorStatus(id: json['id'], name: json['name']);
  }
}
