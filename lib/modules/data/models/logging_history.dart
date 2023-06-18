
class LoggingHistory {
  List<LoggingHistoryInfo>? loggingHistoryList;
  String? message;
  int? status;

  LoggingHistory({
     this.loggingHistoryList,
     this.message,
     this.status,
  });

  factory LoggingHistory.fromJson(Map<String, dynamic> json) {
    List<LoggingHistoryInfo> loggingHistoryList = [];
    dynamic jsonImages = json["logging_history"]["data"];
    if (jsonImages is List) {
      loggingHistoryList = jsonImages.map((e) => LoggingHistoryInfo.fromJson(e)).toList();
    } else if (jsonImages is Map) {
      loggingHistoryList = jsonImages.values.map((e) => LoggingHistoryInfo.fromJson(e)).toList();
    }
    return LoggingHistory(
        loggingHistoryList: loggingHistoryList,
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> map = {};
    map["message"] = message;
    map["status"] = status;
    return map;
  }
}

class LoggingHistoryInfo {
  int? id;
  int? customerId;
  String? loginTime;
  String? ipAddress;
  // DateTime? createdAt;
  // DateTime? updatedAt;

  LoggingHistoryInfo({
     this.id,
     this.customerId,
     this.loginTime,
     this.ipAddress,
     // this.createdAt,
     // this.updatedAt,
  });

  factory LoggingHistoryInfo.fromJson(Map<String, dynamic> json) {
    return LoggingHistoryInfo(
      id: json["id"] == null ? null : json["id"],
      customerId: json["customer_id"] == null ? null : json["customer_id"],
      loginTime: json["login_time"] == null ? null : json["login_time"],
      ipAddress: json["ip_address"] == null ? null : json["ip_address"],
      // createdAt: DateTime.parse(json["created_at"]),
      // updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "login_time": loginTime,
    "ip_address": ipAddress,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
  };
}
