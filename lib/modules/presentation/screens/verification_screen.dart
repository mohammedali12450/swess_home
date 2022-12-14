import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/storage/shared_preferences/otp_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_code_bloc/resend_code_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_code_bloc/resend_code_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_verification_code_bloc/send_verification_code_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_verification_code_bloc/send_verification_code_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/otp_model.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';

import 'navigation_bar_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final User? user;

  const VerificationCodeScreen({Key? key, required this.phoneNumber, this.user})
      : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  late String phoneNumber;
  ChannelCubit isVerificationButtonActiveCubit = ChannelCubit(false);
  ChannelCubit isFireBaseLoadingCubit = ChannelCubit(true);
  String? verificationId;

  firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;

  TextEditingController confirmationCodeController = TextEditingController();

  final _waitingTime = BehaviorSubject<int>.seeded(0);
  late ResendVerificationCodeBloc resendVerificationCodeBloc;
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
    // TODO: implement initState
    super.initState();
    resendVerificationCodeBloc =
        BlocProvider.of<ResendVerificationCodeBloc>(context);
    phoneNumber = widget.phoneNumber;
    if (BlocProvider.of<SystemVariablesBloc>(context)
        .systemVariables!
        .isForStore) {
    } else {
      isFireBaseLoadingCubit.setState(false);
    }
    initWaitingTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      padding: kLargeSymWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              ...kBackgroundDrawings(context),
              Center(
                child: BlocBuilder<ChannelCubit, dynamic>(
                  bloc: isFireBaseLoadingCubit,
                  builder: (context, isLoading) {
                    return (isLoading)
                        ? SpinKitWave(
                            color: Theme.of(context).colorScheme.primary,
                            size: 0.2.sw,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 300.w,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .confirmation_code_sent,
                                  maxLines: 5,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                widget.phoneNumber,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr,
                              ),
                              kHe40,
                              TextField(
                                controller: confirmationCodeController,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline3,
                                onChanged: (text) {
                                  if (NumbersHelper.isNumeric(text) &&
                                      text.length == 6) {
                                    isVerificationButtonActiveCubit
                                        .setState(true);
                                  } else {
                                    isVerificationButtonActiveCubit
                                        .setState(false);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 64.h,
                              ),
                              BlocProvider(
                                create: (context) => SendVerificationCodeBloc(),
                                child: BlocConsumer<SendVerificationCodeBloc,
                                    SendVerificationCodeState>(
                                  listener: (context, sendCodeState) async {
                                    if (sendCodeState
                                        is SendVerificationCodeComplete) {
                                      if (UserSharedPreferences
                                              .getAccessToken() !=
                                          null) {
                                        // save user token in shared preferences :
                                        UserSharedPreferences.setAccessToken(
                                            UserSharedPreferences
                                                .getAccessToken()!);
                                        // Send user fcm token to server :
                                        BlocProvider.of<FcmBloc>(context).add(
                                          SendFcmTokenProcessStarted(
                                              userToken: UserSharedPreferences
                                                  .getAccessToken()!),
                                        );
                                        BlocProvider.of<UserLoginBloc>(context)
                                            .user = sendCodeState.user;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const NavigationBarScreen(),
                                          ),
                                        );
                                      }
                                    }
                                    if (sendCodeState
                                        is SendVerificationCodeError) {
                                      if (sendCodeState.isConnectionError!) {
                                        showWonderfulAlertDialog(
                                          context,
                                          AppLocalizations.of(context)!.error,
                                          AppLocalizations.of(context)!
                                              .no_internet_connection,
                                        );
                                        return;
                                      }
                                      await showWonderfulAlertDialog(
                                          context,
                                          AppLocalizations.of(context)!.error,
                                          sendCodeState.errorMessage!);
                                    }
                                  },
                                  builder: (context, sendCodeState) {
                                    return BlocBuilder<ChannelCubit, dynamic>(
                                      bloc: isVerificationButtonActiveCubit,
                                      builder: (context, isActive) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(220.w, 64.h),
                                          ),
                                          child: (sendCodeState
                                                  is! SendVerificationCodeProgress)
                                              ? Text(
                                                  AppLocalizations.of(context)!
                                                      .send,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                          color: isActive
                                                              ? AppColors.white
                                                              : AppColors.white
                                                                  .withOpacity(
                                                                      0.64)),
                                                )
                                              : SpinKitWave(
                                                  size: 24.w,
                                                  color: Colors.white,
                                                ),
                                          onPressed: () async {
                                            if (!isActive) return;
                                            if (sendCodeState
                                                is SendVerificationCodeProgress) {
                                              return;
                                            }
                                            // Syria state :
                                            if (!BlocProvider.of<
                                                        SystemVariablesBloc>(
                                                    context)
                                                .systemVariables!
                                                .isForStore) {
                                              BlocProvider.of<
                                                          SendVerificationCodeBloc>(
                                                      context)
                                                  .add(
                                                VerificationCodeSendingStarted(
                                                    phone: widget.phoneNumber,
                                                    code:
                                                        confirmationCodeController
                                                            .text),
                                              );
                                            } else {
                                              // Firebase state :
                                              if (isActive &&
                                                  verificationId != null) {
                                                // Create a PhoneAuthCredential with the code
                                                firebase_auth
                                                        .PhoneAuthCredential
                                                    credential = firebase_auth
                                                            .PhoneAuthProvider
                                                        .credential(
                                                            verificationId:
                                                                verificationId!,
                                                            smsCode:
                                                                confirmationCodeController
                                                                    .text);
                                                try {
                                                  await auth
                                                      .signInWithCredential(
                                                          credential);
                                                  if (widget.user != null) {
                                                    // save user token in shared preferences :
                                                    UserSharedPreferences
                                                        .setAccessToken(
                                                            UserSharedPreferences
                                                                .getAccessToken()!);
                                                    // Send user fcm token to server :
                                                    BlocProvider.of<FcmBloc>(
                                                            context)
                                                        .add(
                                                      SendFcmTokenProcessStarted(
                                                          userToken:
                                                              UserSharedPreferences
                                                                  .getAccessToken()!),
                                                    );
                                                    BlocProvider.of<
                                                                UserLoginBloc>(
                                                            context)
                                                        .user = widget.user;
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                const NavigationBarScreen()),
                                                        (route) => false);
                                                  }
                                                } on ConnectionException catch (_) {
                                                  showWonderfulAlertDialog(
                                                      context,
                                                      AppLocalizations.of(
                                                              context)!
                                                          .error,
                                                      AppLocalizations.of(
                                                              context)!
                                                          .check_your_internet_connection);
                                                } catch (e) {
                                                  showWonderfulAlertDialog(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .error,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .error_happened_when_executing_operation,
                                                  );
                                                }
                                              }
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
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
                                                verificationCode:
                                                    confirmationCodeController
                                                        .text),
                                          );
                                          startWaitingTimer(59);
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .resend_code,
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
}
