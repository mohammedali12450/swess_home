import 'package:swesshome/modules/data/models/estate.dart';

abstract class SendEstateEvent {}

class SendEstateStarted extends SendEstateEvent {
  Estate estate;
  String token;
  Function(int)?onSendProgress ;
  SendEstateStarted({required this.estate , required this.token , this.onSendProgress});
}
