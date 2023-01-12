import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateOrderProvider {
  Future<Response> sendEstateOrder(EstateOrder order, String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response =
          await helper.post(createEstateOrderURL, order.toJson(), token: token);
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<Response> getRecentEstateOrders(String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response =
        await helper.get(getEstateOrderURL, token: token);
    return response;
  }

  Future<Response> deleteRecentEstateOrders(String? token, int? orderId) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.delete(deleteEstateOrderURL,
        queryParameters: {"estate_order_id": orderId}, token: token);
    return response;
  }
}
