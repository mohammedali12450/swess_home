abstract class LikeAndUnlikeState {}

class Liked extends LikeAndUnlikeState {}

class Unliked extends LikeAndUnlikeState {}

class LikeAndUnlikeError extends LikeAndUnlikeState {
  String error;
  final bool isConnectionError ;
  LikeAndUnlikeError({required this.error , this.isConnectionError = false });
}

class LikeAndUnlikeProgress extends LikeAndUnlikeState {}
