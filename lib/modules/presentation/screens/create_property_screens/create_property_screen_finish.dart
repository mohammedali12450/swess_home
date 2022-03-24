import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_estate_bloc/send_estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_estate_bloc/send_estate_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_estate_bloc/send_estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
    int applyProgress = 0;
    _sendEstateBloc.add(
      SendEstateStarted(
        estate: widget.currentOffer,
        token: BlocProvider.of<UserLoginBloc>(context).user!.token!,
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
      listener: (_, estateSendState) {
        if (estateSendState is SendEstateError) {
          showWonderfulAlertDialog(context, "خطأ", estateSendState.errorMessage);
        }
      },
      builder: (_, estateSendState) {
        return CreatePropertyTemplate(
          headerIconPath: sendIconPath,
          headerText: "إرسال العرض العقاري",
          body: (estateSendState is SendEstateError)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FetchResult(content: "حدث خطأ أثناء إرسال العقار"),
                    SizedBox(height: Res.height(72),),
                    buildRefreshButton(),
                  ],
                )
              : Column(
                  children: [
                    kHe36,
                    BlocBuilder<ChannelCubit, dynamic>(
                      bloc: sendProgress,
                      builder: (_, percent) {
                        percent = percent.toDouble();
                        return CircularPercentIndicator(
                          radius: 100,
                          lineWidth: 10,
                          percent: (percent / 100).toDouble(),
                          center: (estateSendState is SendEstateComplete)
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.secondaryColor,
                                  size: 80,
                                )
                              : ResText(
                                  percent.toInt().toString() + "%",
                                  textStyle: textStyling(S.s24, W.w6, C.c2, fontFamily: F.roboto),
                                ),
                          progressColor: AppColors.secondaryColor,
                        );
                      },
                    ),
                    SizedBox(
                      height: Res.height(56),
                    ),
                    if (estateSendState is SendEstateComplete) ...[
                      ResText(
                        "مبروك",
                        textStyle: textStyling(S.s30, W.w6, C.bl),
                      ),
                      kHe24,
                      ResText(
                        finishCreatePropertyContent,
                        textStyle: textStyling(S.s18, W.w6, C.bl).copyWith(height: 1.9),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const Spacer(),
                    MyButton(
                      child: ResText(
                        (estateSendState is SendEstateComplete) ? "تم" : "جاري إرسال العقار",
                        textStyle: textStyling(S.s16, W.w5, C.wh),
                      ),
                      width: Res.width(240),
                      height: Res.height(56),
                      color: AppColors.secondaryColor,
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

  buildRefreshButton() {
    return MyButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.refresh_outlined,
            size: 18,
            color: AppColors.white,
          ),
          kWi12,
          ResText(
            "إعادة المحاولة",
            textStyle: textStyling(S.s18, W.w5, C.wh).copyWith(height: 1.8),
          ),
        ],
      ),
      onPressed: () {
        sendEstate();
      },
      width: Res.width(250),
      color: AppColors.secondaryColor,
    );
  }
}
