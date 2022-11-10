import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/modules/presentation/widgets/date_picker.dart';

import '../../../constants/design_constants.dart';
import '../../business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../widgets/my_dropdown_list.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {Key? key,
      this.firstNameController,
      this.lastNameController,
      this.emailController,
      this.birthdateController}) : super(key: key);

  static const String id = "EditProfileScreen";

  // controllers:
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? birthdateController;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ChannelCubit authenticationError = ChannelCubit(null);
  ChannelCubit firstNameError = ChannelCubit(null);
  ChannelCubit lastNameError = ChannelCubit(null);
  ChannelCubit emailError = ChannelCubit(null);
  ChannelCubit countryError = ChannelCubit(null);
  ChannelCubit birthdateError = ChannelCubit(null);

  late String phoneDialCode;
  String userCountry = "Syrian Arab Republic";
  late int selectedGovernorateId;
  DateTime? birthDate;
  late String phoneDialCodeLogin;
  String phoneNumber = "";

  // Others :
  bool isForStore = false;

  @override
  void initState() {
    super.initState();
    // Dial code initializing:
    isForStore = BlocProvider.of<SystemVariablesBloc>(context)
        .systemVariables!
        .isForStore;
    if (isForStore) {
      phoneDialCode = "+961";
      phoneDialCodeLogin = "+961";
    } else {
      phoneDialCode = "+963";
      phoneDialCodeLogin = "+963";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
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
                    },
                    controller: widget.firstNameController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: AppLocalizations.of(context)!.enter_first_name,
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
                    },
                    controller: widget.lastNameController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: AppLocalizations.of(context)!.enter_last_name,
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
                    },
                    controller: widget.emailController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText: AppLocalizations.of(context)!.enter_your_email,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              if (userCountry == "Syrian Arab Republic") ...[
                kHe24,
                Text(
                  AppLocalizations.of(context)!.governorate + " :",
                  style: Theme.of(context).textTheme.headline6,
                ),
                kHe8,
                BlocBuilder<ChannelCubit, dynamic>(
                  bloc: countryError,
                  builder: (_, errorMessage) {
                    return MyDropdownList(
                      elementsList: const ["ghina", "ghina", "ghina"],
                      onSelect: (index) {
                        selectedGovernorateId = index;
                      },
                      // validator: (value) => value == null
                      //     ? AppLocalizations.of(context)!.this_field_is_required
                      //     : null,
                      selectedItem: AppLocalizations.of(context)!.please_select,
                    );
                  },
                ),
              ],
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
                    onTap: () async{
                      await myDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime.now(),
                        onConfirm: (date) {},
                        currentTime: DateTime.now(),
                        editingController: widget.birthdateController,
                      );
                    },
                    readOnly: true,
                    controller: widget.birthdateController,
                    decoration: InputDecoration(
                      errorText: errorMessage,
                      hintText:
                          AppLocalizations.of(context)!.enter_your_birth_date,
                      isCollapsed: false,
                    ),
                  );
                },
              ),
              kHe32,
              Center(
                  child: ElevatedButton(
                      onPressed: () {

                      },
                      child: Text(AppLocalizations.of(context)!.save))),
            ],
          ),
        ),
      ),
    );
  }
}
