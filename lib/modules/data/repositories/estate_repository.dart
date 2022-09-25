import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/constants/enums.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/main.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/modules/data/providers/estate_provider.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/estate_office.dart';

class EstateRepository {
  final EstateProvider _estateProvider = EstateProvider();

  Future sendEstate(Estate estate, String token,
      {Function(int)? onSendProgress}) async {
    Response response;

    try {
      response = await _estateProvider.sendEstate(estate, token,
          onSendProgress: onSendProgress);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode != 201) {
      throw UnknownException();
    }
    return response;
  }

  Future search(
      SearchData searchData, bool isAdvanced, int page, String? token) async {
    Response response;

    try {
      response =
          await _estateProvider.search(searchData, isAdvanced, page, token);
      print(response);
    } catch (e) {
      print(e);
      rethrow;
    }
    if ((response.statusCode == 201) && (page == 1)) {
      showWonderfulAlertDialog(
        navigatorKey.currentContext!,
        AppLocalizations.of(navigatorKey.currentContext!)!.caution,
        AppLocalizations.of(navigatorKey.currentContext!)!.war,
      );
    }
    if ((response.statusCode == 202) && (page == 1)) {
      if (jsonDecode(response.toString())["data"].isEmpty) {
        showWonderfulAlertDialog(
          navigatorKey.currentContext!,
          AppLocalizations.of(navigatorKey.currentContext!)!.warning,
          AppLocalizations.of(navigatorKey.currentContext!)!
              .empty,
        );
      } else {
        showWonderfulAlertDialog(
          navigatorKey.currentContext!,
          AppLocalizations.of(navigatorKey.currentContext!)!.caution,
          AppLocalizations.of(navigatorKey.currentContext!)!.sorry,
        );
      }
    }
    if (response.statusCode != 201 &&
        response.statusCode != 202 &&
        response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ");
    }
    dynamic jsonEstates = jsonDecode(response.toString())["data"];
    List<Estate> estates = [];
    // check if result estates is list :
    if (jsonEstates is List) {
      estates = jsonEstates.map<Estate>((e) => Estate.fromJson(e)).toList();
      return estates;
    }
    // check if result estates is map :
    else if (jsonEstates is Map) {
      estates = jsonEstates.values.map((e) => Estate.fromJson(e)).toList();
      return estates;
    }
    return estates;
  }

  Future getOfficeEstates(int officeId) async {
    Response response;

    try {
      response = await _estateProvider.getOfficeEstates(officeId);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "! لا يمكن الاتصال بالسيرفر");
    }

    dynamic jsonEstates = jsonDecode(response.toString())["data"];
    List<Estate> estates = [];
    estates = jsonEstates.map<Estate>((e) => Estate.fromJson(e)).toList();
    return estates;
  }

  Future getOfficeDetails(int officeId) async {
    Response response;

    try {
      response = await _estateProvider.getOfficeDetails(officeId);
      print("ghina2 : $response");
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "! لا يمكن الاتصال بالسيرفر");
    }

    dynamic jsonEstates = jsonDecode(response.toString())["data"];

    EstateOffice estate = EstateOffice.fromJson(jsonEstates);
    return estate;
  }

  Future getCreatedEstates(String token) async {
    Response response;

    try {
      response = await _estateProvider.getCreatedEstates(token);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "! لا يمكن الاتصال بالسيرفر");
    }

    dynamic jsonEstates = jsonDecode(response.toString())["data"];
    List<Estate> estates = [];
    estates = jsonEstates.map<Estate>((e) => Estate.fromJson(e)).toList();
    return estates;
  }

  Future getSavedEstates(String token) async {
    Response response;

    try {
      response = await _estateProvider.getSavedEstates(token);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "! لا يمكن الاتصال بالسيرفر");
    }

    dynamic jsonEstates = jsonDecode(response.toString())["data"];
    List<Estate> estates = [];
    estates = jsonEstates.map<Estate>((e) => Estate.fromJson(e)).toList();
    return estates;
  }

  Future like(String? token, int likeObjectId, LikeType likeType) async {
    Response response;

    try {
      response = await _estateProvider.like(token, likeObjectId, likeType);
    } catch (e) {
      rethrow;
    }
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    return response;
  }

  Future unlikeEstate(
      String? token, int likeObjectId, LikeType likeType) async {
    Response response;

    try {
      response =
          await _estateProvider.unlikeEstate(token, likeObjectId, likeType);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    return response;
  }

  Future saveEstate(String? token, int estateId) async {
    Response response = await _estateProvider.saveEstate(token, estateId);

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    return response;
  }

  Future unSaveEstate(String? token, int estateId) async {
    Response response = await _estateProvider.unSaveEstate(token, estateId);
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    return response;
  }

  Future visitRegister(String? token, int visitId, VisitType visitType) async {
    Response response =
        await _estateProvider.visitRegister(token, visitId, visitType);

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر!");
    }

    return response;
  }

  Future deleteUserNewEstate(String? token, int? id) async {
    Response response = await _estateProvider.deleteUserNewEstate(token, id);

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر!");
    }
  }
}
