import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? firstNameValidator(String? firstName, BuildContext context) {
  if (firstName?.isEmpty ?? false) {
    return AppLocalizations.of(context)!.please_enter_your_first_name;
  }
  return null;
}

String? lastNameValidator(String? lastName, BuildContext context) {
  if (lastName?.isEmpty ?? false) {
    return AppLocalizations.of(context)!.please_enter_your_last_name;
  }
  return null;
}

String passwordValidator({String? password, BuildContext? context}) {
  if (password!.isEmpty) {
    return "Please enter your password";
  } else if (password.length < 6) {
    return "password must be at least 6 characters";
  }
  return "";
}

String confirmPasswordValidator(
    {String? password, String? confirmPassword, BuildContext? context}) {
  if (confirmPassword!.isEmpty) {
    return "Please enter your password";
  } else if (confirmPassword.length < 6) {
    return "password must be at least 6 characters";
  } else if (password != confirmPassword) {
    return "Password don't match";
  }
  return "";
}

String? passwordValidator1(String? password, BuildContext context) {
  if (password!.isEmpty) {
    return AppLocalizations.of(context)!.enter_password;
  } else if (password.length < 6) {
    return AppLocalizations.of(context)!.password_least;
  }

  return null;
}

String? confirmPasswordValidator1(
    String? password, BuildContext context, String? confirmPassword) {
  if (confirmPassword!.isEmpty) {
    return AppLocalizations.of(context)!.enter_password;
  } else if (password != confirmPassword) {
    return AppLocalizations.of(context)!.password_match;
  }
  return null;
}

String? emailValidator(String? email, BuildContext context) {
  if (email?.isEmpty ?? false) {
    return AppLocalizations.of(context)!.enter_your_email;
  } else if (email?.isEmailNotVaild ?? false) {
    return AppLocalizations.of(context)!.invalidEmail;
  }
  return null;
}

extension StringExtension on String {
  bool get isEmailNotVaild {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    return !RegExp(p).hasMatch(this);
  }
}
