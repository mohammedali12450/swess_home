import 'package:flutter/material.dart';

import '../screens/navigation_bar_screen.dart';

// ignore: must_be_immutable
class WillPopWidget extends StatelessWidget {
  Widget child;
  int? pageNumber = 0;

  WillPopWidget({super.key, this.pageNumber, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => NavigationBarScreen(pageNumber: pageNumber,)),
            (route) => false);
        return true;
      },
      child: child,
    );
  }
}
