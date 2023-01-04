import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_edit_data_bloc/edit_user_data_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_edit_data_bloc/edit_user_data_state.dart';
import 'package:swesshome/modules/data/models/register.dart';
import 'package:swesshome/modules/presentation/widgets/date_picker.dart';

import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_bloc.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_event.dart';
import '../../business_logic_components/bloc/governorates_bloc/governorates_state.dart';
import '../../business_logic_components/bloc/user_edit_data_bloc/edit_user_data_event.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/governorates.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_authentication_repository.dart';
import '../widgets/my_dropdown_list.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key, this.user}) : super(key: key);

  static const String id = "EditProfileScreen";

  User? user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserEditDataBloc _userEditDataBloc;
  late GovernoratesBloc governoratesBloc;
  ChannelCubit authenticationError = ChannelCubit(null);
  ChannelCubit firstNameError = ChannelCubit(null);
  ChannelCubit lastNameError = ChannelCubit(null);
  ChannelCubit emailError = ChannelCubit(null);
  ChannelCubit countryError = ChannelCubit(null);
  ChannelCubit birthdateError = ChannelCubit(null);

  // controllers:
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();

  int? selectedGovernorateId;
  DateTime? birthDate;
  late String phoneDialCodeLogin;
  String phoneNumber = "";
  String? token;
  List<Governorate>? governorates;

  @override
  void initState() {
    //_userEditDataBloc = BlocProvider.of<UserEditDataBloc>(context);
    _userEditDataBloc = UserEditDataBloc(UserAuthenticationRepository());
    governoratesBloc = BlocProvider.of<GovernoratesBloc>(context);
    governoratesBloc.add(GovernoratesFetchStarted());
    token = UserSharedPreferences.getAccessToken()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.first_name + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
              kHe8,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: firstNameError,
                builder: (_, errorMessage) {
                  return TextField(
                    onChanged: (_) {
                      firstNameError.setState(null);
                      widget.user!.firstName = firstNameController.text;
                    },
                    controller: firstNameController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: widget.user!.firstName,
                      suffix: null,
                      suffixIcon: null,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              kHe24,
              Text(
                AppLocalizations.of(context)!.last_name + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
              kHe8,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: lastNameError,
                builder: (_, errorMessage) {
                  return TextField(
                    onChanged: (_) {
                      lastNameError.setState(null);
                      widget.user!.lastName = lastNameController.text;
                    },
                    controller: lastNameController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: widget.user!.lastName,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              kHe24,
              Text(
                AppLocalizations.of(context)!.email + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
              kHe8,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: emailError,
                builder: (_, errorMessage) {
                  return TextField(
                    onChanged: (_) {
                      emailError.setState(null);
                      widget.user!.email = emailController.text;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: widget.user!.email,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              if (widget.user!.country == "Syrian Arab Republic")
                BlocBuilder<GovernoratesBloc, dynamic>(
                    bloc: governoratesBloc,
                    builder: (_, state) {
                      if (state is GovernoratesFetchComplete) {
                        governorates = state.governorates;
                        if (widget.user!.country == "Syrian Arab Republic") {
                          for (int i = 0;
                              i < governoratesBloc.governorates!.length;
                              i++) {
                           // print(governorates!.elementAt(i).name);
                            if (governorates!.elementAt(i).name ==
                                widget.user!.governorate) {
                              selectedGovernorateId = i + 1;
                              print(governorates!.elementAt(i).name);
                              print(selectedGovernorateId);
                            }
                          }
                        }
                      }
                      return Column(
                        children: [
                          kHe24,
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.governorate +
                                    " :",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          kHe8,
                          BlocBuilder<ChannelCubit, dynamic>(
                            bloc: countryError,
                            builder: (_, errorMessage) {
                              return MyDropdownList(
                                elementsList:
                                    governorates!.map((e) => e.name).toList(),
                                onSelect: (index) {
                                  selectedGovernorateId = index + 1;
                                  widget.user!.governorate =
                                      governorates!.elementAt(index).name;
                                  print(selectedGovernorateId);
                                },
                                // validator: (value) => value == null
                                //     ? AppLocalizations.of(context)!.this_field_is_required
                                //     : null,
                                selectedItem: widget.user!.governorate,
                              );
                            },
                          ),
                        ],
                      );
                    }),
              kHe24,
              Text(
                AppLocalizations.of(context)!.date_of_birth + " :",
                style: Theme.of(context).textTheme.headline6,
              ),
              kHe8,
              BlocBuilder<ChannelCubit, dynamic>(
                bloc: birthdateError,
                builder: (_, errorMessage) {
                  return TextField(
                    onTap: () async {
                      await myDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime.now(),
                        onConfirm: (date) {
                          birthDate = date;
                          birthdateController.text =
                              DateFormat('yyyy/MM/dd').format(date);
                          widget.user!.birthdate = birthdateController.text;
                        },
                        currentTime: DateTime.now(),
                        editingController: birthdateController,
                      );
                    },
                    readOnly: true,
                    controller: birthdateController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: widget.user!.birthdate!,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              kHe32,
              Center(
                child: BlocBuilder<UserEditDataBloc, UserEditDataState>(
                  bloc: _userEditDataBloc,
                  builder: (_, sendState) {
                    if (sendState is UserEditDataComplete) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.complete_edit,
                          toastLength: Toast.LENGTH_LONG);
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240.w, 64.h),
                        maximumSize: Size(300.w, 64.h),
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
                                  firstName: widget.user!.firstName!,
                                  lastName: widget.user!.lastName!,
                                  email: widget.user!.email!,
                                  governorate: selectedGovernorateId,
                                  birthdate: widget.user!.birthdate!,
                                  authentication: widget.user!.authentication!),
                              token: token),
                        );
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
