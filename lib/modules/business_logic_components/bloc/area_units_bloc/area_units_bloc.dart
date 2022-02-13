import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/models/area_unit.dart';
import 'package:swesshome/modules/data/repositories/area_units_repository.dart';

import 'area_units_event.dart';
import 'area_units_state.dart';

class AreaUnitsBloc extends Bloc<AreaUnitsEvent, AreaUnitsState> {
  AreaUnitsRepository areaUnitsRepository;
  List<AreaUnit>? areaUnits;

  AreaUnitsBloc(this.areaUnitsRepository) : super(AreaUnitsFetchNone()) {
    on<AreaUnitsFetchStarted>((event, emit) async {
      emit(AreaUnitsFetchProgress());
      try {
        areaUnits = await areaUnitsRepository.fetchData();
        emit(AreaUnitsFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
