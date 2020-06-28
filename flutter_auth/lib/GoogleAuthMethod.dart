import 'dart:convert';

import 'package:sercl_customer/support/Auth/AuthProviderUser.dart';

import 'AppException.dart';
import 'AuthMethod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthMethod implements AuthMethod {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  @override
  String serviceName;
  String id;
  AuthProviderUser user;

  GoogleAuthMethod() {
    this.serviceName = 'google';
  }

  @override
  Future<AuthProviderUser> auth() async {
    if (this.user != null) {
      return this.user;
    }

    GoogleSignInAuthentication auth;
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      auth = await account.authentication;
      id = _googleSignIn.currentUser.id;
      print(id);
    } catch (e, s) {
      new AppException(true,
          name: "googleAuthFailed",
          code: 500,
          beautifulMsg: "Google Signing didn't work",
          uglyMsg: s.toString());
    }
    Map<String, String> creds = {
      "accessToken": auth.accessToken,
      "idToken": id,
    };
    this.user = AuthProviderUser().fromJson(creds);
    return this.user;
  }

  @override
  Future<void> logout() async {
    _googleSignIn.disconnect();
  }
}
