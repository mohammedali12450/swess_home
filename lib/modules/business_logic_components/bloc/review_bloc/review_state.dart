import 'package:flutter/foundation.dart' show immutable;
import 'package:swesshome/modules/data/models/review.dart';

@immutable
abstract class ReviewState {
  const ReviewState();
}

@immutable
class ReviewInit extends ReviewState {
  const ReviewInit();
}

@immutable
class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

@immutable
class ReivewError extends ReviewState {
  final String message;
  final Object? data;

  const ReivewError({
    required this.message,
    this.data,
  });
}

@immutable
class ReviewData extends ReviewState {
  final Review review;

  const ReviewData({
    required this.review,
  });
}
