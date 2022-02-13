
import 'package:swesshome/modules/data/models/estate_order.dart';

abstract class EstateOrderEvent{}
class SendEstateOrderStarted extends EstateOrderEvent {
  EstateOrder order ;
  String? token ;
  SendEstateOrderStarted({required this.order , this.token});
}