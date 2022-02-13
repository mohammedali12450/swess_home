import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/data/repositories/estate_types_repository.dart';
import 'estate_types_event.dart';
import 'estate_types_state.dart';

class EstateTypesBloc extends Bloc<EstateTypesEvent, EstateTypesState> {
  EstateTypesRepository estateTypesRepository;
  List<EstateType>? estateTypes;

  EstateTypesBloc(this.estateTypesRepository) : super(EstateTypesFetchNone()) {
    on<EstateTypesFetchStarted>((event, emit) async {
      emit(EstateTypesFetchProgress());
      try {
        estateTypes = await estateTypesRepository.fetchData();
        emit(EstateTypesFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
