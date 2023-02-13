
import 'package:swesshome/modules/data/models/search_data.dart';

abstract class EstateOrderEvent{}
class SendEstateOrderStarted extends EstateOrderEvent {
  SearchData order ;
  String? token ;
  SendEstateOrderStarted({required this.order , this.token});
}