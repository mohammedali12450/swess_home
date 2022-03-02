import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_state.dart';
import 'package:swesshome/modules/data/models/report.dart';
import 'package:swesshome/modules/data/repositories/reports_repository.dart';

class ReportBloc extends Bloc<ReportsEvent, ReportState> {
  ReportsRepository reportsRepository;

  List<Report>? reports;

  ReportBloc(this.reportsRepository) : super(ReportFetchNone()) {
    on<ReportsFetchStarted>((event, emit) async {
      emit(ReportFetchProgress());
      try {
        reports = await reportsRepository.getReports();
        emit(ReportFetchComplete());
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(ReportFetchError(error: e.errorMessage));
        }
        print(e);
        print(stack);
      }
    });
  }
}
