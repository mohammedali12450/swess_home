import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/estate_offer_type.dart';
import 'package:swesshome/modules/data/providers/estate_offer_types_provider.dart';

class EstateOfferTypesRepository {
  EstateOfferTypesProvider estateOfferTypesProvider = EstateOfferTypesProvider();

  Future<List<EstateOfferType>> fetchData() async {
    Response response = await estateOfferTypesProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    var estateOfferTypesJson = jsonDecode(response.toString())['data'] as List;
    List<EstateOfferType> estateOfferTypes = estateOfferTypesJson
        .map<EstateOfferType>((e) => EstateOfferType.fromJson(e))
        .toList();
    return estateOfferTypes;
  }
}
