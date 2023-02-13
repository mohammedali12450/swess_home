import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_estate_bloc/send_estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_estate_bloc/send_estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_estate_bloc/send_estate_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/refresh_button.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

import '../../../../core/storage/shared_preferences/user_shared_preferences.dart';

class CreatePropertyScreenFinish extends StatefulWidget {
  static const String id = "CreatePropertyScreenFinish";

  final Estate currentOffer;

  const CreatePropertyScreenFinish({Key? key, required this.currentOffer}) : super(key: key);

  @override
  _CreatePropertyScreenFinishState createState() => _CreatePropertyScreenFinishState();
}

class _CreatePropertyScreenFinishState extends State<CreatePropertyScreenFinish> {
  ChannelCubit sendProgress = ChannelCubit(0);
  late SendEstateBloc _sendEstateBloc;

  @override
  void initState() {
    super.initState();
    _sendEstateBloc = SendEstateBloc(estateRepository: EstateRepository());
    // Send Estate:
    sendEstate();
  }

  sendEstate() {
    print(UserSharedPreferences.getAccessToken());
    int applyProgress = 0;
    _sendEstateBloc.add(
      SendEstateStarted(
        estate: widget.currentOffer,
        token: UserSharedPreferences.getAccessToken()!,
        onSendProgress: (int progress) async {
          if (applyProgress % 5 == 0 || progress == 100) {
            sendProgress.setState(progress);
          }
          applyProgress++;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendEstateBloc, SendEstateState>(
      bloc: _sendEstateBloc,
      listener: (_, estateSendState)async {
        if (estateSendState is SendEstateError) {
          var error = estateSendState.isConnectionError
              ? AppLocalizations.of(context)!.no_internet_connection
              : estateSendState.errorMessage;
          await showWonderfulAlertDialog(context, AppLocalizations.of(context)!.error, error);
        }
      },
      builder: (_, estateSendState) {
        return CreatePropertyTemplate(
          headerIconPath: sendIconPath,
          headerText: AppLocalizations.of(context)!.send_estate,
          body: (estateSendState is SendEstateError)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FetchResult(content: AppLocalizations.of(context)!.error_when_sending_estate),
              40.verticalSpace,
              RefreshButton(
                onPressed: () => sendEstate(),
              )
            ],
          )
              : Column(
            children: [
              36.verticalSpace,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: sendProgress,
                builder: (_, percent) {
                  percent = percent.toDouble();
                  return CircularPercentIndicator(
                    backgroundColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.24),
                    progressColor: Theme.of(context).colorScheme.onBackground,
                    radius: 100,
                    lineWidth: 10,
                    percent: (percent / 100).toDouble(),
                    center: (estateSendState is SendEstateComplete)
                        ? Icon(
                      Icons.check,
                      size: 80.w,
                    )
                        : Text(
                      percent.toInt().toString() + "%",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w500, fontFamily: "Hind"),
                    ),
                  );
                },
              ),
              if (estateSendState is SendEstateProgress)
                Container(
                  padding: EdgeInsets.only(top: 24.h),
                  width: 1.sw,
                  child: Text(
                    AppLocalizations.of(context)!.sending_estate,
                    textAlign: TextAlign.center,
                    maxLines: 30,
                  ),
                ),
              42.verticalSpace,
              if (estateSendState is SendEstateComplete) ...[
                Text(
                  AppLocalizations.of(context)!.congratulations,
                  style: Theme.of(context).textTheme.headline4,
                ),
                24.verticalSpace,
                Text(
                  AppLocalizations.of(context)!.finish_send_estate,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8),
                ),
              ],
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(240.w, 64.h),
                ),
                child: Text(
                  (estateSendState is SendEstateComplete)
                      ? AppLocalizations.of(context)!.ok
                      : AppLocalizations.of(context)!.sending_estate,
                ),
                onPressed: () async {
                  if (estateSendState is! SendEstateComplete) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
