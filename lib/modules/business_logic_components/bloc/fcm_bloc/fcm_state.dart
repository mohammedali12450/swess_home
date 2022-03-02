// State :

abstract class FcmState {}

class SendFcmTokenProcessNone extends FcmState {}

class SendFcmTokenProcessError extends FcmState {}

class SendFcmTokenProcessProgress extends FcmState {}

class SendFcmTokenProcessComplete extends FcmState {}
