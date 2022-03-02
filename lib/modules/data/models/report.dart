class Report {
  int id;

  String name;

  Report({required this.id, required this.name});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(id: json["id"], name: json["name"]);
  }
}
