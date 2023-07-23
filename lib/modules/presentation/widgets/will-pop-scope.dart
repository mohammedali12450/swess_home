import 'package:flutter/material.dart';

import '../screens/navigation_bar_screen.dart';

class BackHomeScreen extends StatelessWidget {
  Widget child;

  BackHomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationBarScreen()),
            (route) => false);
        return true;
      },
      child: child,
    );
  }
}
