import 'package:swesshome/constants/enums.dart';

abstract class VisitEvent {}

class VisitStarted extends VisitEvent {
  int visitId;
  VisitType visitType ;
  String? token;

  VisitStarted({required this.visitId, required this.token ,required this.visitType});
}
