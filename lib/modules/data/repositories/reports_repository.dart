import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/report.dart';
import 'package:swesshome/modules/data/providers/reports_provider.dart';

class ReportsRepository {
  final ReportProviders _reportProviders = ReportProviders();

  Future<List<Report>> getReports() async {
    Response response = await _reportProviders.getReports();
    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث خطأ أثناء الاتصال بالسيرفر");
    }
    var jsonReports = jsonDecode(response.toString())["data"] as List;
    List<Report> reports = jsonReports.map((e) => Report.fromJson(e)).toList();
    return reports;
  }

  Future<bool> sendReport(String? token, reportId, estateId) async {
    Response response = await _reportProviders.sendReport(token, reportId, estateId);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }
}
