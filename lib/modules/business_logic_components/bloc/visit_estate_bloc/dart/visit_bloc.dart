import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_state.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  EstateRepository estateRepository;

  VisitBloc(this.estateRepository) : super(VisitNone()) {
    on<VisitStarted>((event, emit) async {
      emit(VisitProgress());
      try {
        await estateRepository.visitRegister(event.token, event.visitId ,event.visitType);
        emit(VisitComplete());
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(VisitError(error: e.errorMessage));
        }
        print(e);
        print(stack);
      }
    });
  }
}
