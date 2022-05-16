class PriceDomain {
  int id;

  String min;
  String max;

  PriceDomain({required this.id, required this.min, required this.max});

  String getTextPriceDomain(bool isArabic) {
    if (min == "0" && max == "999999999999999999") {
      return isArabic? "غير محدد" : "undefined";
    }
    if (min == "0") {
      return isArabic ? ("أقل من " + max) : ("less than $max");
    }
    if (max == "999999999999999999") {
      return isArabic ? ("أكثر من " + min) : ("more than $min") ;
    }

    return isArabic ? ("بين " + min + " و " + max) : ("between $min and $max");
  }

  factory PriceDomain.fromJson(json) {


    return PriceDomain(
      id: json['id'],
      min: json['min'],
      max: json['max'],
    );
  }
}
