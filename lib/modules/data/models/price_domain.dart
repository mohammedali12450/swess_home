class PriceDomain {
  int id;
  String min;
  String max;

  String getTextPriceDomain() {
    if (min == "0" && max == "999999999999999999") {
      return "غير محدد";
    }
    if (min == "0") {
      return "أقل من " + max;
    }
    if (max == "999999999999999999") {
      return "أكثر من " + min;
    }

    return "بين " + min + " و " + max;
  }

  PriceDomain({required this.id, required this.min, required this.max});

  factory PriceDomain.fromJson(json) {
    return PriceDomain(
      id: json['id'],
      min: json['min'],
      max: json['max'],
    );
  }
}
