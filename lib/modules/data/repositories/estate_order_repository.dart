import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/providers/estate_order_provider.dart';

import '../models/search_data.dart';

class EstateOrderRepository {
  EstateOrderProvider estateOrderProvider = EstateOrderProvider();

  Future<void> sendEstateOrder(SearchData order, String? token) async {
    Response response;

    try {
      response = await estateOrderProvider.sendEstateOrder(order, token);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode == 401) {
      throw UnauthorizedException(
          message: "يجب تسجيل الدخول لاستخدام هذه الميزة");
    }
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء إرسال الطلب");
    }
  }

  Future<List<EstateOrder>> getRecentEstateOrders(String? token) async {
    Response response = await estateOrderProvider.getRecentEstateOrders(token);
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناءالاتصال مع السيرفر");
    }

    var jsonEstateOrders = jsonDecode(response.toString())["data"] as List;
    List<EstateOrder> orders =
        jsonEstateOrders.map((e) => EstateOrder.fromJson(e)).toList();
    return orders;
  }

  Future deleteRecentEstateOrders(String? token, int? orderId) async {
    Response response =
        await estateOrderProvider.deleteRecentEstateOrders(token, orderId);

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناءالاتصال مع السيرفر");
    }
  }
}
