import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/presentation/screens/create_message_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/assets_paths.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chat),
      ),
      body: UserSharedPreferences.getAccessToken() != null
          ? Container()
          : buildRequiredLogin(context),
      floatingActionButton: UserSharedPreferences.getAccessToken() == null
          ? Container()
          : FloatingActionButton(
              heroTag: "btn1",
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateMessageScreen(),
                  ),
                );
              },
            ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      drawer: const Drawer(child: MyDrawer()),
    );
  }

  Widget buildRequiredLogin(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            needLoginPath,
          ),
          Text(
            "\n${AppLocalizations.of(context)!.this_features_require_login}",
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
