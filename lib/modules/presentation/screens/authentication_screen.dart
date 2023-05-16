import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/formatters.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_confirmation_code_bloc/resend_confirmation_code_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_confirmation_code_bloc/resend_confirmation_code_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/resend_confirmation_code_bloc/resend_confirmation_code_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/forget_password_screen.dart';
import 'package:swesshome/modules/presentation/screens/verification_login_code.dart';
import 'package:swesshome/modules/presentation/screens/verification_screen.dart';
import 'package:swesshome/modules/presentation/widgets/button_socail.dart';
import 'package:swesshome/modules/presentation/widgets/my_dropdown_list.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import '../../../core/functions/validators.dart';
import '../../../utils/helpers/my_snack_bar.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_bloc.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_event.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_state.dart';
import '../../data/models/governorates.dart';
import '../../data/providers/theme_provider.dart';
import '../pages/contact_list_page.dart';
import '../pages/terms_condition_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/res_text.dart';
import 'navigation_bar_screen.dart';
import 'dart:ui' as ui;

class AuthenticationScreen extends StatefulWidget {
  static const String id = "AuthenticationScreen";

  final bool? popAfterFinish;

  const AuthenticationScreen({Key? key, this.popAfterFinish = true})
      : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // Cubits and Blocs
  final ChannelCubit _passwordVisibilityCubit = ChannelCubit(false);
  final ChannelCubit _repeatPasswordVisibleCubit = ChannelCubit(false);
  final ChannelCubit _isLoginSelected = ChannelCubit(true);
  final ChannelCubit _termsIsCheckedCubit = ChannelCubit(false);
  ChannelCubit authenticationError = ChannelCubit(null);
  ChannelCubit authenticationErrorLogin = ChannelCubit(null);
  ChannelCubit passwordError = ChannelCubit(null);
  ChannelCubit passwordErrorLogin = ChannelCubit(null);
  ChannelCubit repeatPasswordError = ChannelCubit(null);
  ChannelCubit firstNameError = ChannelCubit(null);
  ChannelCubit lastNameError = ChannelCubit(null);
  ChannelCubit emailError = ChannelCubit(null);
  ChannelCubit countryError = ChannelCubit(null);
  // ChannelCubit birthdateError = ChannelCubit(null);
  ChannelCubit userCountry = ChannelCubit(null);
  late UserRegisterBloc userRegisterBloc;
  late UserLoginBloc userLoginBloc;
  late GovernoratesBloc governoratesBloc;
  late String phoneDialCode;
  int selectedGovernorateId = 0;
  //DateTime? birthDate;
  late String phoneDialCodeLogin;
  String phoneNumber = "";
  bool isCheck = false;

  // controllers:
  TextEditingController authenticationController = TextEditingController();
  TextEditingController authenticationControllerLogin = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  //TextEditingController birthdateController = TextEditingController();

  // Others :
  bool isForStore = false;
  late bool isDark;
  List<Contact>? contacts;

  @override
  void initState() {
    super.initState();
    ApplicationSharedPreferences.setWalkThroughPassState(true);
    userRegisterBloc = UserRegisterBloc(UserAuthenticationRepository());
    userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
    governoratesBloc = BlocProvider.of<GovernoratesBloc>(context);
    governoratesBloc.add(GovernoratesFetchStarted());
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
    userCountry.setState("Syrian Arab Republic");
    getCurrentPosition();
    _askPermissions();
    //getContact();
  }

  getContact() async {
    contacts = await ContactList.refreshContacts();
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
    if (errorResponseMap.containsKey("email")) {
      emailError.setState(errorResponseMap["email"].first);
    }
    // if (errorResponseMap.containsKey("birthOfDate")) {
    //   birthdateError.setState(errorResponseMap["birthOfDate"].first);
    // }
  }

  void loginErrorHandling(errorResponseMap) {
    if (errorResponseMap.containsKey("authentication")) {
      authenticationErrorLogin
          .setState(errorResponseMap["authentication"].first);
    }
    if (errorResponseMap.containsKey("password")) {
      passwordErrorLogin.setState(errorResponseMap["password"].first);
    }
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
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

                // if (registerState.errorResponse != null) {
                //   signUpErrorHandling(registerState.errorResponse);
                // } else
                if (registerState.errorMessage != null) {
                  showWonderfulAlertDialog(
                      context,
                      AppLocalizations.of(context)!.error,
                      registerState.errorMessage!);
                }
              }

