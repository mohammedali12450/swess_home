import 'package:swesshome/modules/data/models/message.dart';

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
