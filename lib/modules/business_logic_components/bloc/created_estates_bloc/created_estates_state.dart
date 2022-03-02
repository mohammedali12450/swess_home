import 'package:swesshome/modules/data/models/estate.dart';

abstract class CreatedEstatesState {}

class CreatedEstatesFetchProgress extends CreatedEstatesState {}

class CreatedEstatesFetchError extends CreatedEstatesState {
  String error;

  CreatedEstatesFetchError({required this.error});
}

class CreatedEstatesFetchComplete extends CreatedEstatesState {
  List<Estate> createdEstates;

  CreatedEstatesFetchComplete({required this.createdEstates});
}

class CreatedEstatesFetchNone extends CreatedEstatesState {}
