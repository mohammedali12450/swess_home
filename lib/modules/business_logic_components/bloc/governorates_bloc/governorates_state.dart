import '../../../data/models/governorates.dart';

abstract class GovernoratesState {}

class GovernoratesFetchNone extends GovernoratesState {}

class GovernoratesFetchError extends GovernoratesState {}

class GovernoratesFetchProgress extends GovernoratesState {}

class GovernoratesFetchComplete extends GovernoratesState {

  final List<Governorate> governorates;

  GovernoratesFetchComplete({required this.governorates});

}


