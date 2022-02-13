import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/texts.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class AfterEstateOrderScreen extends StatefulWidget {
  static const String id = "AfterEstateOrderScreen";

  const AfterEstateOrderScreen({Key? key}) : super(key: key);

  @override
  _AfterEstateOrderScreenState createState() => _AfterEstateOrderScreenState();
}

class _AfterEstateOrderScreenState extends State<AfterEstateOrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: Res.height(75),
          backgroundColor: secondaryColor,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: Res.width(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ),
          ],
          title: SizedBox(
            width: inf,
            child: ResText(
              "إنشاء طلب عقاري",
              textStyle: textStyling(S.s18, W.w5, C.wh),
              textAlign: TextAlign.right,
            ),
          ),
          leading: Container(
            margin: EdgeInsets.only(
              left: Res.width(16),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.history,
                color: white,
              ),
              onPressed: () {},
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: SvgPicture.asset(checkOutlineIconPath,
                    color: secondaryColor),
              ),
              kHe32,
              ResText(
                "تم إرسال الطلب",
                textStyle: textStyling(S.s24, W.w7, C.c2),
                textAlign: TextAlign.center,
                maxLines: 50,
              ),
              kHe24,
              ResText(
                afterEstateOrderBody,
                textStyle: textStyling(S.s18, W.w6, C.bl).copyWith(height: 2.5),
                textAlign: TextAlign.center,
                maxLines: 50,
              ),
              kHe40,
              MyButton(
                child: ResText(
                  "تم",
                  textStyle: textStyling(S.s20, W.w6, C.wh),
                ),
                width: Res.width(200),
                color: secondaryColor,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomeScreen.id,
                    ModalRoute.withName('/'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
