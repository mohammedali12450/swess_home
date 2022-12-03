import 'package:dio/dio.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/utils/services/network_helper.dart';

class ReportProviders {
  Future getReports() async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.get(getReportsTypesURL);
    return response;
  }

  Future sendReport(String? token, int reportId, int estateId, String? note) async {
    NetworkHelper helper = NetworkHelper();
    Response response = await helper.post(sendReportURL,
        {"report_type_id": reportId, "estate_id": estateId, "note": note},
        token: token);
    return response;
  }
}
