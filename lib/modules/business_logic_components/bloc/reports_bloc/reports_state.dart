abstract class ReportState {}

class ReportFetchComplete extends ReportState {}

class ReportFetchNone extends ReportState {}

class ReportFetchProgress extends ReportState {}

class ReportFetchError extends ReportState {
  String error;

  ReportFetchError({required this.error});
}
