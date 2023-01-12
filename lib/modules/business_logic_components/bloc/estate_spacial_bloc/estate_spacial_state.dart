import 'package:swesshome/modules/data/models/estate.dart';

abstract class EstateSpacialState {}

class EstateFetchError extends EstateSpacialState {
  String errorMessage;
  final bool isConnectionError ;
  EstateFetchError({required this.errorMessage , this.isConnectionError = false});
}

class EstateSpacialFetchComplete extends EstateSpacialState {
  List<SpecialEstate> estates;
  EstateSpacialFetchComplete({required this.estates});
}
class EstateSpacialFetchProgress extends EstateSpacialState {}

class EstateFetchNone extends EstateSpacialState {}
