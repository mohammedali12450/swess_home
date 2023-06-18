import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/logging_history.dart';
import 'package:swesshome/modules/data/providers/logging_history_provider.dart';

class LoggingHistoryRepository {
  final LoggingHistoryProvider _loggingHistoryProvider = LoggingHistoryProvider();

  Future<List<LoggingHistoryInfo>> getLoggingHistory(String token) async {
    Response response = await _loggingHistoryProvider.getLoggingHistory(token);
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    var jsonHistory = jsonDecode(response.toString())["data"] as List;
    List<LoggingHistoryInfo> histories = jsonHistory.map((e) => LoggingHistoryInfo.fromJson(e)).toList();
    return histories;
  }
}