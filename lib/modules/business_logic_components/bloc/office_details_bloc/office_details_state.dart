// States
import 'package:swesshome/modules/data/models/estate_office.dart';

abstract class GetOfficesStates {}

class GetOfficesFetchNone extends GetOfficesStates {}

class GetOfficesFetchError extends GetOfficesStates {
  String errorMessage ;
  final bool isConnectionError ;

  GetOfficesFetchError({required this.errorMessage , this.isConnectionError = false});
}

class GetOfficesFetchProgress extends GetOfficesStates {}

class GetOfficesFetchComplete extends GetOfficesStates {
  EstateOffice results ;

  GetOfficesFetchComplete({required this.results});
}
