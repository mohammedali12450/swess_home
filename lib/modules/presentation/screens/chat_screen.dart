import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/message_bloc/message_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/message_bloc/message_state.dart';
import 'package:swesshome/modules/data/models/message.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/notifications_shimmer.dart';

import '../../../constants/assets_paths.dart';
import '../../../constants/design_constants.dart';
import '../../../core/functions/screen_informations.dart';
import '../../business_logic_components/bloc/message_bloc/message_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
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
  TextEditingController messageController = TextEditingController();
  ChannelCubit messageCubit = ChannelCubit("");
  List<Message> messages = [];
  bool isEstatesFinished = false;
  late bool isArabic;
  late bool isDark;
  ChannelCubit emojiShowing = ChannelCubit(false);

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
    _messageBloc.add(GetMessagesFetchStarted(token: UserSharedPreferences.getAccessToken()));
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return WillPopScope(
      onWillPop: () async {
        if (emojiShowing.state) {
          emojiShowing.setState(false);
          return false;
        }
        return true;
      },
      child: Scaffold(
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
          child: Stack(
            children: [
              UserSharedPreferences.getAccessToken() != null ? buildChatList() : buildRequiredLogin(),
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: emojiShowing,
                builder: (_, emojiState) {
                  return SizedBox(
                    height: 1.sh,
                    child: Column(
                      children: [
                        const Spacer(),
                        buildChatContainer(),
                        SizedBox(
                          height: emojiState ? 200 : 2,
                          child: Offstage(
                            offstage: !emojiState,
                            child: SizedBox(
                              // height: 150,
                              child: EmojiPicker(
                                onEmojiSelected: (category, emoji) async {
                                  messageController.text = messageController.text + emoji.emoji;
                                  // await controller.sendMessage();
                                },
                                //onBackspacePressed: () {},
                                config: Config(
                                    emojiSizeMax: 30,
                                    columns: 9,
                                    verticalSpacing: 0,
                                    horizontalSpacing: 0,
                                    initCategory: Category.SMILEYS,
                                    bgColor: isDark ? AppColors.primaryColor : AppColors.white,
                                    indicatorColor: Theme.of(context).primaryColor,
                                    iconColor: Theme.of(context).unselectedWidgetColor,
                                    iconColorSelected: Theme.of(context).primaryColor,
                                    /*progressIndicatorColor:
                                        Theme.of(context).primaryColor,*/
                                    showRecentsTab: true,
                                    recentsLimit: 28,
                                    tabIndicatorAnimDuration: kTabScrollDuration,
                                    categoryIcons: const CategoryIcons(),
                                    buttonMode: ButtonMode.MATERIAL),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // floatingActionButton: UserSharedPreferences.getAccessToken() == null
        //     ? Container()
        //     : buildChatContainer(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: SizedBox(
          width: getScreenWidth(context) * (75 / 100),
          child: const Drawer(
            child: MyDrawer(),
          ),
        ),
      ),
    );
  }

  Widget buildChatList() {
    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _messageBloc,
      builder: (_, state) {
        if (state is MessageFetchNone || (state is GetMessageFetchProgress && messages.isEmpty)) {
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.24),
                  size: 120.w,
                ),
                kHe24,
                ResText(
                  AppLocalizations.of(context)!.no_message,
                  textStyle: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.primaryColor),
                ),
                kHe40,
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     fixedSize: Size(220.w, 64.h),
                //   ),
                //   child: Text(
                //     AppLocalizations.of(context)!.contact_us,
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (_) => const CreateMessageScreen()));
                //   },
                // )
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
                  if (_scrollController.offset == _scrollController.position.maxScrollExtent && !_messageBloc.isFetching && !isEstatesFinished) {
                    _messageBloc
                      ..isFetching = true
                      ..add(GetMessagesFetchStarted(token: UserSharedPreferences.getAccessToken()));
                  }
                },
              ),
            shrinkWrap: true,
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 65.h),
                child: MessageCard(
                  message: messages.elementAt(index),
                ),
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

  Widget buildChatContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor, borderRadius: smallBorderRadius),
        width: 1.sw,
        //height: 50.h,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.only(left: isArabic ? 0 : 8.w, right: isArabic ? 8.w : 0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: smallBorderRadius,
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  maxLines: 4,
                  minLines: 1,
                  controller: messageController,
                  decoration: InputDecoration(
                    //isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.message_notes_descriptions,
                    prefixIcon: IconButton(
                      onPressed: () {
                        emojiShowing.setState(!emojiShowing.state);
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: isDark ? Colors.white : AppColors.primaryColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    print(messageController.text);
                  },
                  onChanged: (vale) {
                    print(messageController.text);
                    messageCubit.setState(messageController.text);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _messageBloc.add(SendMessagesFetchStarted(
                        token: UserSharedPreferences.getAccessToken(),
                        message: messageCubit.state,
                      ));
                      FocusScope.of(context).unfocus();
                    },
                    icon: BlocConsumer<MessageBloc, MessageState>(
                      bloc: _messageBloc,
                      listener: (_, messageState) {
                        if (messageState is SendMessageFetchComplete) {
                          Fluttertoast.showToast(msg: AppLocalizations.of(context)!.complete_send, toastLength: Toast.LENGTH_LONG);
                          messageController.clear();
                          _onRefresh();
                          //Navigator.pop(context, true);
                        }
                      },
                      builder: (_, messageState) {
                        return Icon(
                          Icons.send,
                          color: isDark ? Colors.white : AppColors.primaryColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
