import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  final Function()? onPress;
  final Color iconColor;
  final String iconClose;


  const CloseIcon({
    Key? key,
    required this.iconClose,
    required this.onPress,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Text(
        iconClose,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: iconColor,
          fontSize: 17,
        ),
      ),
    );
  }
}
