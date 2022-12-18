import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/notifications_shimmer.dart';

import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_bloc.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_event.dart';
import '../../business_logic_components/bloc/user_data_bloc/user_data_state.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_authentication_repository.dart';
import '../widgets/fetch_result.dart';
import '../widgets/shimmers/details_shimmer.dart';
import '../widgets/shimmers/profile_shimmer.dart';

class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({Key? key}) : super(key: key);

  @override
  State<CreateMessageScreen> createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  TextEditingController messageController = TextEditingController();

  UserDataBloc? _userDataBloc;
  User? user;

  @override
  void initState() {
    super.initState();
    if (UserSharedPreferences.getAccessToken() != null) {
      _userDataBloc = UserDataBloc(UserAuthenticationRepository());
    }
    if (UserSharedPreferences.getAccessToken() != null) {
      _userDataBloc!.add(
        UserDataStarted(token: UserSharedPreferences.getAccessToken()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.contact_us),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.send,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: AppColors.white),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            kHe24,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.your_contact_details,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 16,
                          color: AppColors.primaryColor,
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
                    return buildDetails();
                  }
                  return Container();
                }),
            buildMessageContainer(),
          ],
        ),
      ),
    );
  }

  Widget buildDetails() {
    return Column(
      children: [
        buildListTile(AppLocalizations.of(context)!.name, user!.firstName),
        buildListTile(AppLocalizations.of(context)!.email, user!.email),
        buildListTile(AppLocalizations.of(context)!.telephone, user!.authentication),
        buildListTile(AppLocalizations.of(context)!.country, user!.country),
      ],
    );
  }

  Widget buildListTile(leading, title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  leading,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        height: 2,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                ),
              ),
              kWi16,
              Expanded(
                flex: 3,
                child: Text(
                  title,
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.2),
      ],
    );
  }

  Widget buildMessageContainer() {
    return Column(
      children: [
        kHe24,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.your_message + " :",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      height: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
              ),
            ],
          ),
        ),
        kHe16,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: inf,
            padding: kSmallSymWidth,
            height: 250.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                hintText: AppLocalizations.of(context)!
                    .order_create_notes_descriptions,
              ),
              maxLines: 8,
            ),
          ),
        ),
      ],
    );
  }
}
