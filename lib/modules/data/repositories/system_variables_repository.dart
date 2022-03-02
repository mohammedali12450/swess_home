import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/models/system_variables.dart';
import 'package:swesshome/modules/data/providers/system_variables_provider.dart';

class SystemVariablesRepository {
  SystemVariablesProvider systemVariablesProvider = SystemVariablesProvider();

  Future<SystemVariables> fetchData() async {
    Response response = await systemVariablesProvider.fetchData();

    if (response.statusCode != 200) {
      throw UnknownException();
    }

    SystemVariables systemVariables =
        SystemVariables.fromJson((jsonDecode(response.toString())['data']).first);
    return systemVariables;
  }
}
