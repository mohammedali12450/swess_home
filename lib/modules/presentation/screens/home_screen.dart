import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/create_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'office_search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApplicationSharedPreferences.setWalkThroughPassState(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          toolbarHeight: Res.height(75),
          centerTitle: true,
          title: ResText(
            "SwessHome",
            textStyle: textStyling(S.s24, W.w6, C.c1, fontFamily: F.roboto),
          ),
          leading: Container(
            margin: EdgeInsets.only(
              left: Res.width(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // TODO : process this state.
              },
            ),
          ),
          actions: [
            Builder(
              builder: (context) {
                return Container(
                  margin: EdgeInsets.only(
                    right: Res.width(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                );
              },
            )
          ],
        ),
        endDrawer: const Drawer(
          child: MyDrawer(),
        ),
        body: Container(
          padding: kSmallSymWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHomeScreenHeader(),
                kHe24,
                buildSearchCard(),
                kHe12,
                buildVacationCard(),
                kHe20,
                buildEstatePostingCard(),
                kHe20,
                buildEstateOrderCard(),
                kHe20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildEstatePostingCard() {
    return Container(
      width: inf,
      padding: kMediumAllPadding,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(color: black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: inf,
            child: ResText(
              "انشر عرضك العقاري",
              textStyle: textStyling(S.s18, W.w6, C.bl),
              textAlign: TextAlign.right,
            ),
          ),
          kHe12,
          SizedBox(
            width: inf,
            child: ResText(
              "!ابحث عن المكاتب العقارية المختلفة لنشر عروضك العقارية لديها",
              textStyle: textStyling(S.s15, W.w4, C.bl),
              textAlign: TextAlign.right,
            ),
          ),
          kHe16,
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, OfficeSearchScreen.id);
            },
            child: Container(
              width: inf,
              height: Res.height(64),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                border: Border.all(
                  color: black.withOpacity(0.56),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ResText(
                    "ابحث عن مكتب عقاري",
                    textStyle:
                        textStyling(S.s15, W.w5, C.hint).copyWith(height: 1.8),
                    textAlign: TextAlign.right,
                  ),
                  kWi12,
                  Transform.rotate(
                    angle: 1.5,
                    child: const Icon(
                      Icons.search,
                      size: 24,
                      color: black,
                    ),
                  ),
                  kWi12,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack buildVacationCard() {
    return Stack(
      children: [
        Container(
          width: screenWidth,
          padding: EdgeInsets.symmetric(
              horizontal: Res.width(16), vertical: Res.height(24)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [lastColor, lastColor.withOpacity(0.75)],
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            image: const DecorationImage(
                image: AssetImage(beachImagePath),
                fit: BoxFit.cover,
                opacity: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: 1.5,
                child: const Icon(
                  Icons.search,
                  size: 28,
                  color: white,
                ),
              ),
              kHe12,
              ResText(
                "المزارع والاصطياف",
                textStyle: textStyling(S.s20, W.w5, C.wh),
              ),
              kHe12,
              ResText(
                "! قم بتصفح عقارات الاصطياف محجزها من داخل بيتك",
                textStyle: textStyling(S.s14, W.w5, C.wh),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: Res.width(16),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Column buildHomeScreenHeader() {
    return Column(
      children: [
        SizedBox(
          width: inf,
          child: ResText(
            '!مساء الخير',
            textAlign: TextAlign.right,
            textStyle: textStyling(S.s14, W.w5, C.hint),
          ),
        ),
        kHe8,
        SizedBox(
          width: inf,
          child: ResText(
            '! swess home أهلا بكم في',
            textAlign: TextAlign.right,
            textStyle: textStyling(S.s16, W.w5, C.bl),
          ),
        ),
        kHe16,
        SizedBox(
          width: inf,
          child: ResText(
            homeScreenHeader,
            textAlign: TextAlign.right,
            textStyle: textStyling(S.s15, W.w5, C.hint),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Container buildSearchCard() {
    return Container(
      width: screenWidth,
      padding: kLargeSymHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [secondaryColor, secondaryColor.withOpacity(0.75)],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        image: const DecorationImage(
            image: AssetImage(flatImagePath), fit: BoxFit.cover, opacity: 0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ResText(
                "العروض العقارية",
                textStyle: textStyling(S.s18, W.w6, C.wh),
              ),
              kWi16,
              Transform.rotate(
                angle: 1.5,
                child: const Icon(
                  Icons.search,
                  size: 28,
                  color: white,
                ),
              ),
            ],
          ),
          kHe12,
          ResText(
            ".. ابحث في العروض العقارية المتنوعة بيوت, محلات, أراضي",
            textStyle: textStyling(S.s14, W.w5, C.wh),
          ),
          kHe32,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                borderRadius: 8,
                child: ResText(
                  "إيجار",
                  textStyle: textStyling(S.s16, W.w5, C.c2),
                ),
                color: white,
                height: Res.height(56),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(
                        searchData:
                            SearchData(estateOfferTypeId: rentOfferTypeNumber),
                      ),
                    ),
                  );
                },
              ),
              kWi16,
              MyButton(
                borderRadius: 8,
                child: ResText(
                  "بيع",
                  textStyle: textStyling(S.s16, W.w5, C.c2),
                ),
                color: white,
                height: Res.height(56),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(
                        searchData:
                            SearchData(estateOfferTypeId: sellOfferTypeNumber),
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildEstateOrderCard() {
    return Container(
      width: inf,
      padding: kSmallSymWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(color: black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kHe12,
          SizedBox(
            width: inf,
            child: ResText(
              "الطلبات العقارية",
              textStyle: textStyling(S.s18, W.w5, C.bl),
              textAlign: TextAlign.right,
            ),
          ),
          kHe12,
          SizedBox(
            width: inf,
            child: ResText(
              "أرسل لنا معلومات عن العقار الذي تبحث عنه في حال لم تجد عقارات مناسبة",
              textStyle: textStyling(S.s14, W.w4, C.bl),
              textAlign: TextAlign.right,
              maxLines: 2,
            ),
          ),
          kHe16,
          Container(
            width: inf,
            alignment: Alignment.centerRight,
            child: MyButton(
              color: secondaryColor,
              height: Res.height(56),
              width: Res.width(180),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kWi12,
                  ResText(
                    "إنشاء طلب عقاري",
                    textStyle: textStyling(S.s16, W.w5, C.wh),
                  ),
                  kWi12,
                  const Icon(
                    Icons.add,
                    color: white,
                  ),
                ],
              ),
              onPressed: () async {
                if (BlocProvider.of<UserLoginBloc>(context).user == null) {
                  await showWonderfulAlertDialog(
                      context, "تأكيد", "إن هذه الميزة تتطلب تسجيل الدخول",
                      removeDefaultButton: true,
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
                          child: ResText(
                            "تسجيل الدخول",
                            textStyle: textStyling(S.s16, W.w5, C.wh)
                                .copyWith(height: 1.8),
                          ),
                          width: Res.width(140),
                          color: secondaryColor,
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, AuthenticationScreen.id);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                      width: Res.width(400));
                  return;
                }
                Navigator.pushNamed(context, CreateOrderScreen.id);
              },
            ),
          )
        ],
      ),
    );
  }
}
