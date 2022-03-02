import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/models/system_variables.dart';
import 'package:swesshome/modules/data/repositories/system_variables_repository.dart';
import 'area_units_event.dart';
import 'area_units_state.dart';

class SystemVariablesBloc extends Bloc<SystemVariablesEvent, SystemVariablesState> {

  SystemVariablesRepository systemVariablesRepository;

  SystemVariables? systemVariables;

  SystemVariablesBloc(this.systemVariablesRepository) : super(SystemVariablesFetchNone()) {
    on<SystemVariablesFetchStarted>((event, emit) async {
      emit(SystemVariablesFetchProgress());
      try {
        systemVariables = await systemVariablesRepository.fetchData();
        emit(SystemVariablesFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
