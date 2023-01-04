import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/message_bloc/message_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/message_bloc/message_state.dart';
import 'package:swesshome/modules/data/models/message.dart';
import 'package:swesshome/modules/presentation/screens/create_message_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/notifications_shimmer.dart';
import '../../../constants/assets_paths.dart';
import '../../business_logic_components/bloc/message_bloc/message_bloc.dart';
import '../../data/repositories/send_message_repository.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(MessageRepository());
    _onRefresh();
    print(UserSharedPreferences.getAccessToken());
    super.initState();
  }

  _onRefresh() {
    _messageBloc.add(
        GetMessagesFetchStarted(token: UserSharedPreferences.getAccessToken()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chat),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          _onRefresh();
        },
        child: UserSharedPreferences.getAccessToken() != null
            ? buildChatList()
            : buildRequiredLogin(),
      ),
      floatingActionButton: UserSharedPreferences.getAccessToken() == null
          ? Container()
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
              child: GestureDetector(
                child: Card(
                  color: AppColors.primaryColor,
                  elevation: 4,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: AppColors.yellowColor,
                      width: 2,
                    ),
                  ),
                  child: Container(
                    width: 75.w,
                    alignment: Alignment.center,
                    height: 75.h,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateMessageScreen(),
                    ),
                  );
                },
              ),
            ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      drawer: const Drawer(child: MyDrawer()),
    );
  }

  Widget buildChatList() {
    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _messageBloc,
      builder: (_, state) {
        List<Message> messages = [];
        if (state is GetMessageFetchProgress) {
          return const NotificationsShimmer();
        }
        if (state is GetMessageFetchComplete) {
          messages = state.messages;
        }
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (_, index) {
            return MessageCard(
              message: messages.elementAt(index),
            );
          },
        );
      },
    );
  }

  Widget buildRequiredLogin() {
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
