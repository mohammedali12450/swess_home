import 'package:intl/intl.dart';

class NumbersHelper {
  static getMoneyFormat(dynamic number) {
    var f = NumberFormat("###,###");
    return f.format(number);
  }
}
