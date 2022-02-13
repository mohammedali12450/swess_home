import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_register_bloc/user_register_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/my_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'home_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  static const String id = "AuthenticationScreen";

  final bool? popAfterFinish ;

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

  // controllers:
  TextEditingController authenticationController = TextEditingController();
  TextEditingController authenticationControllerLogin = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRegisterBloc = UserRegisterBloc(UserAuthenticationRepository());
    userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
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
      authenticationErrorLogin
          .setState(errorResponseMap["authentication"].first);
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
                if (registerState.errorResponse != null) {
                  signUpErrorHandling(registerState.errorResponse);
                } else if (registerState.errorMessage != null) {
                  showMyAlertDialog(
                    "خطأ",
                    registerState.errorMessage!,
                    context,
                    actions: [
                      DialogAction(
                        content: "تم",
                        onPressed: (context) {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                }
              }
              if (registerState is UserRegisterComplete) {
                BlocProvider.of<UserLoginBloc>(context).user =
                    registerState.user;
                // save user token in shared preferences ;
                if (registerState.user.token != null) {
                  UserSharedPreferences.setAccessToken(
                      registerState.user.token!);
                }
                if(widget.popAfterFinish!){
                  Navigator.pop(context) ;
                }else{
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false);
                }
              }
            },
          ),
          BlocListener<UserLoginBloc, UserLoginState>(
            listener: (_, loginState) {
              if (loginState is UserLoginError) {
                if (loginState.errorResponse != null) {
                  loginErrorHandling(loginState.errorResponse);
                } else if (loginState.errorMessage != null) {
                  showMyAlertDialog(
                    "خطأ",
                    loginState.errorMessage!,
                    context,
                    actions: [
                      DialogAction(
                        content: "تم",
                        onPressed: (context) {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                }
              }
              if (loginState is UserLoginComplete) {
                if(widget.popAfterFinish!){
                  Navigator.pop(context) ;
                }else{
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false);
                }
              }
            },
          ),
        ],
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: black,
            body: Stack(
              children: [
                Builder(
                  builder: (context) => Container(
                    alignment: Alignment.center,
                    width: screenWidth,
                    height: fullScreenHeight,
                    padding: kSmallSymWidth,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(introBackGroundImg5Path),
                          fit: BoxFit.cover,
                          opacity: 0.2),
                    ),
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
                    icon: const Icon(
                      Icons.close,
                      color: white,
                    ),
                    onPressed: () {
                      if(widget.popAfterFinish!){
                        Navigator.pop(context);
                      }
                      else{
                        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false) ;
                      }
                    },
                  ),
                )
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // (isKeyboardOpened)
          //     ? SizedBox(
          //         height: Res.height(50),
          //       )
          //     : SizedBox(
          //   height: Res.height(150),
          // ),
          ResText(
            "تسجيل الدخول",
            textStyle: textStyling(S.s36, W.w6, C.wh),
          ),

          SizedBox(
            height: Res.height(72),
          ),

          SizedBox(
            width: inf,
            child: ResText(
              ":الإيميل أو رقم الموبايل",
              textStyle: textStyling(S.s16, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: authenticationErrorLogin,
            builder: (_, errorMessage) {
              return TextField(
                onChanged: (_) {
                  authenticationErrorLogin.setState(null);
                },
                controller: authenticationControllerLogin,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText: 'أدخل الإيميل أو رقم الموبايل',
                    hintStyle: textStyling(S.s14, W.w5, C.hint),
                    hintTextDirection: TextDirection.rtl,
                    contentPadding: kSmallSymWidth,
                    errorBorder: kOutlinedBorderRed,
                    focusedBorder: kOutlinedBorderBlack,
                    enabledBorder: kOutlinedBorderGrey,
                    suffixIcon: const Icon(
                      Icons.person_outline,
                      color: secondaryColor,
                    ),
                    filled: true,
                    fillColor: white),
              );
            },
          ),
          kHe16,
          SizedBox(
            width: inf,
            child: ResText(
              ":كلمة المرور",
              textStyle: textStyling(S.s16, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: passwordErrorLogin,
            builder: (_, errorMessage) {
              return BlocBuilder<ChannelCubit, dynamic>(
                bloc: _passwordVisibilityCubit,
                builder: (context, isVisible) {
                  return TextField(
                    onChanged: (_) {
                      passwordErrorLogin.setState(null);
                    },
                    controller: passwordControllerLogin,
                    keyboardType: TextInputType.text,
                    textDirection: TextDirection.rtl,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                        errorText: errorMessage,
                        hintText: 'أدخل كلمة المرور',
                        hintStyle: textStyling(S.s14, W.w5, C.hint),
                        hintTextDirection: TextDirection.rtl,
                        contentPadding: kSmallSymWidth,
                        errorBorder: kOutlinedBorderRed,
                        focusedBorder: kOutlinedBorderBlack,
                        enabledBorder: kOutlinedBorderGrey,
                        suffixIcon: const Icon(
                          Icons.lock_outline,
                          color: secondaryColor,
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            (isVisible)
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: black,
                          ),
                          onPressed: () {
                            _passwordVisibilityCubit.setState(!isVisible);
                          },
                        ),
                        filled: true,
                        fillColor: white),
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ResText(
                "تذكر الحساب",
                textStyle: textStyling(S.s16, W.w5, C.wh),
              ),
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: _checkBoxStateCubit,
                builder: (_, isChecked) {
                  return Checkbox(
                      value: isChecked,
                      fillColor: MaterialStateProperty.all<Color>(Colors.white),
                      checkColor: secondaryColor,
                      onChanged: (_) {
                        _checkBoxStateCubit.setState(!isChecked);
                      });
                },
              ),
            ],
          ),
          kHe24,
          MyButton(
            child: BlocBuilder<UserLoginBloc, UserLoginState>(
              builder: (_, loginState) {
                if (loginState is UserLoginProgress) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpinKitWave(
                        color: secondaryColor,
                        size: 20,
                      ),
                      kWi16,
                      ResText(
                        "جاري تسجيل الدخول",
                        textStyle: textStyling(S.s20, W.w6, C.c2),
                      )
                    ],
                  );
                }
                return ResText(
                  "تسجيل الدخول",
                  textStyle: textStyling(S.s20, W.w5, C.c2),
                );
              },
            ),
            width: Res.width(250),
            height: Res.height(64),
            color: white,
            onPressed: () {
              userLoginBloc.add(UserLoginStarted(
                  authentication: authenticationControllerLogin.text,
                  password: passwordControllerLogin.text));
            },
            borderRadius: 8,
            shadow: [
              BoxShadow(
                  color: white.withOpacity(0.15),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                  spreadRadius: 3),
            ],
          ),
          kHe16,
          MyButton(
            child: ResText(
              "إنشاء حساب",
              textStyle: textStyling(S.s20, W.w5, C.wh),
            ),
            width: Res.width(250),
            height: Res.height(64),
            color: Colors.transparent,
            border: Border.all(color: white),
            onPressed: () {
              _isLoginSelected.setState(false);
            },
            borderRadius: 8,
          ),
          // SizedBox(
          //   height: Res.height(75),
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //         flex: 4,
          //         child: Divider(
          //           color: white,
          //           thickness: 1,
          //         )),
          //     Expanded(
          //         flex: 1,
          //         child: ResText(
          //           "أو",
          //           textStyle: textStyling(S.s16, W.w5, C.wh),
          //         )),
          //     Expanded(
          //         flex: 4,
          //         child: Divider(
          //           color: white,
          //           thickness: 1,
          //         )),
          //   ],
          // ),
          // kHe32,
          // Container(
          //   width: Res.width(300),
          //   height: Res.height(48),
          //   decoration: BoxDecoration(
          //     color: white,
          //     borderRadius: BorderRadius.circular(16),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SvgPicture.asset(googleLogoPath),
          //       kWi8,
          //       ResText(
          //         "دخول بواسطة غوغل",
          //         textStyle: textStyling(S.s16, W.w5, C.bl),
          //       )
          //     ],
          //   ),
          // ),
          // kHe8,
          // Container(
          //   width: Res.width(300),
          //   height: Res.height(48),
          //   decoration: BoxDecoration(
          //       color: Colors.transparent,
          //       borderRadius: BorderRadius.circular(16),
          //       border: Border.all(color: white)),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SvgPicture.asset(facebookLogoPath),
          //       kWi8,
          //       ResText(
          //         "دخول بواسطة فيسبوك",
          //         textStyle: textStyling(S.s16, W.w5, C.wh),
          //       )
          //     ],
          //   ),
          // ),
          // kHe16,
        ],
      ),
    );
  }

  SingleChildScrollView buildSignupScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ResText(
            "إنشاء حساب",
            textStyle: textStyling(S.s36, W.w6, C.wh),
          ),
          kHe40,
          SizedBox(
            width: inf,
            child: ResText(
              ":الإيميل أو رقم الموبايل",
              textStyle: textStyling(S.s16, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: authenticationError,
            builder: (_, errorMessage) {
              return TextField(
                onChanged: (_) {
                  authenticationError.setState(null);
                },
                controller: authenticationController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText: 'أدخل الإيميل أو رقم الموبايل',
                    hintStyle: textStyling(S.s14, W.w5, C.hint),
                    hintTextDirection: TextDirection.rtl,
                    contentPadding: kSmallSymWidth,
                    errorBorder: kOutlinedBorderRed,
                    focusedBorder: kOutlinedBorderBlack,
                    enabledBorder: kOutlinedBorderGrey,
                    suffixIcon: const Icon(
                      Icons.person_outline,
                      color: secondaryColor,
                    ),
                    filled: true,
                    fillColor: white),
              );
            },
          ),
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":كلمة المرور",
              textStyle: textStyling(S.s16, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
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
                    textDirection: TextDirection.rtl,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                        errorText: errorMessage,
                        hintText: 'أدخل كلمة المرور',
                        hintStyle: textStyling(S.s14, W.w5, C.hint),
                        hintTextDirection: TextDirection.rtl,
                        contentPadding: kSmallSymWidth,
                        errorBorder: kOutlinedBorderRed,
                        focusedBorder: kOutlinedBorderBlack,
                        enabledBorder: kOutlinedBorderGrey,
                        suffixIcon: const Icon(
                          Icons.lock_outline,
                          color: secondaryColor,
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            (isVisible)
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: black,
                          ),
                          onPressed: () {
                            _passwordVisibilityCubit.setState(!isVisible);
                          },
                        ),
                        filled: true,
                        fillColor: white),
                  );
                },
              );
            },
          ),
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":الإسم الأول",
              textStyle: textStyling(S.s16, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: firstNameError,
            builder: (_, errorMessage) {
              return TextField(
                onChanged: (_) {
                  firstNameError.setState(null);
                },
                textDirection: TextDirection.rtl,
                controller: firstNameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText: 'أدخل اسمك الأول',
                    hintStyle: textStyling(S.s14, W.w5, C.hint),
                    hintTextDirection: TextDirection.rtl,
                    contentPadding: kSmallSymWidth,
                    errorBorder: kOutlinedBorderRed,
                    focusedBorder: kOutlinedBorderBlack,
                    enabledBorder: kOutlinedBorderGrey,
                    suffixIcon: const Icon(
                      Icons.person_outline,
                      color: secondaryColor,
                    ),
                    filled: true,
                    fillColor: white),
              );
            },
          ),
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":الإسم الأخير",
              textStyle: textStyling(S.s16, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          kHe8,
          BlocBuilder<ChannelCubit, dynamic>(
            bloc: lastNameError,
            builder: (_, errorMessage) {
              return TextField(
                onChanged: (_) {
                  lastNameError.setState(null);
                },
                textDirection: TextDirection.rtl,
                controller: lastNameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText: 'أدخل اسم العائلة',
                    hintStyle: textStyling(S.s14, W.w5, C.hint),
                    hintTextDirection: TextDirection.rtl,
                    contentPadding: kSmallSymWidth,
                    errorBorder: kOutlinedBorderRed,
                    focusedBorder: kOutlinedBorderBlack,
                    enabledBorder: kOutlinedBorderGrey,
                    suffixIcon: const Icon(
                      Icons.person_outline,
                      color: secondaryColor,
                    ),
                    filled: true,
                    fillColor: white),
              );
            },
          ),
          SizedBox(
            height: Res.height(64),
          ),
          MyButton(
            child: BlocBuilder<UserRegisterBloc, UserRegisterState>(
              bloc: userRegisterBloc,
              builder: (_, registerState) {
                if (registerState is UserRegisterProgress) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpinKitWave(
                        color: secondaryColor,
                        size: 20,
                      ),
                      kWi16,
                      ResText(
                        "جاري إنشاء الحساب",
                        textStyle: textStyling(S.s20, W.w6, C.c2),
                      )
                    ],
                  );
                }
                return ResText(
                  "إنشاء الحساب",
                  textStyle: textStyling(S.s20, W.w5, C.c2),
                );
              },
            ),
            width: Res.width(260),
            height: Res.height(64),
            color: white,
            onPressed: () {
              userRegisterBloc.add(
                UserRegisterStarted(
                  register: Register(
                      authentication: authenticationController.text,
                      password: authenticationController.text,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text),
                ),
              );
            },
            borderRadius: 8,
            shadow: [
              BoxShadow(
                  color: white.withOpacity(0.15),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                  spreadRadius: 3),
            ],
          ),
          kHe16,
          MyButton(
            child: ResText(
              "تسجيل الدخول",
              textStyle: textStyling(S.s20, W.w5, C.wh),
            ),
            width: Res.width(250),
            height: Res.height(64),
            color: Colors.transparent,
            border: Border.all(color: white),
            onPressed: () {
              _isLoginSelected.setState(true);
            },
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}
