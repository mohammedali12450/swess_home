import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class PreviousSearchResultsProvider {
  Future fetchData() async {


    Response response = await Dio().get(previousResultsSearchZonesUrl,options: Options(headers: {
      'Authorization': 'Bearer ${UserSharedPreferences.getAccessToken()}'
    }));

    return response;
  }
}