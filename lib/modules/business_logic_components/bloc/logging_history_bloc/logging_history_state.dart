import 'package:swesshome/modules/data/models/logging_history.dart';

abstract class LoggingHistoryState {}

class LoggingHistoryFetchError extends LoggingHistoryState {
  String errorMessage;
  final bool isConnectionError ;
  LoggingHistoryFetchError({required this.errorMessage , this.isConnectionError = false});
}

class LoggingHistoryFetchComplete extends LoggingHistoryState {
  List<LoggingHistoryInfo> loggingHistoryInfoList;
  LoggingHistoryFetchComplete({required this.loggingHistoryInfoList});
}

class LoggingHistoryFetchProgress extends LoggingHistoryState {}


class LoggingHistoryFetchNone extends LoggingHistoryState {}
