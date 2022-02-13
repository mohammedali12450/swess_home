class PeriodType {
  int id;

  String name;

  PeriodType({required this.id, required this.name});

  factory PeriodType.fromJson(json) {
    return PeriodType(
      id: json['id'],
      name: json['name'],
    );
  }
}
