import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class IconBadge extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final int itemCount;
  final bool hideZero;
  final Color badgeColor;
  final Color itemColor;
  final double top;
  final double right;
  final int maxCount;

  const IconBadge({
    Key? key,
    this.onTap,
    required this.icon,
    this.itemCount = 0,
    this.hideZero = false,
    this.badgeColor = Colors.red,
    this.itemColor = Colors.white,
    this.maxCount = 99,
    this.top = 3.0,
    this.right = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return itemCount == 0 && hideZero
        ? GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
              ],
            ),
          ],
        ),
      ),
    )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              width: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      icon,
                    ],
                  ),
                  Positioned(
                    top: top,
                    right: right,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: badgeColor,
                      child: Center(
                        child: itemCount > maxCount
                            ? Text('$maxCount+',
                                style: numberStyle.copyWith(color: itemColor))
                            : Text(
                                "$itemCount",
                                style: numberStyle.copyWith(color: itemColor),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

TextStyle numberStyle = GoogleFonts.abhayaLibre(
  fontSize: 9,
);
