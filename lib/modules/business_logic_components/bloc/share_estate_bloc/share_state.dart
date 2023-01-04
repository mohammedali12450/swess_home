abstract class ShareState {}

class ShareError extends ShareState {
  String error;

  ShareError({required this.error});
}

class ShareProgress extends ShareState {}

class ShareComplete extends ShareState {}

class ShareNone extends ShareState {}
