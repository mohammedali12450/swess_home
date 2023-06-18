
abstract class LoggingHistoryEvent {}

class LoggingHistoryFetchStarted extends LoggingHistoryEvent {
  String? token;
  LoggingHistoryFetchStarted({this.token});
}
