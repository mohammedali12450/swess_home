abstract class RatingState {}

class RatingError extends RatingState {
  String error;
  final bool isConnectionError ;
  RatingError({required this.error , this.isConnectionError = false});
}

class RatingProgress extends RatingState {}

class RatingComplete extends RatingState {}

class RatingNone extends RatingState {}
