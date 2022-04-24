import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_number/phone_number.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/verification_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthenticationScreen extends StatefulWidget {
  static const String id = "AuthenticationScreen";

  final bool? popAfterFinish;

  const AuthenticationScreen({Key? key, this.popAfterFinish = true}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // Cubits and Blocs
  final ChannelCubit _passwordVisibilityCubit = ChannelCubit(false);
  final ChannelCubit _checkBoxStateCubit = ChannelCubit(false);
  final ChannelCubit _isLoginSelected = ChannelCubit(true);
  ChannelCubit authenticationError = ChannelCubit(null);
  ChannelCubit authenticationErrorLogin = ChannelCubit(null);
  ChannelCubit passwordError = ChannelCubit(null);
  ChannelCubit passwordErrorLogin = ChannelCubit(null);
  ChannelCubit firstNameError = ChannelCubit(null);
  ChannelCubit lastNameError = ChannelCubit(null);
  late UserRegisterBloc userRegisterBloc;
  late UserLoginBloc userLoginBloc;
  late String phoneDialCode;
  late String phoneDialCodeLogin;
  String phoneNumber = "";

  // controllers:
  TextEditingController authenticationController = TextEditingController();
  TextEditingController authenticationControllerLogin = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  // Others :
  bool isForStore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRegisterBloc = UserRegisterBloc(UserAuthenticationRepository());
    userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
    // Dial code initializing:
    isForStore = BlocProvider.of<SystemVariablesBloc>(context).systemVariables!.isForStore;
    if (isForStore) {
      phoneDialCode = "+961";
      phoneDialCodeLogin = "+961";
    } else {
      phoneDialCode = "+963";
      phoneDialCodeLogin = "+963";
    }
  }

  void signUpErrorHandling(errorResponseMap) {
    if (errorResponseMap.containsKey("first_name")) {
      firstNameError.setState(errorResponseMap["first_name"].first);
    }
    if (errorResponseMap.containsKey("last_name")) {
      lastNameError.setState(errorResponseMap["last_name"].first);
    }
    if (errorResponseMap.containsKey("authentication")) {
      authenticationError.setState(errorResponseMap["authentication"].first);
    }
    if (errorResponseMap.containsKey("password")) {
      passwordError.setState(errorResponseMap["password"].first);
    }
  }

  void loginErrorHandling(errorResponseMap) {
    if (errorResponseMap.containsKey("authentication")) {
      authenticationErrorLogin.setState(errorResponseMap["authentication"].first);
    }
    if (errorResponseMap.containsKey("password")) {
      passwordErrorLogin.setState(errorResponseMap["password"].first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserRegisterBloc>(
          create: (context) => userRegisterBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserRegisterBloc, UserRegisterState>(
            listener: (_, registerState) {
              if (registerState is UserRegisterError) {
                if (registerState.isConnectionError) {
                  showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.no_internet_connection,
                  );
                  return;
                }

                if (registerState.errorResponse != null) {
                  signUpErrorHandling(registerState.errorResponse);
                } else if (registerState.errorMessage != null) {
                  showWonderfulAlertDialog(
                      context, AppLocalizations.of(context)!.error, registerState.errorMessage!);
                }
              }
              if (registerState is UserRegisterComplete) {
                String phone = registerState.user.authentication;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerificationCodeScreen(
                      phoneNumber: phone,
                    ),
                  ),
                );

                // if (registerState.user.token != null) {
                //   // save user token in shared preferences ;
                //   UserSharedPreferences.setAccessToken(registerState.user.token!);
                //   // Send user fcm token to server :
                //   BlocProvider.of<FcmBloc>(context).add(
                //     SendFcmTokenProcessStarted(userToken: registerState.user.token!),
                //   );
                // }

              }
            },
          ),
          BlocListener<UserLoginBloc, UserLoginState>(
            listener: (_, loginState) {
              if (loginState is UserLoginError) {
                if (loginState.isConnectionError) {
                  showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.no_internet_connection,
                  );
                  return;
                }

                if (loginState.errorResponse != null) {
                  loginErrorHandling(loginState.errorResponse);
                } else if (loginState.errorMessage != null) {
                  showWonderfulAlertDialog(
                      context, AppLocalizations.of(context)!.error, loginState.errorMessage!);
                }
              }
              if (loginState is UserLoginComplete) {
                if (userLoginBloc.user!.token != null) {
                  // save user token in shared preferences ;
                  UserSharedPreferences.setAccessToken(userLoginBloc.user!.token!);
                  // Send user fcm token to server :
                  BlocProvider.of<FcmBloc>(context).add(
                    SendFcmTokenProcessStarted(userToken: userLoginBloc.user!.token!),
                  );
                }
                if (widget.popAfterFinish!) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
                }
              }
            },
          ),
        ],
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                Builder(
                  builder: (context) => Container(
                    alignment: Alignment.center,
                    width: 1.sw,
                    height: 1.sh,
                    padding: kSmallSymWidth,
                    color: Theme.of(context).colorScheme.secondary,
                    child: BlocBuilder<ChannelCubit, dynamic>(
                      bloc: _isLoginSelected,
                      builder: (_, isLoginSelected) {
                        if (isLoginSelected) {
                          return buildLoginScreen();
                        }
                        return buildSignupScreen();
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () {
                      if (widget.popAfterFinish!) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
                      }
                    },
                  ),
                ),
                ...kBackgroundDrawings(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildLoginScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.sign_in,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          72.verticalSpace,
          Text(
            AppLocalizations.of(context)!.mobile_number + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: authenticationErrorLogin,
            builder: (_, errorMessage) {
              return IntlPhoneField(
                controller: authenticationControllerLogin,
                decoration: InputDecoration(errorText: errorMessage),
                initialCountryCode: isForStore ? 'LB' : 'SY',
                onChanged: (phone) {
                  phoneDialCodeLogin = phone.countryCode;
                  authenticationErrorLogin.setState(null);
                },
                autovalidateMode: AutovalidateMode.disabled,
              );
            },
          ),
          kHe16,
          Text(
            AppLocalizations.of(context)!.password + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: passwordErrorLogin,
            builder: (_, errorMessage) {
              return BlocBuilder<ChannelCubit, dynamic>(
                bloc: _passwordVisibilityCubit,
                builder: (context, isVisible) {
                  return TextField(
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 2),
                    onChanged: (_) {
                      passwordErrorLogin.setState(null);
                    },
                    controller: passwordControllerLogin,
                    keyboardType: TextInputType.text,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: AppLocalizations.of(context)!.enter_password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          (!isVisible) ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          _passwordVisibilityCubit.setState(!isVisible);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Row(
            children: [
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: _checkBoxStateCubit,
                builder: (_, isChecked) {
                  return Checkbox(
                    value: isChecked,
                    onChanged: (_) {
                      _checkBoxStateCubit.setState(!isChecked);
                    },
                  );
                },
              ),
              Text(
                AppLocalizations.of(context)!.remember_me,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          kHe24,
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(240.w, 64.h),
                maximumSize: Size(300.w, 64.h),
              ),
              child: BlocBuilder<UserLoginBloc, UserLoginState>(
                builder: (_, loginState) {
                  if (loginState is UserLoginProgress) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitWave(
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20.w,
                        ),
                        kWi16,
                        Text(
                          AppLocalizations.of(context)!.signing_in,
                        )
                      ],
                    );
                  }
                  return Text(
                    AppLocalizations.of(context)!.sign_in,
                  );
                },
              ),
              onPressed: () async {
                if (BlocProvider.of<UserLoginBloc>(context).state is UserLoginProgress) {
                  return;
                }

                // validators :
                if (!await getFieldsValidationSignIn()) {
                  return;
                }
                print(phoneNumber);
                print(passwordControllerLogin.text);
                userLoginBloc.add(UserLoginStarted(
                    authentication: phoneNumber, password: passwordControllerLogin.text));
              },
            ),
          ),
          kHe16,
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(240.w, 64.h),
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  )),
              child: Text(AppLocalizations.of(context)!.create_account,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground)),
              onPressed: () {
                _isLoginSelected.setState(false);
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildSignupScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.create_account,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          kHe40,
          Text(
            AppLocalizations.of(context)!.mobile_number + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: authenticationError,
            builder: (_, errorMessage) {
              return IntlPhoneField(
                controller: authenticationController,
                decoration: InputDecoration(errorText: errorMessage),
                initialCountryCode: isForStore ? 'LB' : 'SY',
                onChanged: (phone) {
                  authenticationError.setState(null);
                },
                autovalidateMode: AutovalidateMode.disabled,
              );
            },
          ),
          kHe24,
          Text(
            AppLocalizations.of(context)!.password + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: passwordError,
            builder: (_, errorMessage) {
              return BlocBuilder<ChannelCubit, dynamic>(
                bloc: _passwordVisibilityCubit,
                builder: (context, isVisible) {
                  return TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: AppLocalizations.of(context)!.enter_password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          (isVisible) ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          _passwordVisibilityCubit.setState(!isVisible);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          kHe24,
          Text(
            AppLocalizations.of(context)!.first_name + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: firstNameError,
            builder: (_, errorMessage) {
              return TextField(
                onChanged: (_) {
                  firstNameError.setState(null);
                },
                controller: firstNameController,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintText: AppLocalizations.of(context)!.enter_first_name,
                ),
              );
            },
          ),
          kHe24,
          Text(
            AppLocalizations.of(context)!.last_name + " :",
            style: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: lastNameError,
            builder: (_, errorMessage) {
              return TextField(
                onChanged: (_) {
                  lastNameError.setState(null);
                },
                controller: lastNameController,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintText: AppLocalizations.of(context)!.enter_last_name,
                ),
              );
            },
          ),
          64.verticalSpace,
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(240.w, 64.h),
                maximumSize: Size(300.w, 64.h),
              ),
              child: BlocBuilder<UserRegisterBloc, UserRegisterState>(
                bloc: userRegisterBloc,
                builder: (_, registerState) {
                  if (registerState is UserRegisterProgress) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitWave(
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20.w,
                        ),
                        kWi16,
                        Text(
                          AppLocalizations.of(context)!.creating_account,
                        )
                      ],
                    );
                  }
                  return Text(
                    AppLocalizations.of(context)!.create_account,
                  );
                },
              ),
              onPressed: () async {
                // validators :
                if (!await getFieldsValidation()) {
                  return;
                }

                userRegisterBloc.add(
                  UserRegisterStarted(
                    register: Register(
                        authentication: phoneNumber,
                        password: passwordController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text),
                  ),
                );
              },
            ),
          ),
          kHe16,
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(240.w, 64.h),
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  )),
              child: Text(AppLocalizations.of(context)!.sign_in,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground)),
              onPressed: () {
                _isLoginSelected.setState(true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> getFieldsValidation() async {
    bool isValidationSuccess = true;
    // phone number validate :
    try {
      final parsedPhoneNumber =
          await PhoneNumberUtil().parse(phoneDialCode + authenticationController.text);
      phoneNumber = parsedPhoneNumber.international.replaceAll(" ", "");
    } catch (e) {
      print(e);
      authenticationError.setState(AppLocalizations.of(context)!.invalid_mobile_number);
      return false;
    }
    return isValidationSuccess;
  }

  Future<bool> getFieldsValidationSignIn() async {
    bool isValidationSuccess = true;
    // phone number validate :
    try {
      final parsedPhoneNumber =
          await PhoneNumberUtil().parse(phoneDialCodeLogin + authenticationControllerLogin.text);
      phoneNumber = parsedPhoneNumber.international.replaceAll(" ", "");
    } catch (e) {
      print(e);
      authenticationErrorLogin.setState(AppLocalizations.of(context)!.invalid_mobile_number);
      return false;
    }
    return isValidationSuccess;
  }
}
