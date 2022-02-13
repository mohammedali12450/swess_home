import 'package:intl/intl.dart';

class DateHelper{

  static String getDateByFormat(DateTime dateTime , String format){
    var formatter = DateFormat(format);
    String formattedDate = formatter.format(dateTime);
    return formattedDate ;
  }

}