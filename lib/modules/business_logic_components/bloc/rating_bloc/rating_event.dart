abstract class RatingEvent {}

class RatingStarted extends RatingEvent {
  String? token;

  String rate;

  String? notes;

  RatingStarted({required this.token, required this.rate, this.notes});
}
