import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/logging_history_bloc/logging_history_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/logging_history_bloc/logging_history_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/logging_history_bloc/logging_history_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/data/repositories/logging_history_repository.dart';

class LoggingHistoryScreen extends StatefulWidget {
  const LoggingHistoryScreen({super.key});

  @override
  State<LoggingHistoryScreen> createState() => _LoggingHistoryScreenState();
}

class _LoggingHistoryScreenState extends State<LoggingHistoryScreen> {

  late LoggingHistoryBloc loggingHistoryBloc;

  @override
  void initState() {
    super.initState();
    loggingHistoryBloc = LoggingHistoryBloc(LoggingHistoryRepository());
    String? token;
    if (UserSharedPreferences.getAccessToken() != null) {
      token = UserSharedPreferences.getAccessToken();
    }
    loggingHistoryBloc.add(
      LoggingHistoryFetchStarted(token: token),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.logging_history,
        ),
      ),
      body: BlocBuilder<LoggingHistoryBloc, LoggingHistoryState>(
        bloc: loggingHistoryBloc,
          builder: (context, state) {
        if (state is LoggingHistoryFetchProgress) {
          return SpinKitWave(
            color: Theme.of(context).colorScheme.primary,
            size: 0.1.sw,
          );
        }

        if (state is LoggingHistoryFetchComplete) {
          final loggingHistoryList = state.loggingHistoryInfoList;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: loggingHistoryList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppLocalizations.of(context)!.login_time}: ${loggingHistoryList[index].loginTime}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        Text("${AppLocalizations.of(context)!.ip_address}: ${loggingHistoryList[index].ipAddress}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                        10.verticalSpace,
                        const Divider()
                      ],
                    ),
                  );
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}

