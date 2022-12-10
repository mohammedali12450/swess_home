import '../../../data/models/estate_offer_type.dart';

abstract class EstateOfferTypesState{}

class EstateOfferTypesFetchComplete extends EstateOfferTypesState{
  List<EstateOfferType>? estateOfferTypes;

  EstateOfferTypesFetchComplete(this.estateOfferTypes);
}
class EstateOfferTypesFetchError extends EstateOfferTypesState{}
class EstateOfferTypesFetchProgress extends EstateOfferTypesState{}
class EstateOfferTypesFetchNone extends EstateOfferTypesState{}