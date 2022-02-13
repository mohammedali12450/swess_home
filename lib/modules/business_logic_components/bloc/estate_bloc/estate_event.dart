import 'package:swesshome/modules/data/models/search_data.dart';

abstract class EstateEvent {}

class EstateFetchStarted extends EstateEvent {
  SearchData searchData;
  bool isAdvanced;

  EstateFetchStarted({required this.searchData, required this.isAdvanced});
}

class OfficeEstatesFetchStarted extends EstateEvent {
  int officeId;

  OfficeEstatesFetchStarted({required this.officeId});
}
