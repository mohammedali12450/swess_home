import 'package:intl/intl.dart';

class PriceDomain {
  int id;

  String min;
  String max;

  PriceDomain({required this.id, required this.min, required this.max});

  String getTextPriceDomain(bool isArabic) {
    if (min == "0") {
      return isArabic ? ("أقل من " " "+ NumberFormat('###,###,###').format(int.parse(max))) : ("less than" " "+ NumberFormat('###,###,###').format(int.parse(max)));
    }
    if (max == "999999999999999999") {
      return isArabic ? ("أكثر من "  " " + NumberFormat('###,###,###').format(int.parse(min))) : ("more than " " "+ NumberFormat('###,###,###').format(int.parse(min))) ;
    }

    return isArabic ? ("بين "  " " + NumberFormat('###,###,###').format(int.parse(min)) + " و " + NumberFormat('###,###,###').format(int.parse(max))) : ("between " " "+NumberFormat('###,###,###').format(int.parse(min)) +" " + "and" + " "+ NumberFormat('###,###,###').format(int.parse(max)));
  }

  factory PriceDomain.fromJson(json) {


    return PriceDomain(
      id: json['id'],
      min: json['min'],
      max: json['max'],
    );
  }


}
