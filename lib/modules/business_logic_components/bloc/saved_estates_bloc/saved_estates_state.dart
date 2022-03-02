import 'package:swesshome/modules/data/models/estate.dart';

abstract class SavedEstatesState {}

class SavedEstatesFetchNone extends SavedEstatesState {}

class SavedEstatesFetchError extends SavedEstatesState {
  String error;

  SavedEstatesFetchError({required this.error});
}

class SavedEstatesFetchProgress extends SavedEstatesState {}

class SavedEstatesFetchComplete extends SavedEstatesState {
  List<Estate> savedEstates;

  SavedEstatesFetchComplete({required this.savedEstates});
}
