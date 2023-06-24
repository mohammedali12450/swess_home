import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/core/functions/validators.dart';
import 'package:swesshome/modules/business_logic_components/bloc/contact_us/contact_us_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/contact_us/contact_us_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/contact_us/contact_us_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/data/repositories/contact_us_repository.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/text_field_widget.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/my_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';


class ContacttUsBody extends StatefulWidget {
  ContacttUsBody({super.key});

  @override
  State<ContacttUsBody> createState() => _ContacttUsBodyState();
}

class _ContacttUsBodyState extends State<ContacttUsBody> {

  late ContactUsBloc contactUsBloc;
  ChannelCubit emailError = ChannelCubit(null);
  ChannelCubit titleError = ChannelCubit(null);
  ChannelCubit messageError = ChannelCubit(null);

  // controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController messageTitleController = TextEditingController();
  TextEditingController messageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    contactUsBloc = BlocProvider.of<ContactUsBloc>(context);
  }

  Future<bool> getFieldsValidation() async {
    bool isValidationSuccess = true;
    if (emailController.text.isEmpty) {
      MySnackBar.show(
          context, AppLocalizations.of(context)!.please_write_email);
      emailError.setState(null);
      return false;
    } else if(emailValidator(emailController.text, context) != null) {
      MySnackBar.show(
          context, AppLocalizations.of(context)!.invalidEmail);
      emailError.setState(null);
      return false;
    }
    else if(messageTitleController.text.isEmpty) {
      MySnackBar.show(
          context, AppLocalizations.of(context)!.please_write_title_message);
      titleError.setState(null);
      return false;
    } else if (messageController.text.isEmpty) {
      MySnackBar.show(
          context, AppLocalizations.of(context)!.please_write_message);
      messageError.setState(null);
      return false;
    }
    return isValidationSuccess;
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0;
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return BlocListener<ContactUsBloc, ContactUsState>(
      listener: (_, sendState) async {
        if (sendState is ContactUsError) {
          if (sendState.isConnectionError) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              AppLocalizations.of(context)!.no_internet_connection,
            );
            return;
          }
          if (sendState.errorMessage != null) {
            showWonderfulAlertDialog(
              context,
              AppLocalizations.of(context)!.error,
              sendState.errorMessage!,
              defaultButtonContent: AppLocalizations.of(context)!.ok,
            );
          }
        }
        if (sendState is ContactUsComplete) {
          MySnackBar.show(
              context, AppLocalizations.of(context)!.complete_send);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            Navigator.of(context).pop();
          });
          // Navigator.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: 1.sw,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: 1.sw,
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: isDark ? const Color(0xff26282B) : Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                          size: 28.w,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        AppLocalizations.of(context)!.contact_us,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.transparent,
                          size: 28.w,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                top: (isKeyboardOpened) ? 0 : 120.h,
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                      borderRadius: highBorderRadius,
                      color: isDark ? AppColors.secondaryDark : AppColors.white),
                  child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          kHe20,
                          ResText(AppLocalizations.of(context)!.welcome,
                            textStyle: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.lightGreyColor,fontSize: 15),
                          ),
                          kHe32,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ResText("${AppLocalizations.of(context)!.to_contact_us}:",
                                      textStyle: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.lightGreyColor,fontSize: 12),
                                    ),
                                  ],
                                ),
                                kHe20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        launch(
                                          "tel://" + "011 222 9 956",
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.only(bottom: 3.0.h),
                                            child: Icon(
                                              Icons.call,
                                              color: AppColors.blue,
                                              size: 20.w,
                                            ),
                                          ),
                                          kWi8,
                                          ResText(
                                              "+963 11 222 9 956",
                                              textStyle: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.blue, fontSize: 14.sp)
                                          ),
                                        ],
                                      ),
                                    ),
                                    kWi8,
                                    InkWell(
                                      onTap: () {
                                        launch(
                                          "tel://" + "0954 150 771",
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.only(bottom: 3.0.h),
                                            child: Icon(
                                              Icons.phone_android,
                                              color: AppColors.blue,
                                              size: 20.w,
                                            ),
                                          ),
                                          kWi8,
                                          ResText(
                                              "+963 954 150 771",
                                              textStyle: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.blue, fontSize: 14.sp)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                kHe20,
                                Row(
                                  children: [
                                    ResText("${AppLocalizations.of(context)!.to_contact_us_social}:",
                                      textStyle: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.lightGreyColor,fontSize: 12),
                                    ),
                                  ],
                                ),
                                kHe20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          launch(
                                            "https://" + "wa.me/message/HUX47RG3PB5ND1",
                                          );
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: AppColors.lightGrey2Color.withOpacity(0.3),
                                              borderRadius: lowBorderRadius,
                                              border: Border.all(color: AppColors.lightGreyColor)
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(whatsappPath,color: AppColors.blue,width: 35,),
                                          ),
                                        )
                                    ),
                                    kWi8,
                                    InkWell(
                                        onTap: () {
                                          launch(
                                            "https://" + "www.facebook.com/Swesshome",
                                          );
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: AppColors.lightGrey2Color.withOpacity(0.3),
                                              borderRadius: lowBorderRadius,
                                              border: Border.all(color: AppColors.lightGreyColor)
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(messengerPath,color: AppColors.blue,width: 35,),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                                kHe20,
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: lowBorderRadius,
                                      border: Border.all(color: AppColors.lightGreyColor),
                                      color: AppColors.lightGrey2Color.withOpacity(0.3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ResText("${AppLocalizations.of(context)!.to_contact_us_mail}:",
                                                textStyle: Theme.of(context).textTheme.headline5!.copyWith(color: AppColors.lightGreyColor,fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          kHe12,
                                          BlocBuilder<ChannelCubit, dynamic>(
                                            bloc: emailError,
                                            builder: (_,errorMessage) {
                                              return TextFieldWidget(
                                                width: MediaQuery.of(context).size.width,
                                                height: 45,
                                                textEditingController: emailController,
                                                hintText: AppLocalizations.of(context)!.please_write_email,
                                                onTap: () {},
                                                onChanged: (_) {
                                                  emailError.setState(null);
                                                },
                                              );
                                            },
                                          ),
                                          kHe12,
                                          BlocBuilder<ChannelCubit, dynamic>(
                                            bloc: titleError,
                                            builder: (_,errorMessage) {
                                              return TextFieldWidget(
                                                width: MediaQuery.of(context).size.width,
                                                height: 45,
                                                textEditingController: messageTitleController,
                                                hintText: AppLocalizations.of(context)!.please_write_title_message,
                                                onTap: () {},
                                                onChanged: (_) {
                                                  titleError.setState(null);
                                                },
                                              );
                                            },
                                          ),
                                          kHe12,
                                          BlocBuilder<ChannelCubit, dynamic>(
                                            bloc: messageError,
                                            builder: (_,errorMessage) {
                                              return TextFieldWidget(
                                                width: MediaQuery.of(context).size.width,
                                                height: 100,
                                                padding: const EdgeInsets.only(top: 10,bottom: 5),
                                                textEditingController: messageController,
                                                hintText: AppLocalizations.of(context)!.please_write_message,
                                                onTap: () {},
                                                maxLength: 400,
                                                maxLines: 8,
                                                onChanged: (_) {
                                                  messageError.setState(null);
                                                },
                                              );
                                            },
                                          ),
                                          kHe12,

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: const Size(150, 50),
                                                    backgroundColor: AppColors.blue
                                                ),
                                                child: BlocBuilder<ContactUsBloc, ContactUsState>(
                                                  builder: (_, sendState) {
                                                    if (sendState is ContactUsProgress) {
                                                      return SpinKitWave(
                                                        color: Theme.of(context).colorScheme.background,
                                                        size: 24.w,
                                                      );
                                                    }
                                                    return Text(
                                                      AppLocalizations.of(context)!.send,
                                                    );
                                                  },
                                                ),
                                                onPressed: () async{
                                                  if (!await getFieldsValidation()) {
                                                    return;
                                                  }
                                                  contactUsBloc.add(
                                                    ContactUsStarted(
                                                        email: emailController.text,
                                                        subject: messageTitleController.text,
                                                        message: messageController.text
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
