import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/bloc/contacts_bloc/bloc/contacts_bloc.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/providers/locale_provider.dart';

class ContactsScreen extends StatefulWidget {
  static const String id = "/home/contacts";
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    context.read<ContactsBloc>().add(const ContactsFetch());
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.contacts,
        ),
      ),
      body: BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
        if (state is ContactsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ContactsData) {
          final contacts = state.contacts;
          final isRegisteredList = state.isRegistered;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              final isRegistered = isRegisteredList[index];
              return ContactWidget(
                contact: contact,
                isDark: isDark,
                isRegistered: isRegistered,
              );
            },
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }
}

extension StringExtension on String {
  String get fu {
    if (isEmpty) return "";

    return substring(0, 1).toUpperCase();
  }
}

class ContactWidget extends StatelessWidget {
  const ContactWidget({
    super.key,
    required this.contact,
    required this.isDark,
    required this.isRegistered,
  });

  final Contact contact;
  final bool isDark;
  final bool isRegistered;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        sendSms("hello%20world!");
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      leading: Container(
        alignment: Alignment.center,
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.white : AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          (contact.displayName ?? "").fu,
          style: TextStyle(
            color: isDark ? AppColors.black : AppColors.white,
            fontSize: 15.sp,
          ),
        ),
      ),
      title: Text(contact.displayName ?? ""),
      subtitle: Text(
        (contact.phones?.isNotEmpty ?? false)
            ? (contact.phones?.first.value ?? "")
            : "",
        textDirection: TextDirection.ltr,
        style: TextStyle(
          color: isDark ? AppColors.lightblue : Colors.black.withOpacity(0.75),
          fontSize: 12.sp,
        ),
      ),
      trailing: ContactButton(
          isRegistered: isRegistered,
          sendSms: () {
            sendSms(AppLocalizations.of(context)!.sms_download +
                "\nAndroid: https://swesshome.com/app/?s=an\niOS:https://swesshome.com/app/?s=ap");
          }),
    );
  }

  void sendSms(String smsBody) async {
    final String phone = (contact.phones?.isNotEmpty ?? false)
        ? (contact.phones?.first.value ?? "")
        : "";

    String url = "";

    if (Platform.isAndroid) {
      url = 'sms:+$phone?body=$smsBody';
    }
    if (Platform.isIOS) {
      url = "sms:$phone?body=$smsBody";
    }

    final Uri uri = Uri.parse(url);

    if (!(await canLaunchUrl(uri))) {
      return;
    }
    await launchUrl(uri);
  }
}

class ContactButton extends StatelessWidget {
  final bool isRegistered;
  final void Function() sendSms;
  const ContactButton({
    super.key,
    required this.isRegistered,
    required this.sendSms,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: isRegistered
            ? null
            : () {
                sendSms();
              },
        child: Text(isRegistered
            ? AppLocalizations.of(context)!.registered
            : AppLocalizations.of(context)!.send_invitation),
      ),
    );
  }
}
