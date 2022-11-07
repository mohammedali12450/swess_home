import 'package:dio/dio.dart';
import '../../../utils/services/network_helper.dart';

class TermsAndConditionsProvider {
  Future fetchData(String termsType) async {
    NetworkHelper helper = NetworkHelper();
    //print("$hostingerBaseUrl$termsAndConditionsUrl$termsType");
    Response response = await helper.get("http://swesshomerealestate.com/api/termsandconditions/get/$termsType");

    return response;
  }
}
