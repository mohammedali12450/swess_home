import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/business_logic_components/bloc/message_bloc/message_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/message_bloc/message_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/repositories/send_message_repository.dart';

import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/message_bloc/message_bloc.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_bloc.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_event.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_state.dart';
import '../../data/models/user.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/user_authentication_repository.dart';
import '../widgets/fetch_result.dart';
import '../widgets/res_text.dart';
import '../widgets/shimmers/details_shimmer.dart';

class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({Key? key}) : super(key: key);

  @override
  State<CreateMessageScreen> createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  TextEditingController messageController = TextEditingController();
  ChannelCubit messageCubit = ChannelCubit("");

  late UserDataBloc _userDataBloc;
  late MessageBloc _messageBloc;
  User? user;
  late bool isArabic;
  late bool isDark;

  @override
  void initState() {
    super.initState();

    _userDataBloc = UserDataBloc(UserAuthenticationRepository());
    _userDataBloc.add(
      UserDataStarted(token: UserSharedPreferences.getAccessToken()),
    );

    _messageBloc = MessageBloc(MessageRepository());
  }

  @override
  Widget build(BuildContext context) {
    isArabic = Provider.of<LocaleProvider>(context).isArabic();
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.contact_us),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            kHe24,
            Padding(
              padding: kTinyAllPadding,
              child: Row(
                children: [
                  ResText(
                    AppLocalizations.of(context)!.your_contact_details,
                    textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 16.sp,
                          color: isDark
                              ? AppColors.primaryDark
                              : AppColors.primaryColor,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 0.2),
            BlocBuilder<UserDataBloc, UserDataState>(
                bloc: _userDataBloc,
                builder: (_, UserDataState userEditState) {
                  if (userEditState is UserDataError) {
                    return SizedBox(
                        width: 1.sw,
                        height: 1.sh - 75.h,
                        child: FetchResult(
                            content: AppLocalizations.of(context)!
                                .error_happened_when_executing_operation));
                  }
                  if (userEditState is UserDataProgress) {
                    return const DetailsShimmer();
                  }
                  if (userEditState is UserDataComplete) {
                    user = userEditState.user;
                    return buildDetails(isDark);
                  }
                  return Container();
                }),
            buildMessageContainer(isDark),
            kHe24,
            Center(
              child: BlocConsumer<MessageBloc, MessageState>(
                bloc: _messageBloc,
                listener: (_, messageState) {
                  if (messageState is SendMessageFetchComplete) {
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.complete_send,
                        toastLength: Toast.LENGTH_LONG);
                    messageController.clear();
                    Navigator.pop(context, true);
                  }
                },
                builder: (_, messageState) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(240.w, 64.h),
                      maximumSize: Size(300.w, 64.h),
                    ),
                    child: (messageState is SendMessageFetchProgress)
                        ? SpinKitWave(
                            color: AppColors.white,
                            size: 20.w,
                          )
                        : Text(AppLocalizations.of(context)!.send),
                    onPressed: () async {
                      _messageBloc.add(SendMessagesFetchStarted(
                        token: UserSharedPreferences.getAccessToken(),
                        message: messageCubit.state,
                      ));
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
            kHe24,
          ],
        ),
      ),
    );
  }

  Widget buildDetails(isDark) {
    return Column(
      children: [
        buildListTile(
            AppLocalizations.of(context)!.name, user!.firstName!, isDark),
        if (user!.email != null)
          buildListTile(
              AppLocalizations.of(context)!.email, user!.email!, isDark),
        buildListTile(AppLocalizations.of(context)!.telephone,
            user!.authentication!, isDark),
        if (user!.country != null)
          buildListTile(
              AppLocalizations.of(context)!.country, user!.country!, isDark),
      ],
    );
  }

  Widget buildListTile(leading, String title, isDark) {
    return Column(
      children: [
        Padding(
          padding: kSmallSymHeight,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ResText(
                  leading,
                  textStyle: Theme.of(context).textTheme.headline5!.copyWith(
                        height: 2.h,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            !isDark ? AppColors.primaryColor : AppColors.white,
                      ),
                ),
              ),
              kWi16,
              Expanded(
                flex: 3,
                child: ResText(
                  leading == AppLocalizations.of(context)!.telephone
                      ? isArabic
                          ? title.split("+")[1] + "+"
                          : title
                      : title,
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.2),
      ],
    );
  }

  Widget buildMessageContainer(isDark) {
    return Column(
      children: [
        kHe24,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              ResText(
                AppLocalizations.of(context)!.your_message + " :",
                textStyle: Theme.of(context).textTheme.headline5!.copyWith(
                      height: 2.h,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryColor,
                    ),
              ),
            ],
          ),
        ),
        kHe16,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            width: inf,
            padding: kSmallSymWidth,
            height: 250.h,
            decoration: BoxDecoration(
              borderRadius: smallBorderRadius,
              border: Border.all(color: Colors.black),
            ),
            child: TextField(
              maxLength: 600,
              controller: messageController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText:
                    AppLocalizations.of(context)!.message_notes_descriptions,
              ),
              maxLines: 8,
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
      ],
    );
  }
}
