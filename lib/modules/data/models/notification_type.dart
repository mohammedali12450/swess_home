class NotificationType {
  int id;

  String name;

  NotificationType({required this.id, required this.name});

  factory NotificationType.fromJson(json) {
    return NotificationType(
      id: json["id"],
      name: json["name"],
    );
  }
}
