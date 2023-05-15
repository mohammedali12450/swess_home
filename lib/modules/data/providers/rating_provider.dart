import 'package:dio/dio.dart';

import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class RatingProvider {
  Future sendRate(String? token, String? notes, String rate) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.post(
        ratingURL,
        {
          "rate": rate,
          "notes": notes,
        },
        token: token,
      );
    } catch (_) {
      rethrow;
    }

    return response;
  }
}
