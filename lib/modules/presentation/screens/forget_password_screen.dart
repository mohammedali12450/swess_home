import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_number/phone_number.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/forget_password_bloc/forget_password_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/screens/verificaton_screen_reset.dart';
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
  //final ChannelCubit _passwordVisibleSwitcherCubit = ChannelCubit(false);
  final ChannelCubit officePhoneError = ChannelCubit(null);
  final ChannelCubit officePhoneErrorLogin = ChannelCubit(null);
  final ChannelCubit systemPasswordError = ChannelCubit(null);
  final ChannelCubit officeTelephoneError = ChannelCubit(null);
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

    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (_, forgetState) {
        if (forgetState is ForgetPasswordError) {
          print("hi $forgetState");
          if (forgetState.isConnectionError) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              AppLocalizations.of(context)!.no_internet_connection,
            );
            return;
          }
          if (forgetState.errorResponse != null) {
            loginErrorHandling(forgetState.errorResponse);
          }
          if (forgetState.errorMessage != null) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              forgetState.errorMessage!,
              defaultButtonContent: AppLocalizations.of(context)!.ok,
            );
          }
        }
        if (forgetState is ForgetPasswordComplete) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VerificationCodeScreenReset(
                phoneNumber: "+" +
                    phoneNumber!.countryCode +
                    phoneNumber!.nationalNumber,
              ),
            ),
          );
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

  /// new
  Column buildSignInScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        40.verticalSpace,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(300.w, 50.h),
              maximumSize: Size(300.w, 50.h),
            ),
            onPressed: () async {
              // todo send
            },
            child: Text(
              AppLocalizations.of(context)!.send,
            ),
          ),
        ),
        25.verticalSpace,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(300.w, 50.h),
              maximumSize: Size(300.w, 50.h),
            ),
            onPressed: () async {
              // todo resend
            },
            child: Text(
              AppLocalizations.of(context)!.resend,
            ),
          ),
        ),
        25.verticalSpace,
        Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.time_of_receive_link,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              )),
        ),
      ],
    );
  }

  /// old
  // Column buildSignInScreen() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         AppLocalizations.of(context)!.mobile_number + " :",
  //       ),
  //       8.verticalSpace,
  //       BlocBuilder<ChannelCubit, dynamic>(
  //         bloc: officePhoneErrorLogin,
  //         builder: (_, errorMessage) {
  //           return IntlPhoneField(
  //             controller: officePhoneControllerLogin,
  //             decoration:
  //             InputDecoration(errorText: errorMessage, errorMaxLines: 2),
  //             initialCountryCode: isForStore ? 'LB' : 'SY',
  //             onChanged: (phone) {
  //               phoneDialCode = phone.countryCode;
  //               officePhoneErrorLogin.setState(null);
  //             },
  //             disableLengthCheck: true,
  //             autovalidateMode: AutovalidateMode.disabled,
  //           );
  //         },
  //       ),
  //       // BlocBuilder<ChannelCubit, dynamic>(
  //       //   bloc: officePhoneErrorLogin,
  //       //   builder: (_, errorMessage) {
  //       //     return TextField(
  //       //       textDirection: TextDirection.ltr,
  //       //       onChanged: (_) {
  //       //         officePhoneErrorLogin.setState(null);
  //       //       },
  //       //       cursorColor: Theme.of(context).colorScheme.onBackground,
  //       //       controller: officePhoneControllerLogin,
  //       //       keyboardType: TextInputType.phone,
  //       //       decoration: InputDecoration(
  //       //         prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
  //       //         prefixIcon: Padding(
  //       //           padding: EdgeInsets.symmetric(horizontal: 12.w),
  //       //           child: Text(
  //       //             phoneDialCode,
  //       //             style: Theme.of(context).textTheme.caption,
  //       //             textDirection: TextDirection.ltr,
  //       //           ),
  //       //         ),
  //       //         errorText: errorMessage,
  //       //         hintText: AppLocalizations.of(context)!.enter_mobile_number,
  //       //       ),
  //       //     );
  //       //   },
  //       // ),
  //       56.verticalSpace,
  //       Center(
  //         child: ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             minimumSize: Size(180.w, 60.h),
  //             maximumSize: Size(200.w, 60.h),
  //           ),
  //           onPressed: () async {
  //             // validators :
  //             if (!await signInFieldsValidation()) {
  //               return;
  //             }
  //             forgetPasswordBloc.add(
  //               ForgetPasswordStarted(
  //                 mobile: "+" +
  //                     phoneNumber!.countryCode +
  //                     phoneNumber!.nationalNumber,
  //               ),
  //             );
  //           },
  //           child: BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
  //             builder: (_, forgetState) {
  //               if (forgetState is ForgetPasswordProgress) {
  //                 return IntrinsicHeight(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Text(
  //                         AppLocalizations.of(context)!.sending,
  //                       ),
  //                       12.horizontalSpace,
  //                       SpinKitWave(
  //                         color: Theme.of(context).colorScheme.onPrimary,
  //                         size: 20.w,
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }
  //               return Text(
  //                 AppLocalizations.of(context)!.next,
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }


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
