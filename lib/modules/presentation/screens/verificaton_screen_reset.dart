import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phone_number/phone_number.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/storage/shared_preferences/otp_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_code_bloc/resend_code_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_code_bloc/resend_code_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_code_bloc/resend_code_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/verification_bloc/verifiaction_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/verification_bloc/verification_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/verification_bloc/verification_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/otp_model.dart';
import 'package:swesshome/modules/presentation/screens/reset_password_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';

class VerificationCodeScreenReset extends StatefulWidget {
  static const String id = 'VerificationCodeScreenReset';
  final String phoneNumber;

  const VerificationCodeScreenReset({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _VerificationCodeScreenResetState createState() =>
      _VerificationCodeScreenResetState();
}

class _VerificationCodeScreenResetState
    extends State<VerificationCodeScreenReset> {
  // Blocs and cubits :
  final ChannelCubit officePhoneError = ChannelCubit(null);
  final ChannelCubit officePhoneErrorLogin = ChannelCubit(null);
  final ChannelCubit systemPasswordError = ChannelCubit(null);
  final ChannelCubit officeTelephoneError = ChannelCubit(null);
  late VerificationCodeBloc verificationCodeBloc;
  late ResendVerificationCodeBloc resendVerificationCodeBloc;

  // Controllers:
  TextEditingController verificationCodeController = TextEditingController();

  // Other:
  late String phoneDialCode;
  PhoneNumber? phoneNumber;
  ScrollController scrollController = ScrollController();
  final _waitingTime = BehaviorSubject<int>.seeded(0);
  Timer timer = Timer(Duration.zero, () {});

  get waitingTimeValue => _waitingTime.value;

  setWaitingTime(int currentDuration) {
    _waitingTime.sink.add(currentDuration);
  }

  startWaitingTimer(initValue) {
    dataStore.setLastOtpRequestValue(
      OtpRequestValueModel(
          requestedTime: DateTime.now(),
          textValue: dataStore.user.data!.authentication),
    );
    setWaitingTime(initValue);
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (waitingTimeValue == 0) {
        timer.cancel();
      } else {
        setWaitingTime(waitingTimeValue - 1);
      }
    });
  }

  initWaitingTime() {
    dataStore.getLastOtpRequestValue().then((value) {
      if (value.textValue != dataStore.user.data!.authentication ||
          value.requestedTime!
              .isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
        setWaitingTime(0);
      } else {
        startWaitingTimer(
            59 - (DateTime.now().difference(value.requestedTime!)).inSeconds);
      }
    });
  }

  @override
  void initState() {
    verificationCodeBloc = BlocProvider.of<VerificationCodeBloc>(context);
    resendVerificationCodeBloc =
        BlocProvider.of<ResendVerificationCodeBloc>(context);
    //TODO: edit is out of syria
    // Dial code initializing:
    if (BlocProvider.of<SystemVariablesBloc>(context)
        .systemVariables!
        .isForStore) {
      phoneDialCode = "+961";
    } else {
      phoneDialCode = "+963";
    }
    initWaitingTime();
    super.initState();
  }

