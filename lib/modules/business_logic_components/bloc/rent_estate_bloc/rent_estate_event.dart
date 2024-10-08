import '../../../data/models/rent_estate.dart';

abstract class RentEstatesEvent {}

class SendRentEstatesFetchStarted extends RentEstatesEvent {
  String token;
  RentEstateRequest rentEstate;

  SendRentEstatesFetchStarted({required this.token, required this.rentEstate});
}

class GetRentEstatesFetchStarted extends RentEstatesEvent {
  RentEstateFilter rentEstateFilter;

  GetRentEstatesFetchStarted({required this.rentEstateFilter});
}

class GetMyRentEstatesFetchStarted extends RentEstatesEvent {
  String token;

  GetMyRentEstatesFetchStarted({required this.token});
}

class DeleteMyRentEstatesFetchStarted extends RentEstatesEvent {
  String token;

  DeleteMyRentEstatesFetchStarted({required this.token});
}

class FilterRentEstatesFetchStarted extends RentEstatesEvent {
  RentEstateFilter rentEstateFilter;

  FilterRentEstatesFetchStarted({required this.rentEstateFilter});
}
