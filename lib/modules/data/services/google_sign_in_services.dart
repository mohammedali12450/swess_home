import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<String?> login() async {
    try {
      final googleAccount = await _googleSignIn.signIn();

      if (googleAccount == null) return null;

      final googleAuth = await googleAccount.authentication;

      log(googleAuth.accessToken ?? '', name: "Token Social");

      return googleAuth.accessToken;
    } catch (error) {
      log(error.toString(), name: "SOCIAL AUTH");
    }
    return null;
  }

  Future<String?> refreshToken() async {
    try {
      final googleAccount = await _googleSignIn.signInSilently();

      if (googleAccount == null) return null;

      final googleAuth = await googleAccount.authentication;

      log(googleAuth.accessToken ?? '', name: "Token Social");

      return googleAuth.accessToken;
    } catch (error) {
      log(error.toString(), name: "SOCIAL AUTH");
    }
    return null;
  }

  Future<void> logout() async {
    try {
      _googleSignIn.disconnect();
    } catch (error) {
      log(error.toString(), name: "SOCIAL AUTH");
    }
  }
}
