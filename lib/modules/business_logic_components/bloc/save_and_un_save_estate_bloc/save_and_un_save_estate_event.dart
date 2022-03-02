abstract class SaveAndUnSaveEstateEvent {}

class EstateSaveStarted extends SaveAndUnSaveEstateEvent {
  String? token;

  int estateId;

  EstateSaveStarted({required this.token, required this.estateId});
}

class UnSaveEventStarted extends SaveAndUnSaveEstateEvent {
  String? token;

  int estateId;

  UnSaveEventStarted({required this.token, required this.estateId});
}

class ReInitializeSaveState extends SaveAndUnSaveEstateEvent {
  final bool isSaved;

  ReInitializeSaveState({required this.isSaved});
}
