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
  int page = 1;
  int filterPage = 1;
  bool isFetching = false;
  bool isFilter = false;

  RentEstateBloc(this._messageRepository) : super(RentEstateFetchNone()) {
    on<SendRentEstatesFetchStarted>((event, emit) async {
      emit(SendRentEstateFetchProgress());
      try {
        rentEstate = await _messageRepository.sendRentEstate(
            event.token, event.rentEstate);
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
        rentEstates = await _messageRepository.getRentEstates(
            event.rentEstateFilter, page);
        emit(GetRentEstateFetchComplete(rentEstates: rentEstates!));
        page++;
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(RentEstateFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
    on<FilterRentEstatesFetchStarted>((event, emit) async {
      emit(FilterRentEstateFetchProgress());
      try {
        rentEstates = await _messageRepository.getRentEstates(
            event.rentEstateFilter, filterPage);
        emit(FilterRentEstateFetchComplete(rentEstates: rentEstates!));
        filterPage++;
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(RentEstateFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
    on<GetMyRentEstatesFetchStarted>((event, emit) async {
      emit(GetMyRentEstateFetchProgress());
      try {
        rentEstates = await _messageRepository.getMyRentEstates(event.token);
        emit(GetMyRentEstateFetchComplete(rentEstates: rentEstates!));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(RentEstateFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
    on<DeleteMyRentEstatesFetchStarted>((event, emit) async {
      emit(DeleteMyRentEstateFetchProgress());
      try {
        await _messageRepository.deleteMyRentEstates(event.token);
        emit(DeleteMyRentEstateFetchComplete());
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
