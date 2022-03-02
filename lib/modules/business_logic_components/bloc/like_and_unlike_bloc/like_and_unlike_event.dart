import 'package:swesshome/constants/enums.dart';

abstract class LikeAndUnlikeEvent {}

class LikeStarted extends LikeAndUnlikeEvent {
  String? token;

  LikeType likeType;

  int likedObjectId;

  LikeStarted({required this.token, required this.likedObjectId, required this.likeType});
}

class UnlikeStarted extends LikeAndUnlikeEvent {
  String? token;
  LikeType likeType;

  int unlikedObjectId;

  UnlikeStarted({required this.token, required this.unlikedObjectId, required this.likeType});
}

class ReInitializeLikeState extends LikeAndUnlikeEvent {
  final bool isLike;

  ReInitializeLikeState({required this.isLike});
}
