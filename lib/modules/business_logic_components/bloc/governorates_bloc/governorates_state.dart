
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/data/models/location.dart';

import '../../../data/models/governorates.dart';

abstract class GovernoratesState {}

class GovernoratesFetchNone extends GovernoratesState {}

class GovernoratesFetchError extends GovernoratesState {}

class GovernoratesFetchProgress extends GovernoratesState {}

class GovernoratesFetchComplete extends GovernoratesState {

  final List<Governorate> governorates;

  GovernoratesFetchComplete({required this.governorates});

}


