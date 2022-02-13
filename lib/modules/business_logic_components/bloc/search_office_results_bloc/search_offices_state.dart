// States
import 'package:swesshome/modules/data/models/estate_office.dart';

abstract class SearchOfficesStates {}

class SearchOfficesFetchNone extends SearchOfficesStates {}

class SearchOfficesFetchError extends SearchOfficesStates {
  String errorMessage ;

  SearchOfficesFetchError({required this.errorMessage});
}

class SearchOfficesFetchProgress extends SearchOfficesStates {}

class SearchOfficesFetchComplete extends SearchOfficesStates {
  List<EstateOffice> results ;

  SearchOfficesFetchComplete({required this.results});
}
