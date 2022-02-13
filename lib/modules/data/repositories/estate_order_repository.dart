import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/exceptions/unauthorized_exception.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/providers/estate_order_provider.dart';

class EstateOrderRepository {
  EstateOrderProvider estateOrderProvider = EstateOrderProvider();

  Future<void> sendEstateOrder(EstateOrder order , String? token) async {
    Response response = await estateOrderProvider.sendEstateOrder(order , token);

    if (response.statusCode == 401) {
      throw UnauthorizedException(
          message: "يجب تسجيل الدخول لاستخدام هذه الميزة");
    }
    if (response.statusCode != 201) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء إرسال الطلب");
    }
  }
}
