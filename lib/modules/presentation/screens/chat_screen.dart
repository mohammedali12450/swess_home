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
import '../../../constants/design_constants.dart';
import '../../../core/functions/screen_informations.dart';
import '../../business_logic_components/bloc/message_bloc/message_bloc.dart';
import '../../data/repositories/send_message_repository.dart';
import '../widgets/message_card.dart';
import '../widgets/res_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late MessageBloc _messageBloc;
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool isEstatesFinished = false;

  @override
  void initState() {
    _messageBloc = MessageBloc(MessageRepository());
    if (UserSharedPreferences.getAccessToken() != null) {
      _onRefresh();
    }
    super.initState();
  }

  _onRefresh() {
    _messageBloc.page = 1;
    messages.clear();
    _messageBloc.add(
        GetMessagesFetchStarted(token: UserSharedPreferences.getAccessToken()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.chat),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          if (UserSharedPreferences.getAccessToken() != null) {
            _onRefresh();
          }
        },
        child: UserSharedPreferences.getAccessToken() != null
            ? buildChatList()
            : buildRequiredLogin(),
      ),
      floatingActionButton: UserSharedPreferences.getAccessToken() == null
          ? Container()
          : Padding(
              padding: kTinyAllPadding,
              child: GestureDetector(
                child: Card(
                  color: AppColors.primaryColor,
                  elevation: 4,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: AppColors.yellowColor,
                      width: 2.w,
                    ),
                  ),
                  child: Container(
                    width: 75.w,
                    alignment: Alignment.center,
                    height: 75.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  final bool value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateMessageScreen(),
                    ),
                  );
                  if (value) {
                    await _onRefresh();
                  }
                },
              ),
            ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      drawer: SizedBox(
        width: getScreenWidth(context) * (75/100),
        child: const Drawer(
          child: MyDrawer(),
        ),
      ),
    );
  }

  Widget buildChatList() {
    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _messageBloc,
      builder: (_, state) {
        if (state is MessageFetchNone ||
            (state is GetMessageFetchProgress && messages.isEmpty)) {
          return const NotificationsShimmer();
        }
        if (state is GetMessageFetchComplete) {
          messages.addAll(state.messages);
          _messageBloc.isFetching = false;
          if (state.messages.isEmpty && messages.isNotEmpty) {
            isEstatesFinished = true;
          }
        }

        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_outlined,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.24),
                  size: 120.w,
                ),
                kHe24,
                ResText(
                  AppLocalizations.of(context)!.no_message,
                  textStyle: Theme.of(context).textTheme.headline5!.copyWith(
                    color: AppColors.primaryColor
                  ),
                ),
                kHe40,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(220.w, 64.h),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.contact_us,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CreateMessageScreen()));
                  },
                )
              ],
            ),
          );
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: ListView.builder(
            controller: _scrollController
              ..addListener(
                () {
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      !_messageBloc.isFetching &&
                      !isEstatesFinished) {
                    _messageBloc
                      ..isFetching = true
                      ..add(GetMessagesFetchStarted(
                          token: UserSharedPreferences.getAccessToken()));
                  }
                },
              ),
            shrinkWrap: true,
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (_, index) {
              return MessageCard(
                message: messages.elementAt(index),
              );
            },
          ),
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
