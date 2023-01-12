import 'package:swesshome/modules/data/models/estate.dart';

abstract class EstateState {}

class EstateFetchError extends EstateState {
  String errorMessage;
  final bool isConnectionError ;
  EstateFetchError({required this.errorMessage , this.isConnectionError = false});
}

class EstatesFetchComplete extends EstateState {
  //List<Estate> estates;
  EstateSearch estateSearch;

  EstatesFetchComplete({required this.estateSearch});
}

class EstateFetchComplete extends EstateState {
  Estate estate;

  EstateFetchComplete({required this.estate});
}

class FilterEstateFetchComplete extends EstateState {
  EstateSearch estateSearch;

  FilterEstateFetchComplete({required this.estateSearch});
}

class EstatesFetchProgress extends EstateState {}
class EstateFetchProgress extends EstateState {}
class FilterEstateFetchProgress extends EstateState {}

class EstateFetchNone extends EstateState {}