  void loginErrorHandling(errorResponseMap) {
    if (errorResponseMap.containsKey("user")) {
      officePhoneErrorLogin.setState(errorResponseMap["user"].first);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TextDirection textDirection = Directionality.of(context);
    // bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<VerificationCodeBloc, VerificationCodeState>(
          listener: (_, verifyState) {
            if (verifyState is VerificationCodeError) {
              if (verifyState.isConnectionError) {
                showWonderfulAlertDialog(
                  context,
                  AppLocalizations.of(context)!.error,
                  AppLocalizations.of(context)!.no_internet_connection,
                );
                return;
              }

              if (verifyState.errorResponse != null) {
                loginErrorHandling(verifyState.errorResponse);
              } else if (verifyState.errorMessage != null) {
                showWonderfulAlertDialog(
                  context,
                  AppLocalizations.of(context)!.error,
                  AppLocalizations.of(context)!.localeName == "en"
                      ? verifyState.errorMessage!
                      : "الكود خطأ",
                  defaultButtonContent: AppLocalizations.of(context)!.ok,
                );
              }
            }
            if (verifyState is VerificationCodeComplete) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ResetPasswordScreen(
                          phoneNumber: widget.phoneNumber)));
            }
          },
        ),
        if (waitingTimeValue == 0 || waitingTimeValue == 59)
          BlocListener<ResendVerificationCodeBloc, ResendVerificationCodeState>(
            listener: (_, resendVerifyState) {
              if (resendVerifyState is ResendVerificationCodeError) {
                if (resendVerifyState.isConnectionError) {
                  showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.no_internet_connection,
                  );
                  return;
                }

                if (resendVerifyState.errorResponse != null) {
                  loginErrorHandling(resendVerifyState.errorResponse);
                } else if (resendVerifyState.errorMessage != null) {
                  showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.localeName == "en"
                        ? resendVerifyState.errorMessage!
                        : "الكود خطأ",
                    defaultButtonContent: AppLocalizations.of(context)!.ok,
                  );
                }
              }
              if (resendVerifyState is ResendVerificationCodeComplete) {
                print("doneeeeeeesadasdsad");
              }
            },
          ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          color: Theme.of(context).colorScheme.secondary,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              ...kBackgroundDrawings(context),
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    56.verticalSpace,
                    SizedBox(
                      width: 200.w,
                      height: 200.w,
                      child: CircleAvatar(
                        child: Image.asset(swessHomeIconPath),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                      ),
                    ),
                    32.verticalSpace,
                    buildSignInScreen()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildSignInScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.enter_your_code,
        ),
        8.verticalSpace,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: officePhoneErrorLogin,
          builder: (_, errorMessage) {
            return TextField(
              textDirection: TextDirection.ltr,
              onChanged: (_) {
                officePhoneErrorLogin.setState(null);
              },
              cursorColor: Theme.of(context).colorScheme.onBackground,
              controller: verificationCodeController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                errorText: errorMessage,
              ),
            );
          },
        ),
        56.verticalSpace,
        Center(
          child: InkWell(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(180.w, 60.h),
              ),
              onPressed: () async {
                verificationCodeBloc.add(
                  VerificationCodeStarted(
                      mobile: widget.phoneNumber,
                      verificationCode: verificationCodeController.text),
                );
                FocusScope.of(context).unfocus();
              },
              child: BlocBuilder<VerificationCodeBloc, VerificationCodeState>(
                builder: (_, verifyState) {
                  if (verifyState is VerificationCodeProgress) {
                    return IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.checking,
                          ),
                          12.horizontalSpace,
                          SpinKitWave(
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20.w,
                          ),
                        ],
                      ),
                    );
                  }
                  return Text(
                    AppLocalizations.of(context)!.next,
                  );
                },
              ),
            ),
          ),
        ),
        62.verticalSpace,
        Center(
            child: Text(
          AppLocalizations.of(context)!.did_code,
          style: Theme.of(context).textTheme.bodyText2,
        )),
        6.verticalSpace,
        StreamBuilder<int>(
            stream: _waitingTime.stream,
            builder: (context, snapshot) {
              if (waitingTimeValue > 0) {
                return _timerCountDown();
              } else {
                return InkWell(
                  onTap: () {
                    resendVerificationCodeBloc.add(
                      ResendVerificationCodeStarted(
                          mobile: widget.phoneNumber,
                          verificationCode: verificationCodeController.text),
                    );
                    startWaitingTimer(59);
                    FocusScope.of(context).unfocus();
                  },
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.resend_code,
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }

  getButtonsBorderRadius(bool isLeft) {
    Radius radius = const Radius.circular(12);
    Radius zeroRadius = Radius.zero;
    return BorderRadius.only(
      bottomRight: (isLeft) ? zeroRadius : radius,
      topRight: (isLeft) ? zeroRadius : radius,
      topLeft: (isLeft) ? radius : zeroRadius,
      bottomLeft: (isLeft) ? radius : zeroRadius,
    );
  }

  Widget _timerCountDown() {
    return StreamBuilder<int>(
        initialData: 0,
        stream: _waitingTime.stream,
        builder: (context, waitingTimeSnapshot) {
          if (waitingTimeSnapshot.data != 0) {
            return Center(
              child: Text(
                '00:${waitingTimeSnapshot.data}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else {
            return Container();
          }
        });
  }

// Future<bool>? _onWillPop() {
//   int x = 59;
//   if (waitingTimeValue != 0) {
//     dataStore.setLastOtpRequestValue(
//       OtpRequestValueModel(
//           requestedTime: DateTime.now().subtract(
//               Duration(seconds: (x - waitingTimeValue))),
//           textValue: dataStore.user.data!.authentication),
//     );
//   }
//   return null;
// }
}
