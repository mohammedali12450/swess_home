class PriceDomain {
  // String estateOfferType;
  List<dynamic> min;
  List<dynamic> max;

  // Rent rent;
  // Sell sell;

  PriceDomain({required this.min, required this.max});

  factory PriceDomain.fromJson(json) {
    return PriceDomain(
      min: json['min'],
      max: json['max'],
    );
  }

// String getTextPriceDomain(bool isArabic) {
//   if (min == "0") {
//     return isArabic
//         ? ("أقل من " " " + NumberFormat('###,###,###').format(int.parse(max)))
//         : ("less than" " " +
//             NumberFormat('###,###,###').format(int.parse(max)));
//   }
//   if (max == "999999999999999999") {
//     return isArabic
//         ? ("أكثر من " " " +
//             NumberFormat('###,###,###').format(int.parse(min)))
//         : ("more than " " " +
//             NumberFormat('###,###,###').format(int.parse(min)));
//   }
//
//   return isArabic
//       ? ("بين " " " +
//           NumberFormat('###,###,###').format(int.parse(min)) +
//           " و " +
//           NumberFormat('###,###,###').format(int.parse(max)))
//       : ("between " " " +
//           NumberFormat('###,###,###').format(int.parse(min)) +
//           " " +
//           "and" +
//           " " +
//           NumberFormat('###,###,###').format(int.parse(max)));
// }

}

class Rent {
  List<dynamic> min;
  List<dynamic> max;

  Rent({required this.min, required this.max});
}

class Sell {
  List<dynamic> min;
  List<dynamic> max;

  Sell({required this.min, required this.max});
}
