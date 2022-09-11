
abstract class DeleteEstatesState {}

class DeleteEstatesFetchProgress extends DeleteEstatesState {}

class DeleteEstatesFetchError extends DeleteEstatesState {
  String error;
  final bool isConnectionError ;
  DeleteEstatesFetchError({required this.error , this.isConnectionError = false });
}

class DeleteEstatesFetchComplete extends DeleteEstatesState {

  DeleteEstatesFetchComplete();
}

class DeleteEstatesFetchNone extends DeleteEstatesState {}
