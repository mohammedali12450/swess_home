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
  List<dynamic> min1;
  List<dynamic> max1;
  List<int> min = [];
  List<int> max = [];

  Rent({required this.min1, required this.max1}) {
    for (int i = 0; i < min1.length; i++) {
      min.add(int.parse(min1.elementAt(i)));
     // print(min.elementAt(i));
    }
    for (int i = 0; i < max1.length; i++) {
      max.add(int.parse(max1.elementAt(i)));
     // print(max.elementAt(i));
    }
  }

  factory Rent.fromJson(json) {
    return Rent(
      min1: json['min'],
      max1: json['max'],
    );
  }
}

class Sale {
  List<dynamic> min1;
  List<dynamic> max1;
  List<int> min = [];
  List<int> max = [];

  Sale({required this.min1, required this.max1}) {
    for (int i = 0; i < min1.length; i++) {
      min.add(int.parse(min1.elementAt(i)));
      //print(min.elementAt(i));
    }
    for (int i = 0; i < max1.length; i++) {
      max.add(int.parse(max1.elementAt(i)));
      //print(max.elementAt(i));
    }
  }

  factory Sale.fromJson(json) {
    return Sale(
      min1: json['min'],
      max1: json['max'],
    );
  }
}
