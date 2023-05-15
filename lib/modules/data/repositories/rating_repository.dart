import 'package:dio/dio.dart';

import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/main.dart';
import 'package:swesshome/modules/data/providers/rating_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingRepository {
  final RatingProvider _ratingProvider = RatingProvider();

  Future<Response> sendRate(String? token, String? notes, String rate) async {
    Response response;

    try {
      response = await _ratingProvider.sendRate(token, notes, rate);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode == 401) {
      throw GeneralException(
        errorMessage: AppLocalizations.of(navigatorKey.currentState!.context)!
            .notLoggedYet,
      );
    }

    if (response.statusCode != 200) {
      throw GeneralException(
        errorMessage: AppLocalizations.of(navigatorKey.currentState!.context)!
            .serverErrorOccurred,
      );
    }

    return response;
  }
}
