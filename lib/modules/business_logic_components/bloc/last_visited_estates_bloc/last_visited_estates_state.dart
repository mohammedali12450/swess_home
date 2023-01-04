import 'package:swesshome/modules/data/models/estate.dart';

abstract class LastVisitedEstatesState {}

class LastVisitedEstatesFetchProgress extends LastVisitedEstatesState {}

class LastVisitedEstatesFetchError extends LastVisitedEstatesState {
  String error;
  final bool isConnectionError ;
  LastVisitedEstatesFetchError({required this.error , this.isConnectionError = false });
}

class LastVisitedEstatesFetchComplete extends LastVisitedEstatesState {
  List<Estate> lastVisitedEstates;

  LastVisitedEstatesFetchComplete({required this.lastVisitedEstates});
}

class LastVisitedEstatesFetchNone extends LastVisitedEstatesState {}
