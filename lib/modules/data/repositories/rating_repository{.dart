import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/providers/rating_provider.dart';

class RatingRepository {
  final RatingProvider _ratingProvider = RatingProvider();

  Future sendRate(String? token, String notes, String rate) async {
    Response response;

    try {
      response = await _ratingProvider.sendRate(token, notes, rate);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }

    return response;
  }
}
