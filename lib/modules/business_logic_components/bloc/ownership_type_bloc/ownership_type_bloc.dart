import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_state.dart';
import 'package:swesshome/modules/data/models/ownership_type.dart';
import 'package:swesshome/modules/data/repositories/ownership_type_repository.dart';

class OwnershipTypeBloc extends Bloc<OwnershipTypeEvent, OwnershipTypeState> {
  OwnershipTypeRepository ownershipTypeRepository;

  List<OwnershipType>? ownershipTypes;

  OwnershipTypeBloc(this.ownershipTypeRepository)
      : super(OwnershipTypeFetchNone()) {
    on<OwnershipTypeFetchStarted>((event, emit) async {
      emit(OwnershipTypeFetchProgress());
      try {
        ownershipTypes = await ownershipTypeRepository.fetchData();
        emit(OwnershipTypeFetchComplete());
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }
}
