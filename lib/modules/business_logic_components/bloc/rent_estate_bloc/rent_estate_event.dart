import '../../../data/models/rent_estate.dart';

abstract class RentEstatesEvent {}

class SendRentEstatesFetchStarted extends RentEstatesEvent {
  String? token;
  RentEstateRequest rentEstate;

  SendRentEstatesFetchStarted({this.token, required this.rentEstate});
}

class GetRentEstatesFetchStarted extends RentEstatesEvent {
  RentEstateFilter rentEstateFilter;

  GetRentEstatesFetchStarted({required this.rentEstateFilter});
}
