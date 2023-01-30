import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateProvider {
  Future sendEstate(Estate estate, String token,
      {Function(int)? onSendProgress}) async {
    NetworkHelper helper = NetworkHelper();
    FormData data = FormData.fromMap(await estate.toJson());
    Response response;

    try {
      response = await helper.post(createEstateOfferURL, data,
          token: token, onSendProgress: onSendProgress);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future getEstate(int estateId) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(getEstateDetailsURL + "$estateId");
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future search(
      SearchData searchData, bool isAdvanced, int page, String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.post(
         // (isAdvanced) ? advancedSearchUrl :
          searchResultEstateURL,
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

  Future getOfficeDetails(int officeId, int page, String? token) async {
    NetworkHelper helper = NetworkHelper();

    Response response;
    try {
      print("baba $token");
      response = await helper.get(
          token == null
              ? "$getOfficeDetailsURL$officeId"
              : "$getOfficeDetailsWithAuthURL$officeId",
          //, queryParameters: {"office_id": officeId}
          queryParameters: {"page": page},
          token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future getCreatedEstates(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(getEstateOfferURL, token: token);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future getSavedEstates(String token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(getSavedEstatesURL, token: token);
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
        url = likeEstateURL;
        break;
      case LikeType.estateOffice:
        data = {"office_id": likeObjectId};
        url = likeOfficeURL;
        break;
    }

    Response response;
    try {
      response = await helper.post(url, data, token: token);
      print(response);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future unlikeEstate(
      String? token, int likeObjectId, LikeType likeType) async {
    NetworkHelper helper = NetworkHelper();

    Map<String, dynamic> data = {};
    String url = "";
    switch (likeType) {
      case LikeType.estate:
        data = {"estate_id": likeObjectId};
        url = unlikeEstateURL;
        break;
      case LikeType.estateOffice:
        data = {"office_id": likeObjectId};
        url = unlikeOfficeURL;
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
    Response response =
        await helper.post(saveEstateURL, {"estate_id": estateId}, token: token);
    return response;
  }

  Future unSaveEstate(String? token, int estateId) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.delete(unSaveEstateURL,
        fromData: {"estate_id": estateId}, token: token);
    return response;
  }

  Future visitRegister(String? token, int visitId, VisitType visitType) async {
    NetworkHelper helper = NetworkHelper();

    Map<String, dynamic> data = {};
    String url = "";
    switch (visitType) {
      case VisitType.estate:
        data = {"estate_id": visitId};
        url = visitEstateURL;
        break;
      case VisitType.estateOffice:
        data = {"office_id": visitId};
        url = visitOfficeURL;
        break;
      case VisitType.officeCall:
        data = {"estate_id": visitId};
        url = callEstateURL;
        break;
    }

    Response response = await helper.post(url, data, token: token);
    return response;
  }

  Future shareEstateCount(String? token, int estateId) async {
    NetworkHelper helper = NetworkHelper();

    Response response;
    try {
      response = await helper.post(shareCountEstateURL, {"estate_id": estateId},
          token: token);
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future deleteUserNewEstate(String? token, int? id) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.delete(deleteUserEstateOfferURL,
        queryParameters: {"id": id}, token: token);
    return response;
  }

  Future getSpecialEstates() async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(specialEstateURL);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future getNewestEstates() async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(newestEstateURL);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future getMostViewEstates() async {
    NetworkHelper helper = NetworkHelper();
    Response response;

    try {
      response = await helper.get(mostViewEstateURL);
    } catch (e) {
      rethrow;
    }
    return response;
  }
}
