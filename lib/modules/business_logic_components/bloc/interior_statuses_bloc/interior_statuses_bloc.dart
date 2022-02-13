import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/models/interior_status.dart';
import 'package:swesshome/modules/data/repositories/interior_statuses_repository.dart';

import 'interior_statuses_event.dart';
import 'interior_statuses_state.dart';

class InteriorStatusesBloc
    extends Bloc<InteriorStatusesEvent, InteriorStatusesState> {
  List<InteriorStatus>? interiorStatuses;

  InteriorStatusesRepository interiorStatusesRepository;

  InteriorStatusesBloc(this.interiorStatusesRepository)
      : super(InteriorStatusesFetchNone()) {
    on<InteriorStatusesFetchStarted>((event, emit) async {
      emit(InteriorStatusesFetchProgress());
      try {
        interiorStatuses = await interiorStatusesRepository.fetchData();
        emit(InteriorStatusesFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
