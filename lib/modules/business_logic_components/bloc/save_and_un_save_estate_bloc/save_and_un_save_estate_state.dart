abstract class SaveAndUnSaveEstateState {}

class EstateSaved extends SaveAndUnSaveEstateState {}

class EstateUnSaved extends SaveAndUnSaveEstateState {}

class EstateSaveAndUnSaveError extends SaveAndUnSaveEstateState {
  String error;
  final bool isConnectionError ;
  EstateSaveAndUnSaveError({required this.error , this.isConnectionError = false});
}

class EstateSaveAndUnSaveProgress extends SaveAndUnSaveEstateState {}
