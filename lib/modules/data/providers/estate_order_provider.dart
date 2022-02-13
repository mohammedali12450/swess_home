import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class EstateOrderProvider {
  Future<Response> sendEstateOrder(EstateOrder order , String? token) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.post(sendEstateOrderUrl, order.toJson() , token: token);
    return response;
  }
}
