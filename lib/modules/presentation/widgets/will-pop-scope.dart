import 'package:flutter/material.dart';

import '../screens/navigation_bar_screen.dart';

// ignore: must_be_immutable
class WillPopWidget extends StatelessWidget {
  Widget child;
  int? pageNumber = 0;

  WillPopWidget({super.key,this.pageNumber, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => NavigationBarScreen(pageNumber: pageNumber)),);
        return true;
      },
      child: child,
    );
  }
}
