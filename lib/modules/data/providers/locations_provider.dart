import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class LocationsProvider{

  Future getLocations()async{
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(getLocationURL) ;
    return response ;
  }
}