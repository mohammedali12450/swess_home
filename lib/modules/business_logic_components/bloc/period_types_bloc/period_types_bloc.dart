import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/period_types_bloc/period_types_state.dart';
import 'package:swesshome/modules/data/models/period_type.dart';
import 'package:swesshome/modules/data/repositories/period_types_repository.dart';
import 'period_types_event.dart';

class PeriodTypesBloc
    extends Bloc<PeriodTypesEvent, PeriodTypesState> {
  PeriodTypeRepository periodTypeRepository;
  List<PeriodType>? periodTypes;

  PeriodTypesBloc(this.periodTypeRepository)
      : super(PeriodTypesFetchNone()) {
    on<PeriodTypesFetchStarted>((event, emit) async {
      emit(PeriodTypesFetchProgress());

      try {
        periodTypes = await periodTypeRepository.fetchData();
        emit(PeriodTypesFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
