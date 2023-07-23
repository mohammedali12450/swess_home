import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/governorates.dart';
import '../providers/governorate_provider.dart';

class GovernoratesRepository {

  final GovernoratesProvider _governoratesProvider = GovernoratesProvider();

  Future<List<Governorate>> getGovernorates() async {
    Response response = await _governoratesProvider.getGovernorates();
    var governoratesJSON = jsonDecode(response.toString())["data"] as List;
    List<Governorate> governorates = governoratesJSON
        .map<Governorate>(
            (governorateJson) => Governorate.fromJson(governorateJson))
        .toList();
    return governorates;
  }
}
