import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/logging_history_bloc/logging_history_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/logging_history_bloc/logging_history_state.dart';
import 'package:swesshome/modules/data/models/logging_history.dart';
import 'package:swesshome/modules/data/repositories/logging_history_repository.dart';

class LoggingHistoryBloc extends Bloc<LoggingHistoryEvent,LoggingHistoryState> {
  LoggingHistoryRepository loggingHistoryRepository;

  List<LoggingHistoryInfo>? loggingHistoryInfoList;

  LoggingHistoryBloc(this.loggingHistoryRepository) : super(LoggingHistoryFetchNone()) {
    on<LoggingHistoryFetchStarted>((event, emit) async {
        emit(LoggingHistoryFetchProgress());
        try {
          loggingHistoryInfoList = await loggingHistoryRepository.getLoggingHistory(event.token!);
          emit(LoggingHistoryFetchComplete(loggingHistoryInfoList: loggingHistoryInfoList!));
        } on ConnectionException catch (e) {
          emit(
            LoggingHistoryFetchError(
                errorMessage: e.errorMessage, isConnectionError: true),
          );
        } on GeneralException catch (e) {
          emit(
            LoggingHistoryFetchError(errorMessage: e.errorMessage!),
          );
        }
      },
    );
  }
}