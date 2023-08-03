import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_number/phone_number.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/formatters.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/numbers_helper.dart';
import '../../business_logic_components/bloc/forget_password_bloc/forget_password_event.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String id = 'ForgetPasswordScreen';

  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // Blocs and cubits :
  final ChannelCubit officePhoneError = ChannelCubit(null);
  final ChannelCubit officePhoneErrorLogin = ChannelCubit(null);
  final ChannelCubit systemPasswordError = ChannelCubit(null);
  final ChannelCubit officeTelephoneError = ChannelCubit(null);
  final ChannelCubit success = ChannelCubit(null);
  late ForgetPasswordBloc forgetPasswordBloc;

  // Controllers:
  TextEditingController officePhoneController = TextEditingController();
  TextEditingController officePhoneControllerLogin = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();
  TextEditingController systemPasswordController = TextEditingController();
  TextEditingController officeTelephoneController = TextEditingController();

  // Other:
  late String phoneDialCode;
  PhoneNumber? phoneNumber;
  bool isForStore = false;
  late String phoneDialCodeLogin;
  ScrollController scrollController = ScrollController();

  late SharedPreferences _prefs;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimerActive = false;

  @override
  void initState() {
    super.initState();
    forgetPasswordBloc = BlocProvider.of<ForgetPasswordBloc>(context);
    //TODO: edit is out of syria
    // Dial code initializing:
    isForStore = BlocProvider.of<SystemVariablesBloc>(context)
        .systemVariables!
        .isForStore;
    if (isForStore) {
      phoneDialCode = "+961";
      phoneDialCodeLogin = "+961";
    } else {
      phoneDialCode = "+963";
      phoneDialCodeLogin = "+963";
    }
    // initWaitingTime();
    _loadTimer();
  }

  Future<void> _loadTimer() async {
    _prefs = await SharedPreferences.getInstance();
    final lastResetTime = _prefs.getInt('last_reset_time') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedSeconds = (now - lastResetTime) ~/ 1000;
    if (elapsedSeconds > 900) {
      _remainingSeconds = 0;
    } else {
      _remainingSeconds = 900 - elapsedSeconds;
      _startTimer();
    }
  }

  Future<void> _savePreferences() async {
    await _prefs.setInt(
        'last_reset_time', DateTime.now().millisecondsSinceEpoch);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
        }
      });
    });
    _isTimerActive = true;
  }

  void _stopTimer() {
    _timer?.cancel();
    _isTimerActive = false;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void loginErrorHandling(errorResponseMap) {
    if (errorResponseMap.containsKey("user")) {
      officePhoneErrorLogin.setState(errorResponseMap["user"].first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (_, forgetState) {
        if (forgetState is ForgetPasswordError) {
          if (forgetState.isConnectionError) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              AppLocalizations.of(context)!.no_internet_connection,
            );
            return;
          }
          // if (forgetState.errorResponse != null) {
          //   loginErrorHandling(forgetState.errorResponse);
          // }
          if (forgetState.errorMessage != null) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              forgetState.errorMessage!,
              defaultButtonContent: AppLocalizations.of(context)!.ok,
            );
          }
          if (forgetState.isUnauthorizedError) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              forgetState.errorMessage!,
              defaultButtonContent: AppLocalizations.of(context)!.ok,
            );
          }
        }
        if (forgetState is ForgetPasswordComplete) {
          Navigator.of(context).pushNamedAndRemoveUntil(AuthenticationScreen.id, (route) => false) ;
        }
      },
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
                    40.verticalSpace,
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back)),
                      ],
                    ),
                    SizedBox(
                      width: 200.w,
                      height: 200.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        child: Image.asset(swessHomeIconPath),
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

  /// old
  Column buildSignInScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.mobile_number} :",
        ),
        8.verticalSpace,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: officePhoneErrorLogin,
          builder: (_, errorMessage) {
            return IntlPhoneField(
              inputFormatters: <TextInputFormatter>[
                only15Numbers,
                onlyNumbers,
              ],
              controller: officePhoneControllerLogin,
              decoration:
                  InputDecoration(errorText: errorMessage, errorMaxLines: 2),
              initialCountryCode: isForStore ? 'LB' : 'SY',
              onChanged: (phone) {
                phoneDialCode = phone.countryCode;
                officePhoneErrorLogin.setState(null);
              },
              disableLengthCheck: true,
              autovalidateMode: AutovalidateMode.disabled,
            );
          },
        ),
        // BlocBuilder<ChannelCubit, dynamic>(
        //   bloc: officePhoneErrorLogin,
        //   builder: (_, errorMessage) {
        //     return TextField(
        //       textDirection: TextDirection.ltr,
        //       onChanged: (_) {
        //         officePhoneErrorLogin.setState(null);
        //       },
        //       cursorColor: Theme.of(context).colorScheme.onBackground,
        //       controller: officePhoneControllerLogin,
        //       keyboardType: TextInputType.phone,
        //       decoration: InputDecoration(
        //         prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        //         prefixIcon: Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 12.w),
        //           child: Text(
        //             phoneDialCode,
        //             style: Theme.of(context).textTheme.caption,
        //             textDirection: TextDirection.ltr,
        //           ),
        //         ),
        //         errorText: errorMessage,
        //         hintText: AppLocalizations.of(context)!.enter_mobile_number,
        //       ),
        //     );
        //   },
        // ),
        56.verticalSpace,
        StreamBuilder<int>(builder: (context, snapshot) {
          return Center(
            child: 
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(180.w, 60.h),
                maximumSize: Size(200.w, 60.h),
              ),
              onPressed: () async {
                // validators :
                if (!await signInFieldsValidation()) {
                  return;
                }

                if (_remainingSeconds > 0) {
                  forgetPasswordBloc.add(ForgetPasswordBeforeEndTimer(mobile: "+${phoneNumber!.countryCode}${phoneNumber!.nationalNumber}",));
                } else {
                  forgetPasswordBloc.add(
                    ForgetPasswordStarted(
                      mobile:
                      "+${phoneNumber!.countryCode}${phoneNumber!.nationalNumber}",
                    ),
                  );
                  _isTimerActive ? null : await _savePreferences();
                  setState(() {
                    _remainingSeconds = 900;
                    _startTimer();
                  });
                  FocusScope.of(context).unfocus();

                }

              },
              child: BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
                builder: (_, forgetState) {
                  if (forgetState is ForgetPasswordProgress) {
                    return IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.send,
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
                    AppLocalizations.of(context)!.send,
                  );
                },
              ),
            ),
          );
        }),
        30.verticalSpace,
        StreamBuilder<int>(builder: (context, snapshot) {
          if (_remainingSeconds > 0) {
            return _timerCountDown();
          } else {
            return const Center();
          }
        }),
      ],
    );
  }

  Future<bool> signInFieldsValidation() async {
    bool isValidationSuccess = true;
    // phone number validate :
    try {
      String number =
          NumbersHelper.replaceArabicNumber(officePhoneControllerLogin.text);
      phoneNumber = await PhoneNumberUtil().parse(phoneDialCode + number);
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      officePhoneErrorLogin
          .setState(AppLocalizations.of(context)!.invalid_mobile_number);
      return false;
    }
    return isValidationSuccess;
  }

  Widget _timerCountDown() {
    return StreamBuilder<int>(
        initialData: 0,
        builder: (context, waitingTimeSnapshot) {
          if (_isTimerActive) {
            return Column(
              children: [
                Text(
                  '${_remainingSeconds ~/ 60}:${_remainingSeconds % 60}',
                  style: const TextStyle(fontSize: 16),
                ),
                25.verticalSpace,
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.time_of_receive_link,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
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
}
