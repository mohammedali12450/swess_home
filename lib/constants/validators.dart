import 'package:flutter/cupertino.dart';

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
  if (password == null) {
    return 'Required field';
  } else if (password.isEmpty) {
    return "Please enter your password";
  } else if (password.length < 6) {
    return "password must be at least 6 characters";
  } else if (password.length > 21) {
    return "password must be at most 21 characters";
  }
  return null;
}

String? confirmPasswordValidator1(
    String password, BuildContext context, String? confirmPassword) {
  if (confirmPassword == null) {
    return 'Required field';
  } else if (confirmPassword.isEmpty) {
    return "Please enter your password";
  } else if (confirmPassword.length < 6) {
    return "password must be at least 6 characters";
  } else if (password != confirmPassword) {
    return "password must be at least 6 characters";
  } else if (password.length > 21) {
    return "password must be at most 21 characters";
  }
  return null;
}
