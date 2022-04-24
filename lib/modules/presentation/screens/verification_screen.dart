import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pinput/pinput.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_estate_bloc/send_estate_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_verification_code_bloc/send_verification_code_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/send_verification_code_bloc/send_verification_code_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationCodeScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  late String phoneNumber;
  ChannelCubit isVerificationButtonActiveCubit = ChannelCubit(false);
  ChannelCubit isFireBaseLoadingCubit = ChannelCubit(true);
  String? verificationId;

  TextEditingController verificationCodeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumber = widget.phoneNumber;
    if (BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.isForStore) {
      verifyPhoneNumber();
    } else {
      isFireBaseLoadingCubit.setState(false);
    }
  }

  verifyPhoneNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        isFireBaseLoadingCubit.setState(false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final PinTheme defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.56)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
    PinTheme focusedPinTheme = defaultPinTheme.copyWith(
      width: 60.w,
      height: 60.w,
      decoration: defaultPinTheme.decoration!.copyWith(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.background.withOpacity(0.4),
        border: Border.all(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
      ),
      textStyle: textStyling(S.s22, W.w5, C.bl, fontFamily: F.roboto),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      textStyle: textStyling(S.s22, W.w5, C.hint, fontFamily: F.roboto),
    );

    return Container(
      width: 1.sw,
      height: 1.sh,
      padding: kLargeSymWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        gradient: RadialGradient(
          colors: [
            Color.alphaBlend(
                AppColors.thirdColor.withOpacity(0.65), Theme.of(context).colorScheme.background),
            AppColors.thirdColor,
          ],
        ),
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
                                  AppLocalizations.of(context)!.confirmation_code_sent,
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
                              Pinput(
                                showCursor: false,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                submittedPinTheme: submittedPinTheme,
                                onChanged: (code) {
                                  if (code.length == 6) {
                                    isVerificationButtonActiveCubit.setState(true);
                                  } else {
                                    isVerificationButtonActiveCubit.setState(false);
                                  }
                                },
                                controller: verificationCodeController,
                                length: 6,
                              ),
                              SizedBox(
                                height: 64.h,
                              ),
                              BlocProvider(
                                create: (context) => SendVerificationCodeBloc(),
                                child: BlocBuilder<SendVerificationCodeBloc,
                                    SendVerificationCodeState>(
                                  builder: (context, sendCodeState) {
                                    return BlocBuilder<ChannelCubit, dynamic>(
                                      bloc: isVerificationButtonActiveCubit,
                                      builder: (context, isActive) {
                                        return ElevatedButton(
                                          child: (sendCodeState is! SendVerificationCodeProgress)
                                              ? Text(
                                                  AppLocalizations.of(context)!.send,
                                                )
                                              : SpinKitWave(
                                                  size: 24.w,
                                                  color: Colors.white,
                                                ),
                                          onPressed: () async {
                                            if (!isActive) return;
                                            if (sendCodeState is SendVerificationCodeProgress) {
                                              return;
                                            }
                                            // Syria state :
                                            if (!BlocProvider.of<SystemVariablesBloc>(context)
                                                .systemVariables!
                                                .isForStore) {
                                              BlocProvider.of<SendVerificationCodeBloc>(context)
                                                  .add(
                                                VerificationCodeSendingStarted(
                                                    phone: widget.phoneNumber,
                                                    code: verificationCodeController.text),
                                              );
                                            } else {
                                              // Firebase state :
                                              if (isActive && verificationId != null) {
                                                // Create a PhoneAuthCredential with the code
                                                PhoneAuthCredential credential =
                                                    PhoneAuthProvider.credential(
                                                        verificationId: verificationId!,
                                                        smsCode: verificationCodeController.text);
                                                try {
                                                  await auth.signInWithCredential(credential);
                                                  Navigator.pushNamed(context, HomeScreen.id);
                                                } on ConnectionException catch (_) {
                                                  showWonderfulAlertDialog(
                                                      context,
                                                      AppLocalizations.of(context)!.error,
                                                      AppLocalizations.of(context)!
                                                          .check_your_internet_connection);
                                                } catch (e) {
                                                  showWonderfulAlertDialog(
                                                    context,
                                                    AppLocalizations.of(context)!.error,
                                                    AppLocalizations.of(context)!
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
}
