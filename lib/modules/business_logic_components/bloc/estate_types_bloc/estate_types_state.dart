import '../../../data/models/estate_type.dart';

abstract class EstateTypesState {}

class EstateTypesFetchComplete extends EstateTypesState {
  List<EstateType>? estateTypes;

  EstateTypesFetchComplete(this.estateTypes);
}

class EstateTypesFetchError extends EstateTypesState {}

class EstateTypesFetchProgress extends EstateTypesState {}

class EstateTypesFetchNone extends EstateTypesState {}
