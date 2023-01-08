import 'package:swesshome/modules/data/models/search_data.dart';

abstract class EstateEvent {}

class EstateFetchStarted extends EstateEvent {
  SearchData searchData;
  bool isAdvanced;
  String? token;

  EstateFetchStarted(
      {required this.searchData,
      required this.isAdvanced,
      required this.token});
}

class FilterEstateFetchStarted extends EstateEvent {
  SearchData searchData;
  bool isAdvanced;
  String? token;

  FilterEstateFetchStarted(
      {required this.searchData,
      required this.isAdvanced,
      required this.token});
}

class OfficeEstatesFetchStarted extends EstateEvent {
  int officeId;

  OfficeEstatesFetchStarted({required this.officeId});
}

class NewestEstatesFetchStarted extends EstateEvent {
  NewestEstatesFetchStarted();
}

class MostViewEstatesFetchStarted extends EstateEvent {
  MostViewEstatesFetchStarted();
}

class SpacialEstatesFetchStarted extends EstateEvent {
  SpacialEstatesFetchStarted();
}
