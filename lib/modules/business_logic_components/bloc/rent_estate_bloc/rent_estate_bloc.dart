import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rent_estate_bloc/rent_estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rent_estate_bloc/rent_estate_state.dart';

import '../../../data/models/rent_estate.dart';
import '../../../data/repositories/rent_estate_repository.dart';

class RentEstateBloc extends Bloc<RentEstatesEvent, RentEstateState> {
  final RentEstateRepository _messageRepository;

  bool? rentEstate;
  List<RentEstate>? rentEstates;

  RentEstateBloc(this._messageRepository) : super(RentEstateFetchNone()) {
    on<SendRentEstatesFetchStarted>((event, emit) async {
      emit(SendRentEstateFetchProgress());
      try {
        rentEstate =
            await _messageRepository.sendRentEstate(event.token, event.rentEstate);
        emit(SendRentEstateFetchComplete());
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(RentEstateFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
    on<GetRentEstatesFetchStarted>((event, emit) async {
      emit(GetRentEstateFetchProgress());
      try {
        rentEstates = await _messageRepository.getRentEstates();
        emit(GetRentEstateFetchComplete(rentEstates: rentEstates!));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(RentEstateFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
  }
}
