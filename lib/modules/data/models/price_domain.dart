class PriceDomain {
  // String estateOfferType;

  // List<dynamic> min;
  // List<dynamic> max;

  Rent rent;
  Sale sale;

  PriceDomain({required this.rent, required this.sale});

  factory PriceDomain.fromJson(json) {
    return PriceDomain(
      rent: Rent.fromJson(json["rent"]),
      sale: Sale.fromJson(json["sale"]),
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

  factory Rent.fromJson(json) {
    return Rent(
      min: json['min'],
      max: json['max'],
    );
  }
}

class Sale {
  List<dynamic> min;
  List<dynamic> max;

  Sale({required this.min, required this.max});

  factory Sale.fromJson(json) {
    return Sale(
      min: json['min'],
      max: json['max'],
    );
  }
}
