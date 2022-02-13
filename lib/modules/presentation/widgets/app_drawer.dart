import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'my_button.dart';
import 'res_text.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late UserLoginBloc _userLoginBloc;
  final ChannelCubit isLogoutLoadingCubit = ChannelCubit(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<UserLoginBloc, UserLoginState>(
          builder: (context, userLoginState) {
            User? user = BlocProvider.of<UserLoginBloc>(context).user;
            return Container(
              padding: kMediumSymWidth,
              alignment: Alignment.topCenter,
              height: Res.height(340),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [secondaryColor, lastColor],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
              child: (user == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: white),
                          child: Image.asset(
                            swessHomeIconPath,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        kHe12,
                        ResText(
                          "تسجيل الدخول",
                          textStyle: textStyling(S.s22, W.w6, C.wh),
                        ),
                        kHe8,
                        ResText(
                          "قم بتسجيل الدخول للاستفادة من ميزات التطبيق, وعرض عقارات مناسبة لطلبك!",
                          textStyle: textStyling(S.s14, W.w5, C.wh)
                              .copyWith(height: 1.8),
                          maxLines: 5,
                        ),
                        kHe12,
                        MyButton(
                          child: ResText(
                            "تسجيل الدخول",
                            textStyle: textStyling(S.s16, W.w5, C.c2),
                          ),
                          width: Res.width(180),
                          color: white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthenticationScreen(
                                  popAfterFinish: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        kHe24,
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: white),
                          child: Image.asset(
                            swessHomeIconPath,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        kHe12,
                        ResText(
                          user.userName,
                          textStyle: textStyling(S.s24, W.w6, C.wh),
                        ),
                        kHe4,
                        ResText(
                          user.authentication,
                          textStyle: textStyling(S.s18, W.w5, C.wh),
                        )
                      ],
                    ),
            );
          },
        ),
        RowInformation(
          content: "الطلبات العقارية المسبقة",
          iconData: Icons.history,
          onTap: () {},
        ),
        RowInformation(
          content: "العروض العقارية المنشأة",
          iconData: Icons.article_outlined,
          onTap: () {},
        ),
        RowInformation(
          content: "اتصل بنا",
          iconData: Icons.call_outlined,
          onTap: () {},
        ),
        RowInformation(
          content: "تقييم التطبيق",
          iconData: Icons.star_rate_outlined,
          onTap: () {},
        ),
        RowInformation(
          content: "مساعدة",
          iconData: Icons.error_outline,
          onTap: () {},
        ),
        BlocBuilder<UserLoginBloc, UserLoginState>(
          builder: (context, userLoginState) {
            User? user = BlocProvider.of<UserLoginBloc>(context).user;
            if (user != null) {
              return RowInformation(
                content: "تسجيل الخروج",
                iconData: Icons.logout,
                onTap: () async {
                  await showWonderfulAlertDialog(
                    context,
                    "تأكيد",
                    "هل تريد تسجيل الخروج؟",
                    removeDefaultButton: true,
                    width: Res.width(400),
                    dialogButtons: [
                      MyButton(
                        child: ResText(
                          "إلغاء",
                          textStyle: textStyling(S.s16, W.w5, C.wh)
                              .copyWith(height: 1.8),
                        ),
                        width: Res.width(140),
                        color: secondaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      MyButton(
                        child: BlocBuilder<ChannelCubit, dynamic>(
                            bloc: isLogoutLoadingCubit,
                            builder: (_, isLogoutLoading) {
                              return (isLogoutLoading)
                                  ? const SpinKitWave(
                                color: white,
                                size: 16,
                              )
                                  : ResText(
                                "تسجيل الخروج",
                                textStyle: textStyling(S.s16, W.w5, C.wh)
                                    .copyWith(height: 1.8),
                              );
                            }),
                        width: Res.width(140),
                        color: secondaryColor,
                        onPressed: () async {
                          isLogoutLoadingCubit.setState(true);
                          await _logout();
                          isLogoutLoadingCubit.setState(false);
                        },
                      ),
                    ],
                  );
                },
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Future _logout() async {
    UserAuthenticationRepository userRep = UserAuthenticationRepository();
    if (_userLoginBloc.user != null && _userLoginBloc.user!.token != null) {
      await userRep.logout(_userLoginBloc.user!.token!);
    }
    UserSharedPreferences.removeAccessToken();
    _userLoginBloc.user = null;
    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
    return;
  }
}

class RowInformation extends StatelessWidget {
  final IconData iconData;

  final String content;

  final Function() onTap;

  const RowInformation(
      {Key? key,
      required this.iconData,
      required this.content,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Res.width(16), vertical: Res.height(8)),
            margin: EdgeInsets.only(top: Res.height(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ResText(
                  content,
                  textAlign: TextAlign.right,
                  textStyle:
                      textStyling(S.s16, W.w6, C.bl).copyWith(height: 1.8),
                ),
                kWi8,
                Icon(
                  iconData,
                  size: Res.width(32),
                ),
                const Divider(
                  color: black,
                ),
              ],
            ),
          ),
          kHe12,
          const Divider(
            color: black,
            height: 1,
          ),
        ],
      ),
    );
  }
}
