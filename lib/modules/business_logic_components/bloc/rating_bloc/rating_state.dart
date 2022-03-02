abstract class RatingState {}

class RatingError extends RatingState {
  String error;

  RatingError({required this.error});
}

class RatingProgress extends RatingState {}

class RatingComplete extends RatingState {}

class RatingNone extends RatingState {}
