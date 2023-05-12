import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class ReviewEvent {
  const ReviewEvent();
}

@immutable
class ReviewPostEvent extends ReviewEvent {
  final String token;
  final double rate;
  final String notes;

  const ReviewPostEvent({
    required this.token,
    required this.rate,
    required this.notes,
  });
}
