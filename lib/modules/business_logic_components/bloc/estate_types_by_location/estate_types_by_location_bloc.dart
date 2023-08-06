import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/repositories/estate_types_repository.dart';

import '../estate_types_bloc/estate_types_state.dart';
import 'estate_types_by_location_event.dart';

class EstateTypesByLocationBloc
    extends Bloc<EstateTypesByLocationEvent, EstateTypesState> {
  EstateTypesRepository estateTypesRepository;
  List<EstateType>? estateTypes;

  EstateTypesByLocationBloc(this.estateTypesRepository)
      : super(EstateTypesFetchNone()) {
    on<EstateTypeFetchByLocation>((event, emit) async {
      emit(EstateTypesFetchProgress());
      try {
        estateTypes =
            await estateTypesRepository.fetchDataByLocation(event.location_id);
        emit(EstateTypesFetchComplete(estateTypes));
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
