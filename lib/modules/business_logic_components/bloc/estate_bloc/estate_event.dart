import 'package:swesshome/modules/data/models/search_data.dart';


abstract class EstateEvent {}

class EstatesFetchStarted extends EstateEvent {
  SearchData searchData;
  bool isAdvanced;
  String? token;

  EstatesFetchStarted(
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

class EstateFetchStarted extends EstateEvent {
 int estateId;

  EstateFetchStarted({required this.estateId});
}
