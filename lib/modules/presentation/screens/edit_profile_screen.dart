import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_edit_data_bloc/edit_user_data_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_edit_data_bloc/edit_user_data_state.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/presentation/screens/profile_screen.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';

import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/user_edit_data_bloc/edit_user_data_event.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/governorates.dart';
import '../../data/models/user.dart';
import '../../data/providers/theme_provider.dart';
import '../../data/repositories/user_authentication_repository.dart';
import '../widgets/my_dropdown_list.dart';
import '../widgets/res_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.user, this.governorates})
      : super(key: key);

  static const String id = "EditProfileScreen";

  final User user;
  final List<Governorate>? governorates;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserEditDataBloc _userEditDataBloc;

  ChannelCubit authenticationError = ChannelCubit(null);
  ChannelCubit firstNameError = ChannelCubit(null);
  ChannelCubit lastNameError = ChannelCubit(null);

  //ChannelCubit emailError = ChannelCubit(null);
  ChannelCubit countryError = ChannelCubit(null);

  //ChannelCubit birthdateError = ChannelCubit(null);
  ChannelCubit isEditCubit = ChannelCubit(false);

  // controllers:
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  //TextEditingController emailController = TextEditingController();
  //TextEditingController birthdateController = TextEditingController();

  int? selectedGovernorateId;

  //DateTime? birthDate;
  late String phoneDialCodeLogin;
  String phoneNumber = "";
  String? token;
  late bool isDark;

  @override
  void initState() {
    _userEditDataBloc = UserEditDataBloc(UserAuthenticationRepository());
    token = UserSharedPreferences.getAccessToken()!;
    // birthdateController.text =
    //     birthdateController.text.isEmpty ? "" : birthdateController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          iconTheme:
              IconThemeData(color: isDark ? Colors.white : AppColors.black),
          backgroundColor: isDark ? const Color(0xff26282B) : AppColors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context)!.edit_profile,
            style: TextStyle(color: isDark ? Colors.white : AppColors.black),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context, false);
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Padding(
        padding: kMediumAllPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ResText(
                "${AppLocalizations.of(context)!.first_name} :",
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              kHe8,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: firstNameError,
                builder: (_, errorMessage) {
                  return TextField(
                    onChanged: (_) {
                      firstNameError.setState(null);
                      widget.user.firstName = firstNameController.text;
                      isEditCubit.setState(true);
                    },
                    controller: firstNameController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: widget.user.firstName,
                      suffix: null,
                      suffixIcon: null,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              kHe24,
              ResText(
                "${AppLocalizations.of(context)!.last_name} :",
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              kHe8,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: lastNameError,
                builder: (_, errorMessage) {
                  return TextField(
                    onChanged: (_) {
                      lastNameError.setState(null);
                      widget.user.lastName = lastNameController.text;
                      isEditCubit.setState(true);
                    },
                    controller: lastNameController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: widget.user.lastName,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              // kHe24,
              // ResText(
              //   AppLocalizations.of(context)!.email + " :",
              //   textStyle: Theme.of(context).textTheme.headline6,
              // ),
              // kHe8,
              // BlocBuilder<ChannelCubit, dynamic>(
              //   bloc: emailError,
              //   builder: (_, errorMessage) {
              //     return TextField(
              //       onChanged: (_) {
              //         emailError.setState(null);
              //         widget.user.email = emailController.text;
              //         isEditCubit.setState(true);
              //       },
              //       controller: emailController,
              //       decoration: InputDecoration(
              //         errorText: errorMessage,
              //         hintText: widget.user.email,
              //         isCollapsed: false,
              //       ),
              //     );
              //   },
              // ),
              widget.governorates != null
                  ? Column(
                      children: [
                        kHe24,
                        Row(
                          children: [
                            ResText(
                              AppLocalizations.of(context)!.governorate + " :",
                              textStyle: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                        kHe8,
                        BlocBuilder<ChannelCubit, dynamic>(
                          bloc: countryError,
                          builder: (_, errorMessage) {
                            for (int i = 0;
                                i < widget.governorates!.length;
                                i++) {
                              // print(governorates!.elementAt(i).name);
                              if (widget.governorates!.elementAt(i).name ==
                                  widget.user.governorate) {
                                selectedGovernorateId = i + 1;
                                print(widget.governorates!.elementAt(i).name);
                                print(selectedGovernorateId);
                              }
                            }
                            return MyDropdownList(
                              elementsList: widget.governorates!
                                  .map((e) => e.name)
                                  .toList(),
                              onSelect: (index) {
                                selectedGovernorateId = index + 1;
                                widget.user.governorate =
                                    widget.governorates!.elementAt(index).name;
                                isEditCubit.setState(true);
                              },
                              validator: (value) => value == null
                                  ? AppLocalizations.of(context)!
                                      .this_field_is_required
                                  : null,
                              selectedItem: widget.user.governorate,
                            );
                          },
                        ),
                      ],
                    )
                  : SizedBox(),
              // kHe24,
              // ResText(
              //   AppLocalizations.of(context)!.date_of_birth + " :",
              //   textStyle: Theme.of(context).textTheme.headline6,
              // ),
              // kHe8,
              // BlocBuilder<ChannelCubit, dynamic>(
              //   bloc: birthdateError,
              //   builder: (_, errorMessage) {
              //     return TextField(
              //       onTap: () async {
              //         await myDatePicker(
              //           context,
              //           showTitleActions: true,
              //           minTime: DateTime(1900, 1, 1),
              //           maxTime: DateTime.now(),
              //           onConfirm: (date) {
              //             birthDate = date;
              //             birthdateController.text =
              //                 DateHelper.getDateByFormat(date, 'yyyy/MM/dd');
              //             widget.user.birthdate = birthdateController.text;
              //             isEditCubit.setState(true);
              //           },
              //           currentTime: DateTime.now(),
              //           editingController: birthdateController,
              //         );
              //       },
              //       readOnly: true,
              //       controller: birthdateController,
              //       decoration: InputDecoration(
              //         errorText: errorMessage,
              //         hintText: birthdateController.text.isEmpty
              //             ? ""
              //             : DateHelper.getDateByFormat(
              //                 DateTime.parse(widget.user.birthdate!),
              //                 'yyyy/MM/dd'),
              //         isCollapsed: false,
              //       ),
              //     );
              //   },
              // ),
              kHe32,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: isEditCubit,
                builder: (_, editState) {
                  return editState
                      ? Center(
                          child:
                              BlocConsumer<UserEditDataBloc, UserEditDataState>(
                            bloc: _userEditDataBloc,
                            listener: (_, sendState) {
                              if (sendState is UserEditDataComplete) {
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .complete_edit,
                                    toastLength: Toast.LENGTH_LONG);
                                Navigator.pop(context, true);
                              }
                            },
                            builder: (_, sendState) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(240.w, 50.h),
                                  maximumSize: Size(300.w, 50.h),
                                ),
                                child: (sendState is UserEditDataProgress)
                                    ? SpinKitWave(
                                        color: AppColors.white,
                                        size: 20.w,
                                      )
                                    : Text(AppLocalizations.of(context)!.send),
                                onPressed: () async {
                                  _userEditDataBloc.add(
                                    UserEditDataStarted(
                                      user: Register(
                                          firstName: widget.user.firstName!,
                                          lastName: widget.user.lastName!,
                                          //email: widget.user.email!,
                                          governorate: selectedGovernorateId,
                                          //birthdate: widget.user.birthdate!,
                                          authentication:
                                              widget.user.authentication!),
                                      token: token,
                                    ),
                                  );
                                  //FocusScope.of(context).unfocus();
                                  if (sendState is UserEditDataComplete) {
                                    MySnackBar.show(
                                        context, "تم التعديل بنجاح");

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ProfileScreen()));
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
