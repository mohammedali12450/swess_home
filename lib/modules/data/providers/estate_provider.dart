import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateProvider {
  Future sendEstate(Estate estate, String token, {Function(int)? onSendProgress}) async {
    NetworkHelper helper = NetworkHelper();
    FormData data = FormData.fromMap(await estate.toJson());
    Response response;

    try {
      response =
          await helper.post(sendEstateUrl, data, token: token, onSendProgress: onSendProgress);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future search(SearchData searchData, bool isAdvanced, int page, String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.post(
          (isAdvanced) ? advancedSearchUrl : searchUrl,
          FormData.fromMap(
            searchData.toJson(isAdvanced),
          ),
          queryParameters: {"page": page},
          token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future getOfficeEstates(int officeId) async {
    NetworkHelper helper = NetworkHelper();

    Response response;

    try {
      response = await helper.get(getOfficeEstatesUrl, queryParameters: {"office_id": officeId});
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future getCreatedEstates(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(getUserEstatesUrl, token: token);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future getSavedEstates(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(getSavedEstatesUrl, token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future like(String? token, int likeObjectId, LikeType likeType) async {
    NetworkHelper helper = NetworkHelper();

    Map<String, dynamic> data = {};
    String url = "";
    switch (likeType) {
      case LikeType.estate:
        data = {"estate_id": likeObjectId};
        url = likeEstateUrl;
        break;
      case LikeType.estateOffice:
        data = {"office_id": likeObjectId};
        url = likeOfficeUrl;
        break;
    }

    Response response;

    try {
      response = await helper.post(url, data, token: token);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future unlikeEstate(String? token, int likeObjectId, LikeType likeType) async {
    NetworkHelper helper = NetworkHelper();

    Map<String, dynamic> data = {};
    String url = "";
    switch (likeType) {
      case LikeType.estate:
        data = {"estate_id": likeObjectId};
        url = unlikeEstateUrl;
        break;
      case LikeType.estateOffice:
        data = {"office_id": likeObjectId};
        url = unlikeOfficeUrl;
        break;
    }

    Response response;

    try {
      response = await helper.delete(url, fromData: data, token: token);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future saveEstate(String? token, int estateId) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.post(saveEstateUrl, {"estate_id": estateId}, token: token);
    return response;
  }

  Future unSaveEstate(String? token, int estateId) async {
    NetworkHelper helper = NetworkHelper();
    Response response =
        await helper.delete(unSaveEstateUrl, fromData: {"estate_id": estateId}, token: token);
    return response;
  }

  Future visitRegister(String? token, int visitId, VisitType visitType) async {
    NetworkHelper helper = NetworkHelper();

    Map<String, dynamic> data = {};
    String url = "";
    switch (visitType) {
      case VisitType.estate:
        data = {"estate_id": visitId};
        url = visitEstateUrl;
        break;
      case VisitType.estateOffice:
        data = {"office_id": visitId};
        url = visitOfficeUrl;

        break;
      case VisitType.estateCall:
        data = {"estate_id": visitId};
        url = callEstateUrl;
        break;
    }

    Response response = await helper.post(url, data, token: token);
    return response;
  }
}
