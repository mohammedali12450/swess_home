import 'package:swesshome/modules/data/models/estate.dart';

abstract class EstateViewState {}

class EstateFetchError extends EstateViewState {
  String errorMessage;
  final bool isConnectionError ;
  EstateFetchError({required this.errorMessage , this.isConnectionError = false});
}

class EstateMostViewFetchComplete extends EstateViewState {
  List<Estate> estates;
  EstateMostViewFetchComplete({required this.estates});
}
class EstateMostViewFetchProgress extends EstateViewState {}

class EstateFetchNone extends EstateViewState {}
