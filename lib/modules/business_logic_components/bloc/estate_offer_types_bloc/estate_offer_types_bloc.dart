import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/models/estate_offer_type.dart';
import 'package:swesshome/modules/data/repositories/estate_offer_types_repository.dart';

import 'estate_offer_types_event.dart';
import 'estate_offer_types_state.dart';

class EstateOfferTypesBloc
    extends Bloc<EstateOfferTypesEvent, EstateOfferTypesState> {
  EstateOfferTypesRepository estateOfferTypesRepository;
  List<EstateOfferType>? estateOfferTypes;

  EstateOfferTypesBloc(this.estateOfferTypesRepository)
      : super(EstateOfferTypesFetchNone()) {
    on<EstateOfferTypesFetchStarted>((event, emit) async {
      emit(EstateOfferTypesFetchProgress());
      try {
        estateOfferTypes = await estateOfferTypesRepository.fetchData();
        emit(EstateOfferTypesFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
