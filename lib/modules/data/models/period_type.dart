class PeriodType {
  int id;
  String name;

  PeriodType(
      {required this.id, required this.name});

  factory PeriodType.copy(PeriodType periodType) {
    return PeriodType(
        id: periodType.id,
        name: periodType.name,);
  }

  factory PeriodType.fromJson(json) {
    return PeriodType(
        id: json['id'],
        name: json['name'] == null ? "" : json['name']);
  }
}
