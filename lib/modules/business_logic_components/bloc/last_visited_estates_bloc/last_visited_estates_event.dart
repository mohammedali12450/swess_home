abstract class LastVisitedEstatesEvent {}

class LastVisitedEstatesFetchStarted extends LastVisitedEstatesEvent {
  String token;

  LastVisitedEstatesFetchStarted({required this.token});
}
