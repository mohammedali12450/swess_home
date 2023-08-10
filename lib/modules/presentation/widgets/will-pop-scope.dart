import 'package:flutter/material.dart';

import '../screens/navigation_bar_screen.dart';

// ignore: must_be_immutable
class BackHomeScreen extends StatelessWidget {
  Widget child;

  BackHomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => NavigationBarScreen()),
            (route) => false);
        return true;
      },
      child: child,
    );
  }
}
