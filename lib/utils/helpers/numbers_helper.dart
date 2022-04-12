import 'package:intl/intl.dart';

class NumbersHelper {
  static getMoneyFormat(dynamic number) {
    var f = NumberFormat("###,###");
    return f.format(number);
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    if (s.isEmpty) return true;
    if (s[s.length - 1] == ".") return false;
    return double.tryParse(s) != null;
  }

  static String? correctNumber(String s) {
    if (!isNumeric(s)) return null;
    return double.parse(s).toString();
  }
}
