import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class AreaUnitsProvider{

  Future fetchData()async{
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(areaUnitsUrl);
    return response ;
  }

}