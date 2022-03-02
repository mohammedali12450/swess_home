abstract class LikeAndUnlikeState {}

class Liked extends LikeAndUnlikeState {}

class Unliked extends LikeAndUnlikeState {}

class LikeAndUnlikeError extends LikeAndUnlikeState {
  String error;

  LikeAndUnlikeError({required this.error});
}

class LikeAndUnlikeProgress extends LikeAndUnlikeState {}
