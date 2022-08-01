import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/validators.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reset_password_bloc/reset_password_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reset_password_bloc/reset_password_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'ResetPasswordScreen';
  final String phoneNumber;

  const ResetPasswordScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // Blocs and cubits :
  final ChannelCubit officePhoneError = ChannelCubit(null);
  final ChannelCubit officePhoneErrorLogin = ChannelCubit(null);
  final ChannelCubit systemPasswordError = ChannelCubit(null);
  final ChannelCubit officeTelephoneError = ChannelCubit(null);
  late ResetPasswordBloc resetPasswordBloc;

  // Controllers:
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // Other:
  late String phoneDialCode;
  PhoneNumber? phoneNumber;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resetPasswordBloc = BlocProvider.of<ResetPasswordBloc>(context);
    //TODO: edit is out of syria
    // Dial code initializing:
    if (BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.isForStore) {
      phoneDialCode = "+961";
    } else {
      phoneDialCode = "+963";
    }
  }

  void loginErrorHandling(errorResponseMap) {
    if (errorResponseMap.containsKey("password")) {
      officePhoneErrorLogin.setState(errorResponseMap["password"].first);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextDirection textDirection = Directionality.of(context);
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (_, resetState)  {
        if (resetState is ResetPasswordError) {
          if (resetState.isConnectionError) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              AppLocalizations.of(context)!.no_internet_connection,
            );
            return;
          }

          if (resetState.errorResponse != null) {
            loginErrorHandling(resetState.errorResponse);
          } else if (resetState.errorMessage != null) {
             showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              resetState.errorMessage!,
              defaultButtonContent: AppLocalizations.of(context)!.ok,
            );
          }
        }
        if (resetState is ResetPasswordComplete) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const AuthenticationScreen(
                  popAfterFinish: false,
                ),
              ),
                  (route) => false);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formKey,
          child: Container(
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
      ),
    );
  }

  Column buildSignInScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.reset_password,),
        8.verticalSpace,
        TextFormField(
          validator: (value) {
            return passwordValidator1(value, context  );
          },
          textDirection: TextDirection.ltr,
          cursorColor: Theme.of(context).colorScheme.onBackground,
          controller: newPasswordController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enter_your_new_password,
          ),
        ),
        16.verticalSpace,
        TextFormField(
          validator: (value) {
            return confirmPasswordValidator1(value!, context,confirmPasswordController.text);
          },
          textDirection: TextDirection.ltr,
          cursorColor: Theme.of(context).colorScheme.onBackground,
          controller: confirmPasswordController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.confirm_your_new_password,
          ),
        ),

        56.verticalSpace,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(180.w, 60.h),
            ),
            onPressed: ()  {
              // validators :
              // if (!await signInFieldsValidation()) {
              //   return;
              // }
              print(widget.phoneNumber);
              print(newPasswordController.text);
              print(confirmPasswordController.text);
              print( _formKey.currentState!.validate());
              if (_formKey.currentState!.validate()) {
                print("Dsadsadasdadas");
                  _formKey.currentState!.save();
                resetPasswordBloc.add(
                  ResetPasswordStarted(
                      mobile: widget.phoneNumber,
                      newPassword: newPasswordController.text,
                      confirmPassword: confirmPasswordController.text),
                );
              }

              print("Dasdsad");
              FocusScope.of(context).unfocus();
            },
            child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
              builder: (_, resetState) {
                if (resetState is ResetPasswordProgress) {
                  return IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.signing_in,
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
      ],
    );
  }


  // Future<bool> signInFieldsValidation() async {
  //   bool isValidationSuccess = true;
  //   // phone number validate :
  //   try {
  //     String number = NumbersHelper.replaceArabicNumber(verificationCodeController.text);
  //     phoneNumber = await PhoneNumberUtil().parse(phoneDialCode + number);
  //   } catch (e) {
  //     debugPrint(
  //       e.toString(),
  //     );
  //     officePhoneErrorLogin.setState(AppLocalizations.of(context)!.invalid_mobile_number);
  //     return false;
  //   }
  //   return isValidationSuccess;
  // }


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
