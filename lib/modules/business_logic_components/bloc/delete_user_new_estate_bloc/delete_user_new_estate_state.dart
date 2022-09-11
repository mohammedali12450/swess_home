
abstract class DeleteUserNewEstateState {}

class DeleteUserNewEstateFetchProgress extends DeleteUserNewEstateState {}

class DeleteUserNewEstateFetchError extends DeleteUserNewEstateState {
  String error;
  final bool isConnectionError ;
  DeleteUserNewEstateFetchError({required this.error , this.isConnectionError = false });
}

class DeleteUserNewEstateFetchComplete extends DeleteUserNewEstateState {

  DeleteUserNewEstateFetchComplete();
}

class DeleteUserNewEstateFetchNone extends DeleteUserNewEstateState {}
