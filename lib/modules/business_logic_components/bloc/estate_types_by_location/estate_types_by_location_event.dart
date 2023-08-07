abstract class EstateTypesByLocationEvent {}

class EstateTypeFetchByLocation extends EstateTypesByLocationEvent {
  final int location_id;
  EstateTypeFetchByLocation(this.location_id);
}
class EstateTypeReset extends EstateTypesByLocationEvent {}
