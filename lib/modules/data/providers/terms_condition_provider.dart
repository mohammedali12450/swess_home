import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import '../../../utils/services/network_helper.dart';

class TermsAndConditionsProvider {
  Future fetchData(String termsType) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(termsAndConditionsURL+termsType);
    return response;
  }
}
