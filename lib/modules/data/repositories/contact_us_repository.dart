import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/fields_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/core/exceptions/unknown_exception.dart';
import 'package:swesshome/modules/data/providers/contact_us_provider.dart';

class ContactUsRepository {
  ContactUsProvider contactUsProvider = ContactUsProvider();

  Future sendDirectMessage(String email, String title, String message) async {
    Response response;

    try {
      response =
      await contactUsProvider.sendDirectMessage(email, title, message);
    } catch (_) {
      rethrow;
    }

    if (response.statusCode == 422) {
      throw FieldsException(jsonErrorFields: jsonDecode(response.toString()));
    }

    if (response.statusCode == 403) {
      throw UnauthorizedException(
          message: jsonDecode(response.toString())["message"]);
    }

    if (response.statusCode == 400) {
      throw GeneralException(
          errorMessage: jsonDecode(response.toString())["message"]);
    }

    if (response.statusCode != 200) {
      throw UnknownException();
    }
  }
}
