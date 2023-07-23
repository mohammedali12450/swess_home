import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/governorates.dart';
import '../../../data/repositories/governorates_repository.dart';
import 'governorates_event.dart';
import 'governorates_state.dart';


class GovernoratesBloc extends Bloc<GovernoratesEvent, GovernoratesState> {
  GovernoratesRepository governoratesRepository = GovernoratesRepository();
  List<Governorate>? governorates;

  GovernoratesBloc() : super(GovernoratesFetchNone()) {
    on<GovernoratesFetchStarted>((event, emit) async {
      emit(GovernoratesFetchProgress());
      try {
        governorates = await governoratesRepository.getGovernorates();
        emit(GovernoratesFetchComplete(governorates: governorates! == null ? governorates! : []));
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }

}