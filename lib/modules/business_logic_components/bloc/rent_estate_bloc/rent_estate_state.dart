
import '../../../data/models/rent_estate.dart';

abstract class RentEstateState {}

class SendRentEstateFetchComplete extends RentEstateState {}

class RentEstateFetchNone extends RentEstateState {}

class SendRentEstateFetchProgress extends RentEstateState {}

class RentEstateFetchError extends RentEstateState {
  String error;

  RentEstateFetchError({required this.error});
}

class GetRentEstateFetchComplete extends RentEstateState {
  List<RentEstate> rentEstates;

  GetRentEstateFetchComplete({required this.rentEstates});
}

class GetRentEstateFetchProgress extends RentEstateState {}

class FilterRentEstateFetchComplete extends RentEstateState {
  List<RentEstate> rentEstates;

  FilterRentEstateFetchComplete({required this.rentEstates});
}

class FilterRentEstateFetchProgress extends RentEstateState {}

class GetMyRentEstateFetchComplete extends RentEstateState {
  List<RentEstate> rentEstates;

  GetMyRentEstateFetchComplete({required this.rentEstates});
}

class GetMyRentEstateFetchProgress extends RentEstateState {}

class DeleteMyRentEstateFetchProgress extends RentEstateState {}

class DeleteMyRentEstateFetchComplete extends RentEstateState {

  DeleteMyRentEstateFetchComplete();
}