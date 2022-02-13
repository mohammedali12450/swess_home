import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateProvider {
  Future sendEstate(Estate estate, String token,
      {Function(int)? onSendProgress}) async {
    NetworkHelper helper = NetworkHelper();
    FormData data = FormData.fromMap(await estate.toJson());
    Response response = await helper.post(sendEstateUrl, data, token: token , onSendProgress: onSendProgress);
    return response;
  }

  Future search(SearchData searchData, bool isAdvanced, int page) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.post(
      (isAdvanced) ? advancedSearchUrl : searchUrl,
      searchData.toJson(isAdvanced),
      queryParameters: {"page": page},
    );
    return response;
  }

  Future getOfficeEstates(int officeId) async {
    NetworkHelper helper = NetworkHelper();

    Response response = await helper
        .get(getOfficeEstatesUrl, queryParameters: {"office_id": officeId});

    return response;
  }
}
