abstract class SaveAndUnSaveEstateState {}

class EstateSaved extends SaveAndUnSaveEstateState {}

class EstateUnSaved extends SaveAndUnSaveEstateState {}

class EstateSaveAndUnSaveError extends SaveAndUnSaveEstateState {
  String error;

  EstateSaveAndUnSaveError({required this.error});
}

class EstateSaveAndUnSaveProgress extends SaveAndUnSaveEstateState {}