              if (registerState is UserRegisterComplete) {
                String phone = registerState.user.authentication!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerificationCodeScreen(
                      phoneNumber: phone,
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<UserLoginBloc, UserLoginState>(
            listener: (_, loginState) async {
              if (loginState is UserLoginError) {
                if (loginState.isConnectionError) {
                  showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    AppLocalizations.of(context)!.no_internet_connection,
                  );
                  return;
                }
                if (loginState.isUnauthorizedError) {
                  await showWonderfulAlertDialog(
                      context,
                      AppLocalizations.of(context)!.confirmation,
                      AppLocalizations.of(context)!
                          .account_not_confirmed_dialog,
                      removeDefaultButton: true,
                      dialogButtons: [
                        BlocProvider<ResendConfirmationCodeBloc>(
                          create: (context) => ResendConfirmationCodeBloc(),
                          child: BlocConsumer<ResendConfirmationCodeBloc,
                              ResendConfirmationCodeState>(
                            listener: (_, resendCodeState) async {
                              if (resendCodeState
                                  is ResendConfirmationCodeComplete) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VerificationCodeScreen(
                                      phoneNumber: phoneNumber,
                                    ),
                                  ),
                                );
                              }
                              if (resendCodeState
                                  is ResendConfirmationCodeError) {
                                await showWonderfulAlertDialog(
                                    context,
                                    AppLocalizations.of(context)!.error,
                                    resendCodeState.message);
                              }
                            },
                            builder: (context, resendCodeState) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(180.w, 56.h),
                                ),
                                child: (resendCodeState
                                        is ResendConfirmationCodeProgress)
                                    ? SpinKitWave(
                                        color: AppColors.white,
                                        size: 20.w,
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!.resend),
                                onPressed: () {
                                  // Confirmation Code Resend:
                                  BlocProvider.of<ResendConfirmationCodeBloc>(
                                          context)
                                      .add(
                                    ResendConfirmationCodeStarted(
                                        phoneNumber: phoneNumber),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(180.w, 56.h),
                          ),
                          child: Text(AppLocalizations.of(context)!.cancel),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ]);
                  return;
                }

                if (loginState.errorResponse != null) {
                  loginErrorHandling(loginState.errorResponse);
                }
                if (loginState.errorMessage != null) {
                  if (loginState.errorMessage!.contains("تم")) {
                    // if (loginState.errorMessage!.contains("تم")) {
                    //   Navigator.pushReplacement(context,
                    //       MaterialPageRoute(builder: (_) => const HomeScreen()));
                    // }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerificationLoginCodeScreen(
                          phoneNumber: phoneNumber,
                          message: loginState.errorMessage!,
                        ),
                      ),
                    );
                    return;
                  }
                  log(loginState.errorMessage!);
                  showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.error,
                    loginState.errorMessage!,
                  );
                }
              }
              if (loginState is UserLoginComplete) {
                if (UserSharedPreferences.getAccessToken() != null) {
                  // // save user token in shared preferences ;
                  // UserSharedPreferences.setAccessToken(
                  //     userLoginBloc.user!.token!);
                  // Send user fcm token to server :
                  BlocProvider.of<FcmBloc>(context).add(
                    SendFcmTokenProcessStarted(
                        userToken: UserSharedPreferences.getAccessToken()!),
                  );
                }
                if (widget.popAfterFinish!) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NavigationBarScreen()),
                      (route) => false);
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
                    width: 1.sw,
                    height: 1.sh,
                    padding: kSmallSymWidth,
                    color: Theme.of(context).colorScheme.secondary,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 1.sw,
                            alignment:
                                Provider.of<LocaleProvider>(context).isArabic()
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const NavigationBarScreen()),
                                    (route) => false);
                                int visitNum = ApplicationSharedPreferences
                                    .getVisitNumber();
                                //print("ghina : $visitNum");
                                ApplicationSharedPreferences.setVisitNumber(
                                    visitNum + 1);
                              },
                            ),
                          ),
                          BlocBuilder<ChannelCubit, dynamic>(
                            bloc: _isLoginSelected,
                            builder: (_, isLoginSelected) {
                              if (isLoginSelected) {
                                return buildLoginScreen();
                              }
                              return buildSignupScreen();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
            child: ResText(
              AppLocalizations.of(context)!.sign_in,
              textStyle: Theme.of(context).textTheme.headline3,
            ),
          ),
          72.verticalSpace,
          ResText(
            AppLocalizations.of(context)!.mobile_number + " :",
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: BlocBuilder<ChannelCubit, dynamic>(
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
                  disableLengthCheck: true,
                  autovalidateMode: AutovalidateMode.disabled,
                );
              },
            ),
          ),
          kHe16,
          ResText(
            AppLocalizations.of(context)!.password + " :",
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: passwordErrorLogin,
            builder: (_, errorMessage) {
              return BlocBuilder<ChannelCubit, dynamic>(
                bloc: _passwordVisibilityCubit,
                builder: (context, isVisible) {
                  return TextField(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(height: 2.h),
                    onChanged: (_) {
                      passwordErrorLogin.setState(null);
                    },
                    controller: passwordControllerLogin,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      onlyEnglishLetters,
                    ],
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: AppLocalizations.of(context)!.enter_password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          (!isVisible)
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
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
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgetPasswordScreen()),
              );
            },
            child: ResText(
              AppLocalizations.of(context)!.forget_password,
              textStyle: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          kHe24,
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(330.w, 60.h),
                maximumSize: Size(330.w, 60.h),
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
                if (BlocProvider.of<UserLoginBloc>(context).state
                    is UserLoginProgress) {
                  return;
                }

                // validators :
                if (!await getFieldsValidationSignIn()) {
                  return;
                }

                // ignore: use_build_context_synchronously
                FocusScope.of(context).unfocus();

                userLoginBloc.add(
                  UserLoginStarted(
                    authentication: phoneNumber,
                    password: passwordControllerLogin.text,
                  ),
                );
                ApplicationSharedPreferences.setLoginPassed(true);
                UserSharedPreferences.setPhoneNumber(phoneNumber);
              },
            ),
          ),
          Container(
            height: 40.h,
            margin: EdgeInsets.only(top: 25.h, bottom: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: ButtonSocail(
                      text: AppLocalizations.of(context)!.google,
                      iconPath: "$assetsImages/google_icon.png",
                      onPress: () async {
                        await BlocProvider.of<UserLoginBloc>(context)
                            .loginGoogle();
                      }),
                ),
                kWi20,
                Expanded(
                  child: ButtonSocail(
                    text: AppLocalizations.of(context)!.facebook,
                    iconPath: "$assetsImages/facebook_icon.png",
                    onPress: () async {
                      BlocProvider.of<UserLoginBloc>(context).loginFacebook();
                    },
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _isLoginSelected.setState(false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResText(
                  AppLocalizations.of(context)!.dont_have_an_account,
                  textStyle: Theme.of(context).textTheme.subtitle2,
                ),
                ResText(
                  "  " + AppLocalizations.of(context)!.create_account,
                  textStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildSignupScreen() {
    //bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: ResText(
              AppLocalizations.of(context)!.create_account,
              textStyle: Theme.of(context).textTheme.headline3,
            ),
          ),
          kHe40,
          ResText(
            AppLocalizations.of(context)!.mobile_number + " :",
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: BlocBuilder<ChannelCubit, dynamic>(
              bloc: authenticationError,
              builder: (_, errorMessage) {
                return IntlPhoneField(
                  onCountryChanged: (country) {
                    userCountry.setState(country.name);
                  },
                  controller: authenticationController,
                  decoration: InputDecoration(
                      errorText: errorMessage, errorMaxLines: 2),
                  initialCountryCode: isForStore ? 'LB' : 'SY',
                  onChanged: (phone) {
                    phoneDialCode = phone.countryCode;
                    authenticationError.setState(null);
                  },
                  disableLengthCheck: true,
                  autovalidateMode: AutovalidateMode.disabled,
                );
              },
            ),
          ),
          //-------------------------------------------------------------
          kHe24,
          ResText(
            "${AppLocalizations.of(context)!.email} :",
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: emailError,
            builder: (_, errorMessage) {
              return TextField(
                onChanged: (_) {
                  emailError.setState(null);
                },
                controller: emailController,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintText: AppLocalizations.of(context)!.enter_your_email,
                  suffix: null,
                  suffixIcon: null,
                  isCollapsed: false,
                ),
              );
            },
          ),
          //-------------------------------------------------------------
          kHe24,
          ResText(
            "${AppLocalizations.of(context)!.password} :",
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: passwordError,
            builder: (_, errorMessage) {
              return BlocBuilder<ChannelCubit, dynamic>(
                bloc: _passwordVisibilityCubit,
                builder: (context, isVisible) {
                  return TextField(
                    onChanged: (value) {
                      passwordError.setState(null);
                    },
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      onlyEnglishLetters,
                    ],
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: AppLocalizations.of(context)!.enter_password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          (!isVisible)
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          _passwordVisibilityCubit.setState(!isVisible);
                        },
                      ),
                      isCollapsed: false,
                    ),
                  );
                },
              );
            },
          ),
          kHe24,
          ResText(
            AppLocalizations.of(context)!.repeat_password + " :",
            textStyle: Theme.of(context).textTheme.headline6,
          ),
          8.verticalSpace,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: repeatPasswordError,
            builder: (_, errorMessage) {
              return BlocBuilder<ChannelCubit, dynamic>(
                bloc: _repeatPasswordVisibleCubit,
                builder: (context, isVisible) {
                  return TextField(
                    onChanged: (_) {
                      repeatPasswordError.setState(null);
                    },
                    cursorColor: Theme.of(context).colorScheme.onBackground,
                    controller: repeatPasswordController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      onlyEnglishLetters,
                    ],
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText:
                          AppLocalizations.of(context)!.repeat_password_hint,
                      suffixIcon: IconButton(
                        icon: Icon(
                          (!isVisible)
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          _repeatPasswordVisibleCubit.setState(!isVisible);
                        },
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          kHe24,
          ResText(
            AppLocalizations.of(context)!.first_name + " :",
            textStyle: Theme.of(context).textTheme.headline6,
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
                  suffix: null,
                  suffixIcon: null,
                  isCollapsed: false,
                ),
              );
            },
          ),
          kHe24,
          ResText(
            AppLocalizations.of(context)!.last_name + " :",
            textStyle: Theme.of(context).textTheme.headline6,
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
                  isCollapsed: false,
                ),
              );
            },
          ),

          //buildEmailField
          // kHe24,
          // ResText(
          //   AppLocalizations.of(context)!.email + " :",
          //   textStyle: Theme.of(context).textTheme.headline6,
          // ),
          // kHe8,
          // BlocBuilder<ChannelCubit, dynamic>(
          //   bloc: emailError,
          //   builder: (_, errorMessage) {
          //     return TextField(
          //       onChanged: (_) {
          //         emailError.setState(null);
          //       },
          //       controller: emailController,
          //       decoration: InputDecoration(
          //         errorText: errorMessage,
          //         hintText: AppLocalizations.of(context)!.enter_your_email,
          //         isCollapsed: false,
          //       ),
          //     );
          //   },
          // ),

          BlocBuilder<ChannelCubit, dynamic>(
            bloc: userCountry,
            builder: (_, state) {
              List<Governorate> governorates = [];
              return state == "Syrian Arab Republic"
                  ? BlocBuilder<GovernoratesBloc, dynamic>(
                      bloc: governoratesBloc,
                      builder: (_, state) {
                        if (state is GovernoratesFetchComplete) {
                          governorates = state.governorates;
                        }
                        return Column(
                          children: [
                            kHe24,
                            Row(
                              children: [
                                ResText(
                                  AppLocalizations.of(context)!.governorate +
                                      " :",
                                  textStyle:
                                      Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            kHe8,
                            BlocBuilder<ChannelCubit, dynamic>(
                              bloc: countryError,
                              builder: (_, errorMessage) {
                                return MyDropdownList(
                                  elementsList: governorates.map((e) {
                                    return e.name;
                                  }).toList(),
                                  onSelect: (index) {
                                    selectedGovernorateId = index + 1;
                                  },
                                  validator: (value) => value == null
                                      ? AppLocalizations.of(context)!
                                          .this_field_is_required
                                      : null,
                                  selectedItem: AppLocalizations.of(context)!
                                      .please_select,
                                );
                                // return DropdownButtonFormField<Governorate>(
                                //   value: _ratingController,
                                //   items: governorates!
                                //       .map((label) => DropdownMenuItem(
                                //     child: Text(label.name),
                                //     value: label.name,
                                //   )).toList(),
                                //   hint: Text('Rating'),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       _ratingController = value;
                                //     });
                                //   },
                                // );
                              },
                            ),
                          ],
                        );
                      },
                    )
                  : const SizedBox.shrink();
            },
          ),
          kHe24,

          //build date of birth field
          // ResText(
          //   AppLocalizations.of(context)!.date_of_birth + " :",
          //   textStyle: Theme.of(context).textTheme.headline6,
          // ),
          // kHe8,
          // BlocBuilder<ChannelCubit, dynamic>(
          //   bloc: birthdateError,
          //   builder: (_, errorMessage) {
          //     return TextField(
          //       onTap: () async {
          //         await myDatePicker(
          //           context,
          //           showTitleActions: true,
          //           minTime: DateTime(1900, 1, 1),
          //           maxTime: DateTime.now(),
          //           onConfirm: (birthdate) {
          //             birthDate = birthdate;
          //             birthdateController.text =
          //                 DateFormat('yyyy/MM/dd').format(birthdate);
          //             print(birthDate);
          //             print(birthdateController.text);
          //             // birthDate = DateTime.parse(birthdateController.text);
          //             // print(birthDate);
          //           },
          //           currentTime: DateTime.now(),
          //           editingController: birthdateController,
          //         );
          //       },
          //       readOnly: true,
          //       controller: birthdateController,
          //       decoration: InputDecoration(
          //         errorText: errorMessage,
          //         hintText: AppLocalizations.of(context)!.enter_your_birth_date,
          //         isCollapsed: false,
          //       ),
          //     );
          //   },
          // ),
          //kHe24,
          BlocBuilder<ChannelCubit, dynamic>(
              bloc: _termsIsCheckedCubit,
              builder: (_, isChecked) {
                return Row(
                  children: [
                    Checkbox(
                      activeColor:
                          isDark ? AppColors.white : AppColors.primaryColor,
                      value: isChecked,
                      onChanged: (value) {
                        isCheck = value!;
                        _termsIsCheckedCubit.setState(!isChecked);
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TermsAndConditionsPage()));
                      },
                      child: Row(
                        children: [
                          ResText(
                            AppLocalizations.of(context)!
                                .accept_terms_condition,
                            textStyle: Theme.of(context).textTheme.subtitle2,
                          ),
                          ResText(
                            AppLocalizations.of(context)!.terms_condition,
                            textStyle: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
          //64.verticalSpace,
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
                      lastName: lastNameController.text,
                      // birthdate: birthdateController.text,
                      // //birthDate!,
                      email: emailController.text,
                      country: userCountry.state.toString(),
                      governorate: selectedGovernorateId,
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );
                UserSharedPreferences.setPhoneNumber(phoneNumber);
                ApplicationSharedPreferences.setLoginPassed(true);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          kHe16,
          TextButton(
            onPressed: () {
              _isLoginSelected.setState(true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResText(
                  AppLocalizations.of(context)!.already_have_an_account,
                  textStyle: Theme.of(context).textTheme.subtitle2,
                ),
                ResText(
                  "  " + AppLocalizations.of(context)!.sign_in,
                  textStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ScrollController scrollController = ScrollController();

  Future<bool> getFieldsValidation() async {
    bool isValidationSuccess = true;
    // phone number validate :
    try {
      final parsedPhoneNumber = await PhoneNumberUtil()
          .parse(phoneDialCode + authenticationController.text);
      phoneNumber = parsedPhoneNumber.international.replaceAll(" ", "");
    } catch (e) {
      scrollController.animateTo(1.h,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      authenticationError
          .setState(AppLocalizations.of(context)!.invalid_mobile_number);
      return false;
    }

    // passwords verification :
    if (passwordValidator1(passwordController.text, context) != null) {
      passwordError
          .setState(passwordValidator1(passwordController.text, context));
      scrollController.animateTo(100.h,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    } else if (confirmPasswordValidator1(
            passwordController.text, context, repeatPasswordController.text) !=
        null) {
      repeatPasswordError.setState(confirmPasswordValidator1(
          passwordController.text, context, repeatPasswordController.text));
      scrollController.animateTo(100.h,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    }
    passwordError.setState(null);
    repeatPasswordError.setState(null);

    // email verification
    // print(EmailValidator.validate(emailController.text));

    if (emailValidator(emailController.text, context) != null) {
      scrollController.animateTo(120.h,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      emailError.setState(emailValidator(emailController.text, context));
      return false;
    }
    emailError.setState(null);

    // terms_conditions verification
    if (!isCheck) {
      MySnackBar.show(
          context, AppLocalizations.of(context)!.accept_terms_conditions);
      return false;
    }

    // birthdate verification
    // if (birthdateController.text == "") {
    //   birthdateError.setState(AppLocalizations.of(context)!.invalid_birth_date);
    //   return false;
    // }
    // birthdateError.setState(null);

    return isValidationSuccess;
  }

  Future<bool> getFieldsValidationSignIn() async {
    bool isValidationSuccess = true;
    // phone number validate :
    try {
      final parsedPhoneNumber = await PhoneNumberUtil()
          .parse(phoneDialCodeLogin + authenticationControllerLogin.text);
      phoneNumber = parsedPhoneNumber.international.replaceAll(" ", "");
    } catch (e) {
      authenticationErrorLogin
          .setState(AppLocalizations.of(context)!.invalid_mobile_number);
      return false;
    }

    if (passwordValidator1(passwordControllerLogin.text, context) != null) {
      passwordErrorLogin
          .setState(passwordValidator1(passwordControllerLogin.text, context));
      scrollController.animateTo(100.h,
          duration: const Duration(seconds: 1), curve: Curves.ease);
      return false;
    }

    return isValidationSuccess;
  }

  double? latitude, longitude;

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // if (routeName != null) {
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (_) => const ContactListPage()));
      // }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
