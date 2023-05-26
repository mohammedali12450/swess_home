import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phone_number/phone_number.dart';
import 'package:swesshome/constants/formatters.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';

import '../../../constants/assets_paths.dart';
import '../../../constants/design_constants.dart';
import '../../../core/functions/validators.dart';
import '../../business_logic_components/bloc/change_password_bloc/change_password_bloc.dart';
import '../../business_logic_components/bloc/change_password_bloc/change_password_event.dart';
import '../../business_logic_components/bloc/change_password_bloc/change_password_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/repositories/user_authentication_repository.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChannelCubit officePhoneError = ChannelCubit(null);
  final ChannelCubit officePhoneErrorLogin = ChannelCubit(null);
  final ChannelCubit systemPasswordError = ChannelCubit(null);
  final ChannelCubit officeTelephoneError = ChannelCubit(null);
  late ChangePasswordBloc changePasswordBloc;

  /// added new
  final ChannelCubit _oldPasswordVisibilityCubit = ChannelCubit(false);
  final ChannelCubit _newPasswordVisibilityCubit = ChannelCubit(false);
  ChannelCubit oldPasswordError = ChannelCubit(null);
  ChannelCubit newPasswordError = ChannelCubit(null);


// Controllers:
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  // Other:
  late String phoneDialCode;
  PhoneNumber? phoneNumber;
  bool isForStore = false;
  late String phoneDialCodeLogin;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    changePasswordBloc = ChangePasswordBloc(UserAuthenticationRepository());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Container(
        width: 1.sw,
        height: 1.sh,
        color: Theme.of(context).colorScheme.secondary,
        child: Stack(
          children: [
            ...kBackgroundDrawings(context),
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  40.verticalSpace,
                  SizedBox(
                    width: 200.w,
                    height: 200.w,
                    child: CircleAvatar(
                      child: Image.asset(swessHomeIconPath),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                    ),
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: buildFieldWidget(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.verticalSpace,
        ResText(
          "${AppLocalizations.of(context)!.old_password} :",
          textStyle: Theme.of(context).textTheme.headline6,
        ),
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: oldPasswordError,
          builder: (_, errorMessage) {
            return BlocBuilder<ChannelCubit, dynamic>(
              bloc: _oldPasswordVisibilityCubit,
              builder: (context, isVisible) {
                return TextField(
                  onChanged: (value) {
                    oldPasswordError.setState(null);
                  },
                  controller: oldPasswordController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    onlyEnglishLetters,
                  ],
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText: AppLocalizations.of(context)!.enter_your_old_password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        (!isVisible)
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onPressed: () {
                        _oldPasswordVisibilityCubit.setState(!isVisible);
                      },
                    ),
                    isCollapsed: false,
                  ),
                );
              },
            );
          },
        ),
        // TextFormField(
        //   textDirection: TextDirection.ltr,
        //   cursorColor: Theme.of(context).colorScheme.onBackground,
        //   controller: oldPasswordController,
        //   keyboardType: TextInputType.text,
        //   decoration: InputDecoration(
        //     hintText: AppLocalizations.of(context)!.enter_your_old_password,
        //   ),
        // ),
        20.verticalSpace,
        ResText(
          "${AppLocalizations.of(context)!.new_password} :",
          textStyle: Theme.of(context).textTheme.headline6,
        ),
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: newPasswordError,
          builder: (_, errorMessage) {
            return BlocBuilder<ChannelCubit, dynamic>(
              bloc: _newPasswordVisibilityCubit,
              builder: (context, isVisible) {
                return TextField(
                  onChanged: (value) {
                    newPasswordError.setState(null);
                  },
                  controller: newPasswordController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    onlyEnglishLetters,
                  ],
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText: AppLocalizations.of(context)!.enter_your_new_password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        (!isVisible)
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onPressed: () {
                        _newPasswordVisibilityCubit.setState(!isVisible);
                      },
                    ),
                    isCollapsed: false,
                  ),
                );
              },
            );
          },
        ),
        // TextFormField(
        //   validator: (value) {
        //     return passwordValidator1(value, context);
        //   },
        //   textDirection: TextDirection.ltr,
        //   cursorColor: Theme.of(context).colorScheme.onBackground,
        //   controller: newPasswordController,
        //   keyboardType: TextInputType.text,
        //   decoration: InputDecoration(
        //     hintText: AppLocalizations.of(context)!.enter_your_new_password,
        //   ),
        // ),
        56.verticalSpace,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(180.w, 60.h),
              maximumSize: Size(200.w, 60.h),
            ),
            onPressed: () async {
              changePasswordBloc.add(
                ChangePasswordStarted(
                  newPassword: newPasswordController.text,
                  oldPassword: oldPasswordController.text,
                  token: UserSharedPreferences.getAccessToken()!,
                ),
              );
            },
            child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
              bloc: changePasswordBloc,
              builder: (_, forgetState) {
                if (forgetState is ChangePasswordProgress) {
                  return IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sending,
                        ),
                        12.horizontalSpace,
                        SpinKitWave(
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20.w,
                        ),
                      ],
                    ),
                  );
                }
                return Text(
                  AppLocalizations.of(context)!.send,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
