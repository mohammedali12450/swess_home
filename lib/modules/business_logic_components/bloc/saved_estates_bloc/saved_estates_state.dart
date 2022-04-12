import 'package:swesshome/modules/data/models/estate.dart';

abstract class SavedEstatesState {}

class SavedEstatesFetchNone extends SavedEstatesState {}

class SavedEstatesFetchError extends SavedEstatesState {
  String error;
  final bool isConnectionError ;

  SavedEstatesFetchError({required this.error , this.isConnectionError = false });
}

class SavedEstatesFetchProgress extends SavedEstatesState {}

class SavedEstatesFetchComplete extends SavedEstatesState {
  List<Estate> savedEstates;

  SavedEstatesFetchComplete({required this.savedEstates});
}
