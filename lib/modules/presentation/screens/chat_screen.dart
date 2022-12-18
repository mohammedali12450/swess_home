import 'package:flutter/material.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
      drawer: const Drawer(child: MyDrawer()),
    );
  }
}
