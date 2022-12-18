import 'package:swesshome/modules/data/models/estate.dart';

abstract class EstateState {}

class EstateFetchError extends EstateState {
  String errorMessage;
  final bool isConnectionError ;
  EstateFetchError({required this.errorMessage , this.isConnectionError = false});
}

class EstateFetchComplete extends EstateState {
  //List<Estate> estates;
  EstateSearch estateSearch;

  EstateFetchComplete({required this.estateSearch});
}

class EstateOfficeFetchComplete extends EstateState {
  List<Estate> estates;
  //EstateSearch estateSearch;

  EstateOfficeFetchComplete({required this.estates});
}

class EstateFetchProgress extends EstateState {}

class EstateFetchNone extends EstateState {}
