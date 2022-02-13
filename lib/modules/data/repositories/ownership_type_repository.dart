import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/providers/ownership_type_provider.dart';

class OwnershipTypeRepository {
  OwnershipTypeProvider ownershipTypeProvider = OwnershipTypeProvider();

  Future<List<OwnershipType>> fetchData() async {
    Response response = await ownershipTypeProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    var ownershipTypesJson = jsonDecode(response.toString())['data'] as List;
    List<OwnershipType> ownershipTypes = ownershipTypesJson
        .map<OwnershipType>((e) => OwnershipType.fromJson(e))
        .toList();

    return ownershipTypes;
  }
}
