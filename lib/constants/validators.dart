import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  } else if (password.length > 21) {
    return AppLocalizations.of(context)!.password_must;
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
