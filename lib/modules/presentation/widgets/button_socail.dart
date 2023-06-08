import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swesshome/constants/colors.dart';

class ButtonSocail extends StatefulWidget {
  const ButtonSocail({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.onPress,
  }) : super(key: key);

  final String text;
  final String iconPath;
  final Function() onPress;

  @override
  State<ButtonSocail> createState() => _ButtonSocailState();
}

class _ButtonSocailState extends State<ButtonSocail> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 5.h,
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: AppColors.primaryColor.withOpacity(0.25),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      onPressed: () async {
        isLoading.value = true;
        await widget.onPress();
        isLoading.value = false;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) => value
            ? SpinKitWave(
                color: AppColors.primaryColor,
                size: 20.w,
              )
            : child!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Image.asset(widget.iconPath),
          ],
        ),
      ),
    );
  }
}
