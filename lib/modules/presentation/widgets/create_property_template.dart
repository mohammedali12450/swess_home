import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';

class CreatePropertyTemplate extends StatefulWidget {
  final String headerIconPath;
  final String headerText;
  final Widget body;

  const CreatePropertyTemplate(
      {Key? key, required this.headerIconPath, required this.headerText, required this.body})
      : super(key: key);

  @override
  _CreatePropertyTemplateState createState() => _CreatePropertyTemplateState();
}

class _CreatePropertyTemplateState extends State<CreatePropertyTemplate> {
  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0;
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: 1.sw,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: 1.sw,
                height: 400.h,
                decoration:  const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(flatImagePath),
                    fit: BoxFit.cover,
                    opacity: 0.24,
                  ),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(widget.headerIconPath),
                    24.verticalSpace,
                    Text(
                      widget.headerText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: (isKeyboardOpened) ? 0 : 330.h,
              child: Container(
                width: 1.sw,
                height: 1.sh - 330.h,
                padding: EdgeInsets.only(
                  right: 12.w,
                  left: 12.w,
                  bottom: 8.w,
                  // top: (isKeyboardOpened) ? 32.h : 16.h,
                ),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    color: Theme.of(context).colorScheme.background),
                child: widget.body,
              ),
            ),
            Positioned(
              top: 42.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                width: 1.sw,
                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 28.w,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
