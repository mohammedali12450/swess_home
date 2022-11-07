abstract class IsUpdateAppState {}

class IsUpdateAppError extends IsUpdateAppState {
  String error;
  final bool isConnectionError ;
  IsUpdateAppError({required this.error , this.isConnectionError = false});
}

class IsUpdateAppProgress extends IsUpdateAppState {}

class IsUpdateAppComplete extends IsUpdateAppState {}

class IsUpdateAppNone extends IsUpdateAppState {}
