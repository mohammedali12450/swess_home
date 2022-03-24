import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/utils/helpers/responsive.dart';
import 'res_text.dart';

class CreatePropertyTemplate extends StatefulWidget {
  final String headerIconPath;
  final String headerText;
  final Widget body;

  const CreatePropertyTemplate(
      {Key? key,
      required this.headerIconPath,
      required this.headerText,
      required this.body})
      : super(key: key);

  @override
  _CreatePropertyTemplateState createState() => _CreatePropertyTemplateState();
}

class _CreatePropertyTemplateState extends State<CreatePropertyTemplate> {
  @override
  Widget build(BuildContext context) {


    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0 ;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: screenWidth,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: screenWidth,
                height: Res.height(400),
                decoration:  const BoxDecoration(
                  color: AppColors.black,
                  image: DecorationImage(
                    image: AssetImage(flatImagePath),
                    fit: BoxFit.cover,
                    opacity: 0.24,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(widget.headerIconPath),
                    kHe24,
                    ResText(
                      widget.headerText,
                      textStyle: textStyling(S.s24, W.w7, C.wh),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: (isKeyboardOpened)?0 : Res.height(330),
              child: Container(
                width: screenWidth,
                height: fullScreenHeight - Res.height(330),
                padding: EdgeInsets.only(
                   right: Res.width(kMediumPadding),
                   left: Res.width(kMediumPadding),
                   bottom: Res.height(kTinyPadding),
                   top: (isKeyboardOpened)?Res.height(kHugePadding):Res.height(kTinyPadding),
                    ),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: widget.body ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
