import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/terms_condition_bloc/terms_condition_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/terms_condition_bloc/terms_condition_state.dart';

import '../../../../core/exceptions/connection_exception.dart';
import '../../../../core/exceptions/general_exception.dart';
import '../../../data/models/terma_condition.dart';
import '../../../data/repositories/terms_condition_repository.dart';


class TermsConditionBloc
    extends Bloc<TermsConditionEvents, TermsConditionStates> {
  TermsCondition? termsCondition;
  TermsAndConditionsRepository termsAndConditionsRepository;

  TermsConditionBloc(this.termsAndConditionsRepository)
      : super(TermsConditionFetchNone()) {
    on<TermsConditionFetchStarted>((event, emit) async {
      emit(TermsConditionFetchProgress());
      try {
        termsCondition =
            await termsAndConditionsRepository.fetchData(event.termsType);
        emit(TermsConditionFetchComplete());
      } on ConnectionException catch (e) {
        emit(TermsConditionFetchError(
            errorMessage: e.errorMessage, isConnectionError: true));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(TermsConditionFetchError(errorMessage: e.errorMessage!));
        }
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
