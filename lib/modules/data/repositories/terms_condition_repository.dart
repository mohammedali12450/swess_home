import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/exceptions/general_exception.dart';
import '../models/terma_condition.dart';
import '../providers/terms_condition_provider.dart';

class TermsAndConditionsRepository {
  final TermsAndConditionsProvider _termsAndConditionsProvider =
      TermsAndConditionsProvider();

  Future<TermsCondition> fetchData(String termsType) async {
    Response response;

    try {
      response = await _termsAndConditionsProvider.fetchData(termsType);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }

    // var jsonPacket = jsonDecode(response.toString());
    // TermsCondition termsCondition = TermsCondition.fromJson();
    // return termsCondition;

    TermsCondition termsCondition =
        TermsCondition.fromJson((jsonDecode(response.toString())));
    return termsCondition;
  }
}
