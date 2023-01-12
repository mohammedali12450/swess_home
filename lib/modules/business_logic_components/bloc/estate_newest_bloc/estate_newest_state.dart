import 'package:swesshome/modules/data/models/estate.dart';

abstract class EstateNewestState {}

class EstateFetchError extends EstateNewestState {
  String errorMessage;
  final bool isConnectionError ;
  EstateFetchError({required this.errorMessage , this.isConnectionError = false});
}

class EstateNewestFetchComplete extends EstateNewestState {
  List<Estate> estates;
  EstateNewestFetchComplete({required this.estates});
}

class EstateNewestFetchProgress extends EstateNewestState {}


class EstateFetchNone extends EstateNewestState {}
